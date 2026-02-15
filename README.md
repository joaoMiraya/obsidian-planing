# Obsidian Vault Generator — Study Plans with Zettelkasten Method

**Automated generation of methodologically sound Obsidian vaults for structured learning using AI.**

This project provides comprehensive instructions and configurations for AI models (GitHub Copilot, ChatGPT, Claude) to generate complete Obsidian study vaults following the Zettelkasten method with structured cognitive progression based on Bloom's Taxonomy.

## 📋 What's Included

- **`.instructions`** (612 lines): Vault architecture, templates, conventions, 28-point validation checklist, and 5-phase cognitive progression model
- **`.zettelkasten`** (267 lines): 7-step atomic decomposition methodology, Bloom's Taxonomy classification, first principles thinking, quality criteria
- **`.obsidian/`** (11 files): Pre-configured Obsidian settings, graph view, plugins, hotkeys, and CSS styling
- **Templates**: Permanent notes, literature notes, and study plan templates with frontmatter (including `bloom_level`)

## 🎯 Key Design Principles

| Principle | Implementation |
|:----------|:---------------|
| **First Principles Thinking** | Decomposition starts from domain axioms, not surface-level topics |
| **Bloom's Taxonomy** | Every concept classified by cognitive level; study plan organized in 5 ascending phases |
| **Concept Maps (Novak)** | Explicit inter-concept relationships forming a navigable semantic network |
| **Zettelkasten Atomicity** | Each note = 1 idea, 200–300 words, declarative Subject-Verb-Object title |
| **DAG Dependencies** | Prerequisite graph forms a directed acyclic graph — no circular dependencies |

## 🛠️ Automation Scripts

### Makefile Commands

```bash
make help              # Show all available commands
make generate          # Generate complete vault with AI (requires TOPIC="...")
make prompt-only       # Print optimized prompt to terminal only
make validate          # Validate existing vault
make list-vaults       # List all generated vaults
make stats             # Show statistics
make clean             # Remove all generated vaults
```

**Examples**:
```bash
# Generate complete Kubernetes vault (uses GitHub Copilot CLI)
make generate TOPIC="Kubernetes"

# Generate vault in Portuguese
make generate TOPIC="Kubernetes" LANGUAGE=pt

# Print prompt to terminal (for ChatGPT/Claude manual use)
make prompt-only TOPIC="Machine Learning"

# Validate generated vault
make validate VAULT_NAME=Kubernetes-vault

# Generate pre-configured examples
make example-ml
make example-graphql

# View statistics
make stats
```

### Shell Script Usage

**generate-vault.sh** — Main vault generation script

```bash
# Basic usage
./scripts/generate-vault.sh --topic "Kubernetes"

# Advanced options
./scripts/generate-vault.sh \
  --topic "GraphQL APIs" \
  --context "GraphQL" \
  --lang pt \
  --output ./my-vaults

# Print prompt only (for manual ChatGPT/Claude use)
./scripts/generate-vault.sh --topic "GraphQL APIs" --prompt-only

# Validation
./scripts/generate-vault.sh --validate --output ./path/to/vault
```

**Options**:
- `-t, --topic` — Study topic (required)
- `-c, --context` — Context name (auto-generated if omitted)
- `-o, --output` — Output directory (default: `./generated-vaults`)
- `-l, --lang` — Output language code (default: `en`) (e.g., `pt`, `es`, `fr`, `de`)
- `-p, --prompt-only` — Print prompt to terminal only (for manual AI use)
- `-v, --validate` — Run validation checks
- `-h, --help` — Show help

**optimize-prompt.sh** — Standalone prompt optimizer

```bash
# Analyze topic and generate enhanced prompt
./scripts/optimize-prompt.sh "Kubernetes"

# With custom context
./scripts/optimize-prompt.sh "Machine Learning" MachineLearning

# With custom requirements
./scripts/optimize-prompt.sh "Docker" Docker "Focus on security"
```

## 💡 Usage

### With GitHub Copilot CLI

**⚠️ IMPORTANT**: GitHub Copilot does **NOT** automatically load instruction files.
You **MUST explicitly reference** `.instructions` and `.zettelkasten` in your prompts.

```bash
# Generate complete study vault
gh copilot suggest "create a complete study vault about Machine Learning following .instructions and .zettelkasten, include all configuration files, templates, and atomic notes organized by learning phases"

# Generate atomic concept table
gh copilot suggest "using .zettelkasten methodology, decompose 'GraphQL APIs' into atomic concepts with prerequisites, Bloom levels, and tags in table format"
```

