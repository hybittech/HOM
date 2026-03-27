import { Link, useLocation } from 'react-router-dom';
import { useLocale } from '../store/useLocale';

export default function Navbar() {
  const { pathname } = useLocation();
  const { lang, setLang, t } = useLocale();

  const links = [
    { to: '/', label: t('nav.home') },
    { to: '/explorer', label: 'Origin' },
    { to: '/lab', label: t('nav.lab') },
    { to: '/system', label: 'Hybit' },
    { to: '/docs', label: t('nav.docs') },
  ];

  return (
    <nav className="glass sticky top-0 z-50 border-b border-hom-border/50">
      <div className="max-w-[1400px] mx-auto px-4 md:px-8 flex items-center h-16 relative">
        <div className="flex-1 flex justify-start">
          <Link to="/" className="flex items-center md:ml-20">
            <img 
              src={import.meta.env.BASE_URL + 'Hybit Logo Master 001.png'} 
              alt="Hybit Logo" 
              className="h-9 w-auto object-contain hover:scale-110 transition-transform duration-300"
            />
          </Link>
        </div>


        <div className="flex-1 flex justify-end items-center gap-4">
          <div className="flex items-center gap-1 overflow-x-auto hide-scrollbar max-w-[50vw] md:max-w-none md:overflow-visible pb-1 md:pb-0">
            {links.map((link) => (
              <Link
                key={link.to}
                to={link.to}
                className={`px-3 py-2 rounded-lg text-[10px] whitespace-nowrap transition-all duration-300 nav-tab-futuristic ${
                  pathname === link.to
                    ? 'nav-tab-futuristic-active'
                    : 'text-hom-muted hover:text-hom-text hover:bg-hom-panel/50 hover:shadow-glow-sm'
                }`}
              >
                {link.label}
              </Link>
            ))}
          </div>
          
          {/* Language Toggle */}
          <div className="flex items-center rounded-lg bg-hom-panel/50 border border-hom-border/50 p-0.5 text-[9px] font-mono">
            <button
              onClick={() => setLang('en')}
              className={`px-2 py-1 rounded-md transition-all ${
                lang === 'en' ? 'bg-hom-accent/20 text-hom-accent' : 'text-hom-muted hover:text-hom-text'
              }`}
            >
              EN
            </button>
            <button
              onClick={() => setLang('id')}
              className={`px-2 py-1 rounded-md transition-all ${
                lang === 'id' ? 'bg-hom-accent/20 text-hom-accent' : 'text-hom-muted hover:text-hom-text'
              }`}
            >
              ID
            </button>
          </div>
        </div>
      </div>
    </nav>
  );
}
