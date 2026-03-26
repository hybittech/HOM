import Navbar from './Navbar';

export default function Layout({ children }) {
  return (
    <div className="min-h-screen bg-hom-bg flex flex-col">
      <Navbar />
      <div className="max-w-[1400px] mx-auto px-4 md:px-8 w-full flex justify-start py-2">
        <h1 className="text-[10px] tracking-[0.2em] font-bold uppercase opacity-70">
          Hijaiyyah Operating Machine
        </h1>
      </div>
      <main className="flex-1 px-4 md:px-8 py-6 max-w-[1400px] mx-auto w-full">
        {children}
      </main>
      <footer className="border-t border-hom-border/30 py-4 text-center text-xs text-hom-muted">
        <span className="neon-text">HOM</span> — Hijaiyyah Operating Machine · v1.2.0 · © 2025 HMCL
      </footer>
    </div>
  );
}
