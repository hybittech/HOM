## ============================================================================
## HCPU Xilinx Constraints — hcpu_xilinx.xdc
## Target: Digilent Arty A7-35T (XC7A35T-1CPG236C)
## (c) 2026 HMCL
## ============================================================================

## ── Clock (100 MHz) ─────────────────────────────────────────────
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk_100m }]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk_100m }]

## ── Reset Button (BTN0, active high) ────────────────────────────
set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { btn_rst }]

## ── UART TX (USB-FTDI) ──────────────────────────────────────────
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_txd }]

## ── LEDs (active high) ──────────────────────────────────────────
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { led[0] }]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { led[1] }]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { led[2] }]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]

## ── Timing constraints ──────────────────────────────────────────
## Output delay for UART TX (relaxed — UART is slow)
set_output_delay -clock sys_clk_pin -max 5.0 [get_ports { uart_txd }]
set_output_delay -clock sys_clk_pin -min 0.0 [get_ports { uart_txd }]

## Input delay for reset button
set_input_delay  -clock sys_clk_pin -max 5.0 [get_ports { btn_rst }]

## ── False paths ─────────────────────────────────────────────────
## LED outputs are not timing-critical
set_false_path -to [get_ports { led[*] }]

## ── Bitstream configuration ─────────────────────────────────────
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
