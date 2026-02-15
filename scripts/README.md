# Scripts Directory

This directory contains automation scripts for the Obsidian Vault Generator project.

## Available Scripts

### 1. `generate-vault.sh`

Main script for generating Obsidian study vaults with AI assistance.

**Features**:
- ✅ Complete vault generation via GitHub Copilot CLI
- ✅ Optimized prompt generation
- ✅ Automatic vault structure setup
- ✅ Built-in validation (28 checks)
- ✅ Context name auto-generation
- ✅ Color-coded output
- ✅ Fallback to prompt-only mode when Copilot is unavailable

**Usage**:
```bash
# Generate complete vault with all content (uses Copilot CLI)
./scripts/generate-vault.sh --topic "Kubernetes"

# With custom context name
./scripts/generate-vault.sh --topic "Machine Learning" --context MachineLearning

# Print prompt only (for manual ChatGPT/Claude use)
./scripts/generate-vault.sh --topic "GraphQL APIs" --prompt-only

# Validate existing vault
./scripts/generate-vault.sh --validate --output ./generated-vaults/my-vault
```

**Options**:
```
  -t, --topic TOPIC        Study topic/subject (required)
  -c, --context NAME       Context name (default: auto-generated)
  -o, --output DIR         Output directory (default: ./generated-vaults)
  -p, --prompt-only        Print optimized prompt to terminal only
  -v, --validate           Validate existing vault
  -h, --help               Show help message
```

---

### 2. `optimize-prompt.sh`

Standalone prompt optimization utility that analyzes topics and generates enhanced prompts.

**Features**:
- 🎯 Topic domain detection
- 🔗 Related context suggestions  
- 📊 Concept count estimation
- 📝 Enhanced prompt generation with best practices

**Usage**:
```bash
# Basic usage
./scripts/optimize-prompt.sh "Kubernetes"

# With custom context name
./scripts/optimize-prompt.sh "Machine Learning" MachineLearning

# With custom requirements
./scripts/optimize-prompt.sh "Docker" Docker "Focus on security aspects"
```

**Output**: Complete optimized prompt ready to paste into any AI model.

---

## Script Architecture

### `generate-vault.sh` Flow

```
User Input (topic)
    ↓
[Analyze & Validate]
    ↓
[Generate Context Name] (if not provided)
    ↓
┌─────────────────────────────────────┐
│  --prompt-only                      │
│  → Display optimized prompt         │
│    in terminal (for copy/paste)     │
└─────────────────────────────────────┘
          OR
┌─────────────────────────────────────┐
│  Default (no --prompt-only)         │
│  → Setup vault folder structure     │
│  → Copy .obsidian/ configuration    │
│  → Call gh copilot -p to generate   │
│    all content files automatically  │
│  → (Fallback: save prompt to file)  │
└─────────────────────────────────────┘
    ↓
[Validation] (28 checks)
    ↓
✅ Complete Vault
```

### Prompt Optimization Strategy

The `optimize-prompt.sh` script enhances user input through:

1. **Topic Analysis**
   - Domain detection (DevOps, ML, Backend, etc.)
   - Complexity estimation
   - Related context identification

2. **Prompt Enhancement**
   - Explicit file references (`.instructions`, `.zettelkasten`)
   - Structured deliverables section
   - 5-phase generation strategy
   - Complete validation checklist (28 points)
   - Common mistakes to avoid

3. **Context Injection**
   - Domain-specific examples
   - Prerequisite suggestions
   - Tag format recommendations
   - Estimated concept count

---

## Validation Checks

The `generate-vault.sh` script includes 28 automated checks:

### Configuration (5 checks)
- `.obsidian/` directory exists
- `app.json` has `alwaysUpdateLinks: true`
- `graph.json` contains color groups
- `appearance.json` enables CSS snippet
- `templates.json` points to correct location

### Structure (4 checks)
- All required folders exist
- `Master-Index.md` present
- `Context-Map.md` present
- Templates exist in `40-RESOURCES/templates/`