### With ChatGPT/Claude/Other AI Models

1. **Start a new conversation**
2. **Upload both files**: `.instructions` and `.zettelkasten`
3. **Use this prompt**:

```
Using the .instructions and .zettelkasten files provided, generate a complete
Obsidian vault for studying [YOUR TOPIC]. Include:
- Atomic concept decomposition table (with Bloom level per concept)
- All permanent notes (200-300 words each, with bloom_level in frontmatter)
- Study plan with 5 cognitive progression phases and Mermaid diagrams
- Master Index and Context Map updates
- Complete folder structure

Ensure all 28 validation checks from .instructions §7 are satisfied.
```

## 📐 Vault Architecture

### Folder Structure

```
vault-root/
├── .obsidian/                    # Obsidian configuration (11 files)
│   ├── app.json                  # Auto-update links, spell check
│   ├── graph.json                # Color-coded graph view
│   ├── community-plugins.json    # Recommended plugins
│   ├── templates.json            # Template folder config
│   └── snippets/
│       └── zettelkasten-styling.css
├── 00-INDEX/
│   ├── Master-Index.md           # All contexts registry
│   └── Context-Map.md            # Dependency graph
├── 10-CONTEXTS/
│   └── [ContextName]/            # e.g., MachineLearning
│       ├── permanent-notes/      # Atomic concepts (200-300 words)
│       ├── literature-notes/     # Source summaries
│       └── fleeting-notes/       # Quick captures
├── 20-STUDY-PLANS/
│   └── [ContextName]-Study-Plan.md  # 5-phase learning paths
├── 30-MAPS/
│   ├── concept-maps/             # Mermaid diagrams
│   └── dependency-graphs/        # Learning sequences
└── 40-RESOURCES/
    ├── templates/                # Note templates
    │   ├── permanent-note-template.md
    │   ├── literature-note-template.md
    │   └── study-plan-template.md
    ├── references/               # External resources
    └── attachments/              # Images, PDFs
```

### Graph View Color Scheme

- 🔴 **Red**: Index files (`00-INDEX/`)
- 🟢 **Green**: Permanent notes (`permanent-notes/`)
- 🔵 **Blue**: Literature notes (`literature-notes/`)
- 🟣 **Purple**: Fleeting notes (`fleeting-notes/`)
- 🟠 **Orange**: Study plans (`#StudyPlan` tag)

## 📏 Study Plan — 5-Phase Cognitive Progression

Study plans follow Bloom's Taxonomy, not flat topic lists:

| Phase | Bloom Level | Objective |
|:------|:------------|:----------|
| **1 — Foundations** | Remember, Understand | Axioms, definitions, primary principles |
| **2 — Structural Concepts** | Understand, Apply | Patterns, mechanisms, relationships |
| **3 — Application** | Apply, Analyze | Use cases, implementations, trade-offs |
| **4 — Analysis & Integration** | Analyze, Evaluate | Cross-domain synthesis, anti-patterns |
| **5 — Creation & Extension** | Evaluate, Create | Original projects, contributions |

Each permanent note includes a `bloom_level` field in frontmatter for tracking and Dataview queries.

## 📏 Mandatory Conventions

### Tags
```
#CONTEXT-REFERENCE
Examples: #AWS-Lambda #Architecture-EventDriven #Python-AsyncIO
```

### Diagrams
Mermaid syntax only (flowchart, graph, mindmap, classDiagram)

### File Names
- Permanent Notes: `Declarative-Title.md` (Subject-Verb-Object)
- Study Plans: `[ContextName]-Study-Plan.md`

### Zettelkasten Compliance
All permanent notes must:
- Be atomic (200–300 words, ONE idea)
- Have declarative titles (Subject-Verb-Object)
- Declare prerequisites via WikiLinks
- Include 3–7 tags in `#CONTEXT-REFERENCE` format
- Include `bloom_level` in frontmatter
- Connect via bidirectional links (no orphaned notes)

## 🚀 Quick Start

### Two Methods Available

**Method 1: Automated Scripts** (⭐ Recommended)
- Use `./scripts/generate-vault.sh` or `Makefile` targets
- Automatic prompt optimization
- Built-in validation (28 checks)
- One-command vault generation

**Method 2: Manual AI Interaction**
- Upload `.instructions` and `.zettelkasten` to ChatGPT/Claude
- Copy/paste generated content manually
- More control over each step

### Prerequisites

