import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import { useLocale } from '../store/useLocale';
import { originId } from '../content/origin-id';
import { originEn } from '../content/origin-en';
import 'katex/dist/katex.min.css';

/* ─── Custom Markdown Components ─── */
const mdComponents = {
  h1: ({ children }) => (
    <h1 className="text-3xl md:text-4xl font-black text-hom-accent mt-10 mb-4 pb-3 border-b border-hom-accent/20 first:mt-0" style={{ fontFamily: "'Orbitron', sans-serif", textShadow: '0 0 20px rgba(0,212,255,0.25)' }}>
      {children}
    </h1>
  ),
  h2: ({ children }) => (
    <h2 className="text-2xl md:text-3xl font-bold text-hom-text mt-10 mb-4 pb-2 border-b border-hom-border/20">
      {children}
    </h2>
  ),
  h3: ({ children }) => (
    <h3 className="text-xl font-bold text-hom-gold mt-8 mb-3">{children}</h3>
  ),
  h4: ({ children }) => (
    <h4 className="text-lg font-semibold text-hom-text/90 mt-6 mb-2">{children}</h4>
  ),
  h5: ({ children }) => (
    <div className="border border-hom-green/40 bg-hom-green/10 text-hom-green font-bold p-5 rounded-xl text-center my-8 text-lg md:text-xl shadow-[0_0_15px_rgba(0,255,128,0.15)] leading-relaxed">
      {children}
    </div>
  ),
  p: ({ children }) => (
    <p className="text-sm md:text-base text-hom-text/85 leading-relaxed mb-4">{children}</p>
  ),
  a: ({ href, children }) => (
    <a href={href} target="_blank" rel="noopener noreferrer" className="text-hom-accent hover:text-hom-accent/80 underline underline-offset-2">{children}</a>
  ),
  ul: ({ children }) => <ul className="space-y-1.5 mb-4 ml-4">{children}</ul>,
  ol: ({ children }) => <ol className="space-y-1.5 mb-4 ml-4 list-decimal">{children}</ol>,
  li: ({ children }) => (
    <li className="text-sm text-hom-text/80 leading-relaxed pl-1">
      <span className="text-hom-gold mr-1.5">▸</span>{children}
    </li>
  ),
  blockquote: ({ children }) => (
    <blockquote className="border-l-2 border-hom-gold/50 pl-4 py-2 my-4 bg-hom-gold/5 rounded-r-lg">{children}</blockquote>
  ),
  code: ({ className, children, ...props }) => {
    const isBlock = className?.includes('language-');
    if (isBlock) return <code className="block text-[11px] md:text-xs font-mono text-hom-text/90 whitespace-pre overflow-x-auto" {...props}>{children}</code>;
    return <code className="text-[11px] md:text-xs font-mono px-1.5 py-0.5 rounded bg-hom-accent/10 text-hom-accent border border-hom-accent/15" {...props}>{children}</code>;
  },
  pre: ({ children }) => (
    <pre className="bg-hom-bg/80 border border-hom-border/30 rounded-xl p-4 my-4 overflow-x-auto" style={{ boxShadow: '0 4px 20px rgba(0,0,0,0.3)' }}>{children}</pre>
  ),
  table: ({ children }) => (
    <div className="overflow-x-auto my-6 rounded-xl border border-hom-border/30" style={{ boxShadow: '0 4px 20px rgba(0,0,0,0.2)' }}>
      <table className="w-full text-sm border-collapse">{children}</table>
    </div>
  ),
  thead: ({ children }) => <thead className="bg-hom-panel/80 border-b border-hom-border/40">{children}</thead>,
  th: ({ children, style }) => <th className="py-3 px-4 text-[10px] font-bold uppercase tracking-wider text-hom-gold text-left" style={style}>{children}</th>,
  td: ({ children, style }) => <td className="py-2.5 px-4 text-xs text-hom-text/80 border-b border-hom-border/10" style={style}>{children}</td>,
  tr: ({ children }) => <tr className="hover:bg-hom-accent/[0.03] transition-colors">{children}</tr>,
  hr: () => <hr className="my-10 border-0 h-px bg-gradient-to-r from-transparent via-hom-gold/30 to-transparent" />,
  strong: ({ children }) => <strong className="font-bold text-hom-text">{children}</strong>,
  em: ({ children }) => <em className="italic text-hom-text/70">{children}</em>,
};

export default function Explorer() {
  const { lang } = useLocale();
  const content = lang === 'en' ? originEn : originId;

  return (
    <div className="max-w-5xl mx-auto">
      <div className="bg-hom-panel/30 backdrop-blur-xl border border-hom-border/20 rounded-2xl p-6 md:p-10">
        <div className="text-[11px] font-mono text-hom-gold/80 tracking-wide uppercase mb-8 text-center bg-hom-panel/50 py-2 rounded-lg border border-hom-gold/20">
          @2026 Sumber Buku Matematika Hijaiyyah-v.1.0
        </div>
        <ReactMarkdown 
          remarkPlugins={[remarkGfm, remarkMath]} 
          rehypePlugins={[rehypeKatex]}
          components={mdComponents}
        >
          {content}
        </ReactMarkdown>
      </div>
    </div>
  );
}