### Content (7 checks)
- Permanent notes follow naming convention
- Notes are 200-300 words
- Titles are declarative
- Prerequisites declared
- Minimum 3 tags per note
- All diagrams use Mermaid
- All links use WikiLinks format

### Study Plan (5 checks)
- Study plan exists in correct location
- Includes Mermaid dependency diagram
- Organized into 3 phases
- Links to all permanent notes
- Includes Dataview progress query

### Graph View (7 checks)
- All notes visible in graph
- Color coding correct
- No orphaned notes
- Prerequisites form valid DAG
- Tags enable cross-referencing
- Context in Master Index
- Related concepts linked

---

## Integration with Makefile

These scripts are wrapped by convenient Makefile targets:

```bash
# Generate vault
make generate TOPIC="Kubernetes"

# Generate prompt only
make prompt-only TOPIC="Machine Learning"

# Validate vault
make validate VAULT_NAME=my-vault

# List all vaults
make list-vaults

# Show statistics
make stats
```

See `../Makefile` for all available targets.

---

## Environment Variables

Both scripts respect these environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `OUTPUT_DIR` | `./generated-vaults` | Where to create vaults |
| `INSTRUCTIONS_FILE` | `./.instructions` | Path to instructions file |
| `ZETTELKASTEN_FILE` | `./.zettelkasten` | Path to methodology file |
| `OBSIDIAN_CONFIG` | `./.obsidian` | Path to Obsidian config dir |

---

## Examples

### Example 1: Generate Complete Vault with Copilot

```bash
./scripts/generate-vault.sh --topic "Kubernetes"
```

Output:
```
╔════════════════════════════════════════════════════════════╗
║         Obsidian Vault Generator (Zettelkasten)           ║
╚════════════════════════════════════════════════════════════╝

Generated context name: Kubernetes
🤖 Generating vault content with GitHub Copilot CLI...

✅ Vault generation complete!

Summary:
  Permanent notes: 20
  Study plans:     1
  Master Index:    Yes
  Vault path:      ./generated-vaults/Kubernetes-vault
```

### Example 2: Print Prompt to Terminal

```bash
./scripts/generate-vault.sh --topic "GraphQL APIs" --prompt-only
```

Output: Complete optimized prompt ready to paste into ChatGPT/Claude.

### Example 3: Validate Generated Vault

```bash
./scripts/generate-vault.sh --validate --output ./generated-vaults/Kubernetes-vault
```

Output:
```
🔍 Validating vault: ./generated-vaults/Kubernetes-vault

Configuration Checks (5):
  ✓ .obsidian/ directory exists
  ✓ app.json has alwaysUpdateLinks enabled
  ✓ graph.json exists
  ✓ templates.json exists
  ✓ zettelkasten-styling.css exists

Structure Checks (4):
  ✓ 00-INDEX/ exists
  ✓ 10-CONTEXTS/ exists
  ✓ 20-STUDY-PLANS/ exists
  ✓ 30-MAPS/ exists
  ✓ 40-RESOURCES/ exists

[... more checks ...]

✅ Validation passed! No errors or warnings.
```

---

## Troubleshooting

### Permission Denied

```bash
chmod +x scripts/*.sh
```

### Vault Validation Fails

Check that your AI model:
1. Followed `.instructions` file completely
2. Used `.zettelkasten` methodology for decomposition
3. Copied `.obsidian/` configuration directory
4. Created all required folders

Run validation to see specific failures:
```bash
./scripts/generate-vault.sh --validate --output path/to/vault
```

---

## Contributing

To add new features to scripts:

1. **Additional validation checks**: Edit `validate_vault()` function in `generate-vault.sh`
2. **Enhanced prompt features**: Edit `generate_enhanced_prompt()` in `optimize-prompt.sh`
3. **New domain detection**: Edit `analyze_topic()` in `optimize-prompt.sh`

---

## License

MIT License - See `../LICENSE` for details.