1. **Obsidian** — Download from [obsidian.md](https://obsidian.md)
2. **GitHub CLI** (optional) — [Installation guide](https://cli.github.com/)
3. **Bash** — Required for automation scripts (included on macOS/Linux)

### Step 1: Clone This Repository

```bash
git clone https://github.com/joaoMiraya/obsidian-planing.git
cd obsidian-planing
```

### Step 2: Generate Your First Study Vault

```bash
# Using Makefile (recommended)
make generate TOPIC="Kubernetes"

# Or direct script
./scripts/generate-vault.sh --topic "Kubernetes"
```

### Step 3: Validate (Optional)

```bash
make validate VAULT_NAME=Kubernetes-vault
```

### Step 4: Open in Obsidian

1. Launch Obsidian
2. Click "Open folder as vault"
3. Select your generated vault directory
4. Install recommended community plugins (Dataview, Templater, Mind Map, Excalidraw, Breadcrumbs)

## ✅ Quality Validation (28 points)

| Category | Checks | Key Items |
|:---------|:-------|:----------|
| **Configuration** | 5 | `.obsidian/` exists, `alwaysUpdateLinks`, graph colors, CSS snippet, templates path |
| **Structure** | 4 | All folders exist, Master-Index, Context-Map, templates |
| **Content** | 7 | Declarative titles, 200–300 words, prerequisites, 3+ tags, Mermaid, WikiLinks |
| **Study Plan** | 5 | Exists, Mermaid diagram, 5 phases, links to all notes, Dataview query |
| **Graph View** | 7 | All notes visible, correct colors, no orphans |

Full checklist in `.instructions` §7.

## 🔧 Customization

Edit these files to customize AI generation behavior:

- **`.instructions`** — Vault architecture, templates, conventions, validation rules, cognitive progression model
- **`.zettelkasten`** — Atomic decomposition process, Bloom classification, quality checklists
- **`.obsidian/graph.json`** — Color groups, node/link sizes, force simulation
- **`.obsidian/snippets/zettelkasten-styling.css`** — Custom styling for note types

## 📚 Recommended Obsidian Plugins

| Plugin | Purpose | Priority |
|:-------|:--------|:---------|
| **Dataview** | Query notes dynamically for progress tracking | ⭐⭐⭐ |
| **Templater** | Advanced template functionality | ⭐⭐⭐ |
| **Mind Map** | Visual concept mapping | ⭐⭐ |
| **Excalidraw** | Diagrams and sketches | ⭐⭐ |
| **Breadcrumbs** | Hierarchy visualization | ⭐⭐ |
| **Journey** | Zettelkasten path navigation | ⭐⭐ |
| **Kanban** | Study progress tracking | ⭐ |
| **Link View** | Backlinks visualization | ⭐ |

## 🤝 Contributing

Improvements welcome! Areas for contribution:

- Additional language templates
- More study domain examples
- Alternative note-taking methodologies (PARA, Johnny Decimal)
- Integration with spaced repetition systems (Anki)
- CI/CD validation scripts

## 📄 License

MIT License — Feel free to use and modify for your study needs.

## 🔗 Resources

- **Obsidian**: https://obsidian.md
- **Zettelkasten Method**: https://zettelkasten.de
- **Bloom's Taxonomy**: https://cft.vanderbilt.edu/guides-sub-pages/blooms-taxonomy/
- **Mermaid Diagrams**: https://mermaid.js.org
- **GitHub Copilot CLI**: https://githubnext.com/projects/copilot-cli/
- **Dataview Plugin**: https://blacksmithgu.github.io/obsidian-dataview/

## 🙋 FAQ

**Q: Do I need GitHub Copilot to use this?**
A: No! You can use any AI model (ChatGPT, Claude, etc.) by uploading the `.instructions` and `.zettelkasten` files.

**Q: Can I generate vaults for multiple subjects?**
A: Yes! Each subject becomes a separate Context in `10-CONTEXTS/`. The Master Index tracks all contexts.

**Q: What changed from the previous version?**
A: The study plan now uses 5 cognitive progression phases (Bloom's Taxonomy) instead of 3 flat phases. Decomposition follows first principles thinking. Each note includes a `bloom_level` field. The `.zettelkasten` methodology was expanded from 5 to 7 steps.

**Q: What if my notes exceed 300 words?**
A: Split into multiple atomic concepts. Each should express ONE complete idea.

**Q: Can I customize the folder structure?**
A: Yes, but update both `.instructions` and `.obsidian/graph.json` color groups to match.
