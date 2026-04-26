#!/bin/bash
# Build MWM-proposal.pdf from MWM-proposal.md via pandoc + tectonic.
# Style follows the IVNA paper convention: 12pt article, default LaTeX
# section styling, amsmath + hyperref + booktabs + enumitem + geometry.
# Runs from paper/ directory.

set -euo pipefail
cd "$(dirname "$0")"

# 1. Extract body (from "## 1. Thesis" onward) — skips the handwritten title
#    block AND the abstract, since we provide both in the LaTeX preamble.
awk 'BEGIN{keep=0} /^## 1\. Thesis/{keep=1} keep==1 {print}' MWM-proposal.md > _body.md

# 1b. Normalize Unicode that LaTeX's default fonts lack.
python3 <<'PY'
import re, pathlib
p = pathlib.Path('_body.md')
t = p.read_text()
for a,b in [('┌','+'),('┐','+'),('└','+'),('┘','+'),
            ('├','+'),('┤','+'),('┬','+'),('┴','+'),('┼','+'),
            ('─','-'),('│','|'),('═','='),('║','|'),
            ('←','<-'),('→','->'),('↑','^'),('↓','v'),('↔','<->')]:
    t = t.replace(a,b)
sup = {'⁰':'0','¹':'1','²':'2','³':'3','⁴':'4','⁵':'5','⁶':'6','⁷':'7','⁸':'8','⁹':'9'}
def fix_sup(m):
    base = m.group(1)
    exp = ''.join(sup[c] for c in m.group(2))
    return f'${base}^{{{exp}}}$'
t = re.sub(r'(\d+)([' + ''.join(sup.keys()) + r']+)', fix_sup, t)
pathlib.Path('_body.md').write_text(t)
PY

# 2. Convert body to a LaTeX fragment; promote ## → \section.
pandoc _body.md -o _body.tex --wrap=preserve --shift-heading-level-by=-1

# 3. Compose the full LaTeX document — IVNA style.
cat > MWM-proposal.tex <<'LATEX_PREAMBLE'
% Memory as World Model
% Wisdom Happy
% April 2026

\documentclass[12pt]{article}

\usepackage{amsmath, amssymb, amsthm}
\usepackage{hyperref}
\usepackage{booktabs}
\usepackage{enumitem}
\usepackage[margin=1in]{geometry}
\usepackage{fancyvrb}
\usepackage{xcolor}

\fvset{fontsize=\small,frame=single,framesep=3mm,rulecolor=\color{black!20}}
\hypersetup{colorlinks=true,linkcolor=black!70,urlcolor=blue!50!black,citecolor=blue!50!black}

\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}

% Allow looser line breaking so long compound words ("interpretability-by-design",
% "architectural-anti-hallucination") don't blow out the margin.
\sloppy
\setlength{\emergencystretch}{3em}

\title{Memory as World Model: \\
An Interpretable-by-Design Architecture \\
in Which the Graph Replaces Pretrained Weights \\
as the Locus of Belief}

\author{Wisdom Happy\thanks{Correspondence: wisdomhappy@playfulsincerity.org. \\[0.5em]
\textit{Methodology:} The core architectural framework presented in this paper---the thesis that memory structure is the world model, the Three Planes model (Matrix, Trees, Mirror), the reframing of cognition as an action system that thinks through memory, and the identification of the key mechanisms---was conceived and developed by the author, beginning with sustained thinking about agent memory architectures in late 2025 and crystallizing in March 2026. The formalization, literature positioning, and paper preparation were carried out using the Playful Sincerity Digital Core---an AI-assisted research methodology system built on Claude Code (Anthropic). The Digital Core orchestrates hierarchical planning, parallel agent-based research (six independent rounds of multi-stream subagents surveying 100+ primary sources across cognitive architectures, neuroscience, AI memory systems, and philosophy of mind), and continuous evolution tracking through semantic chronicles and design-doc versioning. Each of the architectural claims in this paper traces back to design documents, research synthesis files, or cross-stream convergence findings preserved in the project's public repository. This paper is a concept proposal; the implementation phase will produce a working prototype, a formal evaluation against the predictions in Section~\ref{predictions-and-measurements}, and a companion implementation paper. The full design archive is available at \url{https://github.com/Playful-Sincerity/Memory-as-World-Model}.} \\[0.3em]
Playful Sincerity Research}

\date{April 2026}

\begin{document}

\maketitle

\begin{center}
\textit{``Unfortunately, no one can be told what the Matrix is. \\
You have to see it for yourself.''}\\[0.3em]
--- Morpheus, \textit{The Matrix} (1999)
\end{center}
\vspace{1em}

\begin{abstract}
\noindent
Today's large language models bundle three things into a single weight space: language, knowledge, and reasoning. Interpretability in that substrate is therefore \emph{forensic}---we reverse-engineer features and circuits in a system that was never designed to be read. This paper describes a different architecture. The agent's beliefs live in an explicit graph of nodes and edges grown from its own experience. The LLM becomes a traversal and reading engine, optimized for navigating local neighborhoods and rendering language. A separate reasoning tool handles logic and math. Knowledge sits in the graph; language sits in the LLM; reasoning sits in a symbolic tool. Three components, each doing what it is good at. The question \emph{``why does this agent believe X?''} is answered by tracing a path in the graph, not by training a probe against the weights. Memory as World Model (MWM) is not a retrieval-augmentation layer on top of an LLM. It is a cognitive substrate in which memory IS the world model, and the world model is \emph{the} primary locus of interpretability, correction, and aligned action.

We frame the architectural inversion, lay out the Three Planes model (Matrix, Trees, Mirror) that grounds it, describe the mechanisms that make it work (navigation-not-retrieval, causal edges, reconsolidation, epistemic humility, earned conviction), propose the predictions and measurements that would validate or falsify the approach, position it against the prior art it builds on, and trace the implications for interpretability, alignment, and AI welfare.
\end{abstract}

\vspace{1em}

LATEX_PREAMBLE

# 4. Append body. Pandoc auto-generates \label{predictions-and-measurements}
#    on the Section 5 header; the methodology footnote refs that label directly,
#    so no post-build label injection is needed.
cat _body.tex >> MWM-proposal.tex

# 5. Close the document.
echo '' >> MWM-proposal.tex
echo '\end{document}' >> MWM-proposal.tex

# 6. Clean temp files.
rm -f _body.md _body.tex

# 7. Compile with tectonic.
tectonic MWM-proposal.tex

# 8. Report.
ls -la MWM-proposal.pdf
