// ============================================================================
// HCPU UART Transmitter — hcpu_uart_tx.v
// Simple 8N1 UART TX for PRINT/EMIT instructions
// (c) 2026 HMCL — HM-28-v1.2-HC18D
// ============================================================================
//
// Baud rate configurable via parameter (default 115200 @ 50 MHz).
// Pipeline stalls while tx_busy is asserted.
//

module hcpu_uart_tx #(
    parameter CLK_HZ   = 50_000_000,
    parameter BAUD     = 115200
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  tx_data,    // Byte to transmit
    input  wire        tx_start,   // Pulse high to begin transmission
    output reg         tx_out,     // UART TX line (active)
    output wire        tx_busy     // High while transmitting
);

    localparam CLKS_PER_BIT = CLK_HZ / BAUD;
    localparam CNT_W = $clog2(CLKS_PER_BIT + 1);

    // ── State machine ───────────────────────────────────────────
    localparam S_IDLE  = 2'd0;
    localparam S_START = 2'd1;
    localparam S_DATA  = 2'd2;
    localparam S_STOP  = 2'd3;

    reg [1:0]       state;
    reg [CNT_W-1:0] clk_cnt;
    reg [2:0]       bit_idx;
    reg [7:0]       tx_shift;

    assign tx_busy = (state != S_IDLE);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= S_IDLE;
            clk_cnt  <= 0;
            bit_idx  <= 0;
            tx_shift <= 8'h00;
            tx_out   <= 1'b1;  // Idle high
        end else begin
            case (state)
                S_IDLE: begin
                    tx_out <= 1'b1;
                    if (tx_start) begin
                        tx_shift <= tx_data;
                        state    <= S_START;
                        clk_cnt  <= 0;
                    end
                end

                S_START: begin
                    tx_out <= 1'b0;  // Start bit
                    if (clk_cnt == CLKS_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        bit_idx <= 0;
                        state   <= S_DATA;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                S_DATA: begin
                    tx_out <= tx_shift[bit_idx];
                    if (clk_cnt == CLKS_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        if (bit_idx == 3'd7) begin
                            state <= S_STOP;
                        end else begin
                            bit_idx <= bit_idx + 1;
                        end
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                S_STOP: begin
                    tx_out <= 1'b1;  // Stop bit
                    if (clk_cnt == CLKS_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        state   <= S_IDLE;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
