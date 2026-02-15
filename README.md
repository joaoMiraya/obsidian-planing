# Obsidian Vault Generator - Study Plans with Zettelkasten Method

**Automated generation of methodologically sound Obsidian vaults for structured learning using AI.**

This project provides comprehensive instructions and configurations for AI models (like GitHub Copilot, ChatGPT, Claude) to generate complete Obsidian study vaults following the Zettelkasten method.

## 📋 What's Included

- **`.instructions`** (761 lines): Complete vault architecture, templates, validation rules, and AI generation guidelines
- **`.zettelkasten`** (237 lines): Atomic concept decomposition methodology with examples and quality criteria
- **`.obsidian/`** (11 files): Pre-configured Obsidian settings, graph view, plugins, hotkeys, and CSS styling
- **Templates**: Permanent notes, literature notes, and study plan templates with frontmatter

## 🎯 Features

✅ **Fully Configured Obsidian Vaults** - Ready-to-use `.obsidian/` directory with optimized settings  
✅ **Zettelkasten Compliance** - Atomic notes (200-300 words) with declarative titles  
✅ **Graph View Optimization** - Color-coded by note type and context  
✅ **Mermaid Diagrams** - Dependency graphs and learning paths  
✅ **Dataview Queries** - Dynamic progress tracking and note filtering  
✅ **Tag System** - Structured `#CONTEXT-REFERENCE` format for discoverability  
✅ **Templates** - YAML frontmatter for permanent, literature, and study plan notes  
✅ **Validation Checklists** - 21+ quality checks for generated content

## 🛠️ Automation Scripts

### Makefile Commands

The project includes a comprehensive Makefile with 14+ targets:

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
# Generate complete Docker vault (uses GitHub Copilot CLI)
make generate TOPIC="Kubernetes"

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

**generate-vault.sh** - Main vault generation script

```bash
# Basic usage
./scripts/generate-vault.sh --topic "Kubernetes"

# Advanced options
./scripts/generate-vault.sh \
  --topic "GraphQL APIs" \
  --context "GraphQL" \
  --output ./my-vaults

# Print prompt only (for manual ChatGPT/Claude use)
./scripts/generate-vault.sh --topic "GraphQL APIs" --prompt-only

# Validation
./scripts/generate-vault.sh --validate --output ./path/to/vault
```

**Options**:
- `-t, --topic` - Study topic (required)
- `-c, --context` - Context name (auto-generated if omitted)
- `-o, --output` - Output directory (default: `./generated-vaults`)
- `-p, --prompt-only` - Print prompt to terminal only (for manual AI use)
- `-v, --validate` - Run validation checks
- `-h, --help` - Show help

**optimize-prompt.sh** - Standalone prompt optimizer

```bash
# Analyze topic and generate enhanced prompt
./scripts/optimize-prompt.sh "Kubernetes"

# With custom context
./scripts/optimize-prompt.sh "Machine Learning" MachineLearning

# With custom requirements
./scripts/optimize-prompt.sh "Docker" Docker "Focus on security"
```

See [`scripts/README.md`](scripts/README.md) for detailed documentation.

## 💡 Manual Usage Examples

### With GitHub Copilot CLI

**⚠️ IMPORTANT**: GitHub Copilot does **NOT** automatically load instruction files.  
You **MUST explicitly reference** `.instructions` and `.zettelkasten` in your prompts.

#### Generate Complete Study Vault

```bash
gh copilot suggest "create a complete study vault about Machine Learning following .instructions and .zettelkasten, include all configuration files, templates, and atomic notes organized by learning phases"
```

#### Generate Atomic Concept Table

```bash
gh copilot suggest "using .zettelkasten methodology, decompose the topic 'GraphQL APIs' into atomic concepts with prerequisites and tags in table format"
```

#### Create Permanent Note

```bash
gh copilot suggest "following .instructions template, create a permanent note about 'Dependency Injection' with prerequisites, examples, and proper tags"
```

