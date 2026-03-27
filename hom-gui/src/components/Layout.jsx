import Navbar from './Navbar';
import { useLocale } from '../store/useLocale';

export default function Layout({ children }) {
  const { t } = useLocale();
  return (
    <div className="min-h-screen bg-hom-bg flex flex-col">
      <Navbar />
      <main className="flex-1 px-4 md:px-8 py-6 max-w-[1400px] mx-auto w-full">
        {children}
      </main>
      <footer className="border-t border-hom-border/30 py-8 text-center space-y-2">
        <div className="text-xs text-hom-muted font-mono tracking-tight">
          <span className="neon-text font-bold">HOM</span> — {t('layout.footer')}
        </div>
        <div className="text-[10px] text-white/30 tracking-[0.4em] font-bold uppercase transition-colors hover:text-hom-accent/50 cursor-default">
          PT PURI PERTIWI INTERNATIONAL
        </div>
      </footer>
    </div>
  );
}
