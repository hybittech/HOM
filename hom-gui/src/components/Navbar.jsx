import { Link, useLocation } from 'react-router-dom';

const links = [
  { to: '/', label: 'Home' },
  { to: '/explorer', label: 'Explorer' },
  { to: '/lab', label: 'Lab' },
  { to: '/system', label: 'System' },
  { to: '/docs', label: 'Docs' },
];

export default function Navbar() {
  const { pathname } = useLocation();

  return (
    <nav className="glass sticky top-0 z-50 border-b border-hom-border/50">
      <div className="max-w-[1400px] mx-auto px-4 md:px-8 flex items-center justify-between h-16">
        <Link to="/" className="flex items-center ml-20">
          <img 
            src={import.meta.env.BASE_URL + 'Logo HOM 01.png'} 
            alt="HOM Logo" 
            className="h-10 w-10 object-contain hover:scale-110 transition-transform duration-300"
          />
        </Link>

        <div className="flex items-center gap-1">
          {links.map((link) => (
            <Link
              key={link.to}
              to={link.to}
              className={`px-4 py-2 rounded-lg text-[10px] transition-all duration-300 nav-tab-futuristic ${
                pathname === link.to
                  ? 'nav-tab-futuristic-active'
                  : 'text-hom-muted hover:text-hom-text hover:bg-hom-panel/50 hover:shadow-glow-sm'
              }`}
            >
              {link.label}
            </Link>
          ))}
        </div>
      </div>
    </nav>
  );
}