#### Generate Mermaid Dependency Diagram

```bash
gh copilot suggest "create a Mermaid flowchart showing the learning path dependencies for Web Security concepts following .instructions diagram standards"
```

#### Structure New Context

```bash
gh copilot suggest "following .instructions, structure a new context folder for 'Cloud-Native-Architecture' with permanent-notes, literature-notes, and fleeting-notes subdirectories, then update Master-Index and Context-Map"
```

### With ChatGPT/Claude/Other AI Models

1. **Start a new conversation**
2. **Upload both files**: `.instructions` and `.zettelkasten`
3. **Use structured prompts**:

```
I need you to generate a complete Obsidian vault for studying [TOPIC].

Please follow these files:
- .instructions: For vault structure, templates, and quality rules
- .zettelkasten: For atomic concept decomposition methodology

Generate:
1. Atomic concept decomposition table
2. All permanent notes (200-300 words each)
3. Study plan with Mermaid diagrams
4. Master Index and Context Map updates
5. Complete folder structure

Ensure all 21 validation checks from .instructions are satisfied.
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
│   └── [Context-Name]/           # e.g., MachineLearning
│       ├── permanent-notes/      # Atomic concepts (200-300 words)
│       ├── literature-notes/     # Source summaries
│       └── fleeting-notes/       # Quick captures
├── 20-STUDY-PLANS/
│   └── [Context-Name]-Study-Plan.md  # Learning paths
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

The `.obsidian/graph.json` configures automatic coloring:

- 🔴 **Red**: Index files (`00-INDEX/`)
- 🟢 **Green**: Permanent notes (`permanent-notes/`)
- 🔵 **Blue**: Literature notes (`literature-notes/`)
- 🟣 **Purple**: Fleeting notes (`fleeting-notes/`)
- 🟠 **Orange**: Study plans (`#StudyPlan` tag)

## 📏 Mandatory Conventions

### Tags
```
#CONTEXT-REFERENCE
Examples: #AWS-Lambda #Architecture-EventDriven #Python-AsyncIO
```

### Diagrams
Mermaid syntax only (flowchart, graph, mindmap, classDiagram)

### Folder Structure
```
vault-root/
├── 00-INDEX/
├── 10-CONTEXTS/
│   └── [Context-Name]/
│       ├── permanent-notes/
│       ├── literature-notes/
│       └── fleeting-notes/
├── 20-STUDY-PLANS/
├── 30-MAPS/
└── 40-RESOURCES/
```

### File Names
- Permanent Notes: `Declarative-Title.md`
- Study Plans: `[Context-Name]-Study-Plan.md`

## Zettelkasten Method

All permanent notes must:
- Be atomic (200-300 words)
- Have declarative titles
- Declare prerequisites
- Include 3+ tags
- Connect via bidirectional links

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

1. **Obsidian** - Download and install from [obsidian.md](https://obsidian.md)
2. **GitHub CLI** (optional) - [Installation guide](https://cli.github.com/)
3. **Bash** - Required for automation scripts (included on macOS/Linux)

### Step 1: Install Required Tools

#### Install Obsidian

**macOS:**
```bash
brew install --cask obsidian
```

**Linux (Debian/Ubuntu):**
```bash
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/obsidian_1.5.3_amd64.deb
sudo dpkg -i obsidian_1.5.3_amd64.deb
```

**Windows:**
Download installer from [obsidian.md/download](https://obsidian.md/download)

#### Install GitHub CLI (for Copilot)

**macOS:**
```bash
brew install gh
```

**Linux:**
```bash
# Debian/Ubuntu
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

**Windows:**
```bash
winget install --id GitHub.cli
```

#### Setup GitHub Copilot CLI (Optional)

```bash
# Authenticate GitHub CLI
gh auth login

# Copilot is built-in to modern GitHub CLI - verify it works:
gh copilot --help
```

### Step 2: Clone This Repository

```bash
git clone https://github.com/your-username/obsidian-planing.git
cd obsidian-planing
```

### Step 3: Generate Your First Study Vault

#### ⭐ Option A: Automated Script (Easiest)

```bash
# Using Makefile (recommended) — generates complete vault with all content
make generate TOPIC="Kubernetes"

# Or direct script
./scripts/generate-vault.sh --topic "Kubernetes"
```

This uses GitHub Copilot CLI to automatically generate:
- ✅ 15-30 atomic permanent notes (200-300 words each)
- ✅ Study plan with Mermaid dependency diagrams
- ✅ Master Index and Context Map
- ✅ Dependency graph with color coding
- ✅ Note templates

If Copilot CLI is not available, it falls back to saving a prompt file for manual use.

```bash
# For manual ChatGPT/Claude workflow (prints prompt to terminal)
make prompt-only TOPIC="Machine Learning"
```

#### Option B: Using GitHub Copilot CLI Directly

```bash
gh copilot suggest "create a complete study vault about Kubernetes following .instructions and .zettelkasten"
```

#### Option C: Manual with ChatGPT/Claude

1. Upload `.instructions` and `.zettelkasten` files to the AI chat
2. Use this prompt:

```
Using the .instructions and .zettelkasten files provided, generate a complete 
Obsidian vault for studying [YOUR TOPIC]. Include:
- Complete .obsidian/ configuration
- Atomic concept decomposition table
- All permanent notes with frontmatter
- Study plan with Mermaid diagrams
- Master Index and Context Map
```

### Step 4: Validate Generated Vault (Optional)

```bash
# Using Makefile
make validate VAULT_NAME=Kubernetes-vault

# Or direct script
./scripts/generate-vault.sh --validate --output ./generated-vaults/Kubernetes-vault
```

Runs 28 automated checks across 5 categories (configuration, structure, content, study plan, graph view).

### Step 5: Open Vault in Obsidian

1. Launch Obsidian
2. Click "Open folder as vault"
3. Select your generated vault directory (e.g., `./generated-vaults/Kubernetes-vault`)
4. Install recommended community plugins:
   - Dataview
   - Templater
   - Mind Map
   - Excalidraw
   - Breadcrumbs

### Step 6: Start Learning

1. Open `00-INDEX/Master-Index.md` to see all contexts
2. Navigate to `20-STUDY-PLANS/[Context-Name]-Study-Plan.md`
3. Follow the learning path in sequential order
4. Use Graph View (`Cmd/Ctrl + Shift + G`) to visualize connections

## ✅ Quality Validation

Before finalizing any generated vault, verify these checks (from `.instructions`):

### Configuration (5 checks)
- [ ] `.obsidian/` directory exists with all 11 files
- [ ] `app.json` has `alwaysUpdateLinks: true`
- [ ] `graph.json` contains color groups for note types
- [ ] `appearance.json` enables `zettelkasten-styling` CSS
- [ ] `templates.json` points to `40-RESOURCES/templates/`

### Structure (4 checks)
- [ ] All folders exist (`00-INDEX/`, `10-CONTEXTS/`, `20-STUDY-PLANS/`, `30-MAPS/`, `40-RESOURCES/`)
- [ ] `Master-Index.md` lists all contexts
- [ ] `Context-Map.md` has Mermaid dependency graph
- [ ] Templates exist in `40-RESOURCES/templates/`

### Content (7 checks)
- [ ] Permanent notes follow naming: `Declarative-Title.md`
- [ ] Permanent notes are 200-300 words (atomic)
- [ ] Permanent notes have declarative titles (e.g., `Concept-expresses-complete-idea`)
- [ ] Prerequisites declared with WikiLinks `[[note-title]]`
- [ ] Minimum 3 tags per note in `#CONTEXT-REFERENCE` format
- [ ] All diagrams use Mermaid syntax
- [ ] All internal links use WikiLinks format `[[note]]`

### Study Plan (5 checks)
- [ ] Study plan exists in `20-STUDY-PLANS/[Context]-Study-Plan.md`
- [ ] Includes Mermaid learning path diagram
- [ ] Organizes concepts into phases (Foundation → Core → Advanced)
- [ ] Links to all permanent notes
- [ ] Includes Dataview progress tracking query

### Graph View (7 checks)
- [ ] All notes visible in graph
- [ ] Permanent notes = green
- [ ] Literature notes = blue
- [ ] Fleeting notes = purple
- [ ] Study plans = orange
- [ ] Index files = red
- [ ] No orphaned notes (all connected)

**Total: 28 validation points**

## 🔧 Customization

### Modify Generation Rules

Edit these files to customize AI generation behavior:

- **`.instructions`** (761 lines)
  - Vault architecture and folder structure
  - Note templates with frontmatter
  - Validation rules and quality criteria
  - AI model usage instructions
  - Common pitfalls to avoid

- **`.zettelkasten`** (237 lines)
  - Atomic concept definition and examples
  - 5-step decomposition process
  - Tagging guidelines
  - Quality checklists (atomicity, connectivity, completeness)
  - Advanced guidelines for complex/interdisciplinary subjects

- **`.obsidian/graph.json`**
  - Color groups for custom contexts
  - Node/link size multipliers
  - Force simulation parameters

- **`.obsidian/snippets/zettelkasten-styling.css`**
  - Custom styling for note types
  - Tag appearance
  - Mermaid diagram themes

## 📚 Recommended Obsidian Plugins

These plugins are pre-configured in `.obsidian/community-plugins.json`:

| Plugin | Purpose | Priority |
|--------|---------|----------|
| **Dataview** | Query notes dynamically for progress tracking | ⭐⭐⭐ |
| **Templater** | Advanced template functionality | ⭐⭐⭐ |
| **Mind Map** | Visual concept mapping | ⭐⭐ |
| **Excalidraw** | Diagrams and sketches | ⭐⭐ |
| **Breadcrumbs** | Hierarchy visualization | ⭐⭐ |
| **Journey** | Zettelkasten path navigation | ⭐⭐ |
| **Kanban** | Study progress tracking | ⭐ |
| **Link View** | Backlinks visualization | ⭐ |

Install via: **Settings → Community Plugins → Browse**

## 🤝 Contributing

Improvements welcome! Areas for contribution:

- Additional language templates (currently English-focused)
- More study domain examples (beyond Docker, Web APIs)
- Alternative note-taking methodologies (PARA, Johnny Decimal)
- Integration with spaced repetition systems (Anki)
- CI/CD validation scripts for generated vaults

## 📄 License

MIT License - Feel free to use and modify for your study needs.

## 🔗 Resources

- **Obsidian**: https://obsidian.md
- **Zettelkasten Method**: https://zettelkasten.de
- **Mermaid Diagrams**: https://mermaid.js.org
- **GitHub Copilot CLI**: https://githubnext.com/projects/copilot-cli/
- **Dataview Plugin**: https://blacksmithgu.github.io/obsidian-dataview/

## 🙋 FAQ

**Q: Do I need GitHub Copilot to use this?**  
A: No! You can use any AI model (ChatGPT, Claude, etc.) by uploading the `.instructions` and `.zettelkasten` files.

**Q: Can I generate vaults for multiple subjects?**  
A: Yes! Each subject becomes a separate Context in `10-CONTEXTS/`. The Master Index tracks all contexts.

**Q: How do I add a new context to an existing vault?**  
A: Generate new permanent notes in `10-CONTEXTS/[NewContext]/`, update `Master-Index.md`, and add relationships to `Context-Map.md`.

**Q: What if my notes exceed 300 words?**  
A: Split into multiple atomic concepts. Each should express ONE complete idea.

**Q: Can I customize the folder structure?**  
A: Yes, but update both `.instructions` and `.obsidian/graph.json` color groups to match.

**Q: How do I handle math-heavy subjects?**  
A: Obsidian supports LaTeX math. Add `$$math$$` blocks in note templates.
