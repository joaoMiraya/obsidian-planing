#!/bin/bash

# Obsidian Vault Generator
# Automated script to generate study vaults using AI models

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-./generated-vaults}"
INSTRUCTIONS_FILE="${PROJECT_DIR}/.instructions"
ZETTELKASTEN_FILE="${PROJECT_DIR}/.zettelkasten"
OBSIDIAN_CONFIG="${PROJECT_DIR}/.obsidian"

# Banner
print_banner() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║         Obsidian Vault Generator (Zettelkasten)           ║"
    echo "║              AI-Powered Study Vault Creation               ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Help message
print_help() {
    echo -e "${BLUE}Usage:${NC}"
    echo "  $0 [OPTIONS]"
    echo ""
    echo -e "${BLUE}Options:${NC}"
    echo "  -t, --topic TOPIC        Study topic/subject (required)"
    echo "  -c, --context NAME       Context name (default: auto-generated from topic)"
    echo "  -o, --output DIR         Output directory (default: ./generated-vaults)"
    echo "  -l, --lang LANG          Output language (default: en) (e.g., pt, es, fr, de)"
    echo "  -p, --prompt-only        Generate optimized prompt only (skip vault structure)"
    echo "  -v, --validate           Validate existing vault"
    echo "  -h, --help               Show this help message"
    echo ""
    echo -e "${BLUE}Examples:${NC}"
    echo "  $0 --topic \"Kubernetes\""
    echo "  $0 --topic \"Machine Learning\" --context MachineLearning"
    echo "  $0 --topic \"GraphQL APIs\" --prompt-only"
    echo "  $0 --topic \"Kubernetes\" --lang pt"
    echo "  $0 --validate --output ./my-vault"
    echo ""
}

# Generate context name from topic
generate_context_name() {
    local topic="$1"
    # Convert to PascalCase: remove special chars, capitalize words, remove spaces
    echo "$topic" | sed -e 's/[^a-zA-Z0-9 ]//g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1' | sed 's/ //g'
}

# Optimize user prompt
optimize_prompt() {
    local topic="$1"
    local context_name="$2"
    local model="$3"
    local lang="$4"
    
    local lang_instruction=""
    if [ -n "$lang" ] && [ "$lang" != "en" ]; then
        lang_instruction="
> **OUTPUT LANGUAGE**: All generated content (titles, descriptions, explanations, examples, study plans) MUST be written in **${lang}**. Keep technical terms, file names, tag names, and Mermaid node IDs in English.
"
    fi
    
    cat <<EOF
# Obsidian Vault Generation Request
${lang_instruction}
## Context

Generate a complete, functional Obsidian vault for studying: **${topic}**

### Required Reference Files

1. **\`.instructions\`** — Vault architecture, templates, conventions, validation checklist (§1–§8)
2. **\`.zettelkasten\`** — Atomic decomposition methodology, Bloom's Taxonomy, quality criteria (§1–§7)

### Methodology

Follow the 7-step process from \`.zettelkasten\` (§2):
1. Identify first principles (domain axioms)
2. Map conceptual domains (3–6 clusters)
3. Extract atomic concepts (5–10 per domain)
4. Classify by Bloom level (remember → create)
5. Map dependencies as DAG (no cycles)
6. Create declarative titles (Subject-Verb-Object)
7. Assign tags \`#CONTEXT-REFERENCE\`

### Cognitive Progression (5 phases — see .instructions §4.2)

| Phase | Bloom | Focus |
|:------|:------|:------|
| 1 — Foundations | Remember, Understand | Axioms, definitions, primary principles |
| 2 — Structural Concepts | Understand, Apply | Patterns, mechanisms, relationships |
| 3 — Application | Apply, Analyze | Use cases, implementations, trade-offs |
| 4 — Analysis & Integration | Analyze, Evaluate | Cross-domain integration, anti-patterns |
| 5 — Creation & Extension | Evaluate, Create | Original projects, contributions |

### Required Deliverables

1. **Atomic decomposition table** with columns: Seq, Declarative Title, Description, Prerequisites, Bloom, Tags
2. **15–50 permanent notes** (200–300 words each) in \`10-CONTEXTS/${context_name}/permanent-notes/\`
3. **Study plan** at \`20-STUDY-PLANS/${context_name}-Study-Plan.md\` with Mermaid diagram and 5 phases
4. **Master Index** and **Context Map** updated in \`00-INDEX/\`
5. **Dependency graph** (Mermaid) in \`30-MAPS/concept-maps/\`

### Conventions (see .instructions §2)

- Titles: \`Subject-Verb-Object\` with hyphens (e.g., \`Docker-uses-namespaces-for-process-isolation\`)
- Tags: \`#CONTEXT-REFERENCE\` in PascalCase, 3–7 per note
- Links: WikiLinks \`[[note]]\` exclusively
- Diagrams: Mermaid exclusively
- Frontmatter: include \`bloom_level\` in each permanent note

### Validation (see .instructions §7)

Verify ALL 28 points before finalizing:
- §7.1 Configuration (5) · §7.2 Structure (4) · §7.3 Content (7) · §7.4 Study Plan (5) · §7.5 Graph View (7)

---

**TOPIC**: ${topic}
**CONTEXT NAME**: ${context_name}

BEGIN GENERATION.
EOF
}

# Build the generation prompt for the AI model
build_generation_prompt() {
    local topic="$1"
    local context_name="$2"
    local vault_dir="$3"
    local lang="$4"
    local current_date=$(date +"%Y-%m-%d")

    local lang_instruction=""
    if [ -n "$lang" ] && [ "$lang" != "en" ]; then
        lang_instruction="
IMPORTANT — OUTPUT LANGUAGE: All generated content (titles, descriptions, explanations, examples, study plans) MUST be written in **${lang}**. Keep technical terms, file names, tag names, and Mermaid node IDs in English.
"
    fi

    cat <<PROMPT_EOF
You MUST generate a complete Obsidian study vault about "${topic}".
${lang_instruction}
IMPORTANT: Read the files ".instructions" and ".zettelkasten" in this repository FIRST.
They contain the full methodology, templates, naming conventions, and validation rules you must follow.

Context name: ${context_name}
Current date: ${current_date}

The vault directory already exists at: ${vault_dir}
The folder structure and .obsidian/ config are already created. You MUST create the content files.

## YOUR TASK — Create ALL of the following files:

### 1. Atomic Concept Decomposition
Using .zettelkasten methodology, decompose "${topic}" into 15-30 atomic concepts.
Each concept must be atomic (ONE idea), have a declarative title (Subject-Verb-Object), and 200-300 words.

### 2. Permanent Notes (15-30 files)
Create each file at: ${vault_dir}/10-CONTEXTS/${context_name}/permanent-notes/
File name format: Declarative-Title.md (NO timestamp prefix, just the title with hyphens)

Examples of good file names:
- Processes-Isolate-Program-Execution-In-Operating-Systems.md
- Namespaces-Provide-Process-Isolation-In-Linux.md
- Docker-Combines-Namespaces-And-Cgroups-For-Containerization.md

Each file MUST have this exact structure:
---
created: ${current_date}
modified: ${current_date}
type: permanent
context: ${context_name}
sequence: N
tags: [tag1, tag2, tag3]
---

# Declarative-Title

**Prerequisites**: [[Prerequisite-Title]] [[Another-Prerequisite]]

**Status**: 🟡 In Progress

---

## Concept

[200-300 word explanation of ONE atomic concept]

## Example

[Concrete, practical example]

## Application

[Real-world usage scenario]

## Related Concepts

- [[Related-Title-1]]
- [[Related-Title-2]]
- [[Related-Title-3]]

---

**Tags**: #${context_name}-Tag1 #Category-Tag2 #Domain-Tag3
**Source**: [if applicable]

### 3. Study Plan
Create file: ${vault_dir}/20-STUDY-PLANS/${context_name}-Study-Plan.md

Must include:
- YAML frontmatter with type: study-plan, context, tags: [StudyPlan]
- Overview (domain, goal, prerequisites)
- Mermaid flowchart showing learning path dependencies (use note titles as node labels)
- 3 phases: Foundation → Core → Advanced
- Checklist with WikiLinks to ALL permanent notes created (e.g., [[Declarative-Title]])
- Dataview query for progress tracking

### 4. Master Index
Create file: ${vault_dir}/00-INDEX/Master-Index.md

Include:
- Context entry for ${context_name} with study plan link, note count, status
- Dataview query listing all notes

### 5. Context Map
Create file: ${vault_dir}/00-INDEX/Context-Map.md

Include Mermaid diagram showing relationships between concept domains.

### 6. Dependency Graph
Create file: ${vault_dir}/30-MAPS/concept-maps/${context_name}-Dependency-Graph.md

Include Mermaid flowchart showing all concept dependencies with color coding:
- Foundation: fill:#e1f5ff
- Core: fill:#fff4e1
- Advanced: fill:#ffe1e1

### 7. Templates
Copy these 3 template files to ${vault_dir}/40-RESOURCES/templates/:
- permanent-note-template.md
- literature-note-template.md
- study-plan-template.md
(Use the templates defined in .instructions)

## RULES
- ALL links must use WikiLinks format: [[Note-Title]] (no timestamps in links)
- ALL diagrams must use Mermaid syntax
- ALL tags must follow #CONTEXT-REFERENCE format (PascalCase)
- ALL permanent notes must be 200-300 words (atomic)
- ALL titles must be declarative: Subject-Verb-Object
- ALL file names must use hyphens, no spaces, no timestamps
- NO orphaned notes — every note must link to at least one other
- Prerequisites must form a DAG (no circular dependencies)
- The sequence field in frontmatter defines learning order (1, 2, 3...)

CREATE ALL FILES NOW. Do not ask questions, do not explain — just create the files.
PROMPT_EOF
}

# Generate vault with AI
generate_vault() {
    local topic="$1"
    local context_name="$2"
    local output_dir="$3"
    local prompt_only="$4"
    local lang="$5"
    
    local vault_dir="${output_dir}/${context_name}-vault"
    
    if [ "$prompt_only" = true ]; then
        # Print prompt to stdout only (for manual copy/paste into ChatGPT/Claude)
        echo -e "${BLUE}📝 Generating optimized prompt...${NC}"
        local optimized_prompt=$(optimize_prompt "$topic" "$context_name" "" "$lang")
        echo -e "${GREEN}✅ Optimized prompt generated!${NC}"
        echo ""
        echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
        echo "$optimized_prompt"
        echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo -e "${YELLOW}Copy the prompt above and paste it into your AI model (ChatGPT, Claude, etc.).${NC}"
        echo -e "${YELLOW}Upload these files alongside the prompt:${NC}"
        echo "   - ${INSTRUCTIONS_FILE}"
        echo "   - ${ZETTELKASTEN_FILE}"
        return 0
    fi
    
    # Full generate: create vault structure + use Copilot to generate content
    setup_vault_structure "$vault_dir" "$context_name"
    echo ""
    
    # Check if gh copilot is available
    if ! command -v gh &> /dev/null || ! gh copilot -- --version &> /dev/null; then
        echo -e "${YELLOW}⚠️  GitHub Copilot CLI not available. Falling back to prompt-only mode.${NC}"
        echo ""
        local optimized_prompt=$(optimize_prompt "$topic" "$context_name" "" "$lang")
        local prompt_file="${vault_dir}/PROMPT.md"
        echo "$optimized_prompt" > "$prompt_file"
        echo -e "${GREEN}✓${NC} Saved optimized prompt to ${prompt_file}"
        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${YELLOW}Next steps (manual mode):${NC}"
        echo ""
        echo "  1. Open ChatGPT, Claude, or another AI model"
        echo "  2. Upload: ${INSTRUCTIONS_FILE} and ${ZETTELKASTEN_FILE}"
        echo "  3. Paste the prompt from: ${prompt_file}"
        echo "  4. Save generated files to: ${vault_dir}/10-CONTEXTS/${context_name}/permanent-notes/"
        echo "  5. Validate: $0 --validate --output ${vault_dir}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
        return 0
    fi
    
    # Build generation prompt
    echo -e "${BLUE}🤖 Generating vault content with GitHub Copilot CLI...${NC}"
    echo -e "${YELLOW}   This may take a few minutes depending on the topic complexity.${NC}"
    echo ""
    
    local generation_prompt=$(build_generation_prompt "$topic" "$context_name" "$vault_dir" "$lang")
    
    # Save prompt for reference
    echo "$generation_prompt" > "${vault_dir}/PROMPT.md"
    
    # Execute with gh copilot
    local abs_vault_dir=$(cd "$vault_dir" && pwd)
    local abs_project_dir="${PROJECT_DIR}"
    
    gh copilot -p "$generation_prompt" \
        --allow-all \
        --add-dir "$abs_vault_dir" \
        --add-dir "$abs_project_dir" \
        --silent \
        2>&1 | while IFS= read -r line; do
            echo -e "  ${CYAN}│${NC} $line"
        done
    
    local exit_code=${PIPESTATUS[0]}
    echo ""
    
    if [ $exit_code -eq 0 ]; then
        # Count generated files
        local note_count=$(find "${vault_dir}/10-CONTEXTS" -name "*.md" -path "*/permanent-notes/*" 2>/dev/null | wc -l)
        local plan_count=$(find "${vault_dir}/20-STUDY-PLANS" -name "*.md" 2>/dev/null | wc -l)
        local index_exists="No"
        [ -f "${vault_dir}/00-INDEX/Master-Index.md" ] && index_exists="Yes"
        
        echo -e "${GREEN}✅ Vault generation complete!${NC}"
        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}Summary:${NC}"
        echo "  Permanent notes: ${note_count}"
        echo "  Study plans:     ${plan_count}"
        echo "  Master Index:    ${index_exists}"
        echo "  Vault path:      ${vault_dir}"
        echo ""
        echo -e "${YELLOW}Next steps:${NC}"
        echo "  1. Validate:  $0 --validate --output ${vault_dir}"
        echo "  2. Open in Obsidian: File → Open folder as vault → ${vault_dir}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    else
        echo -e "${RED}❌ Copilot generation encountered an error (exit code: ${exit_code}).${NC}"
        echo -e "${YELLOW}Falling back: prompt saved to ${vault_dir}/PROMPT.md${NC}"
        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${YELLOW}Manual fallback:${NC}"
        echo "  1. Open ChatGPT, Claude, or another AI model"
        echo "  2. Upload: ${INSTRUCTIONS_FILE} and ${ZETTELKASTEN_FILE}"
        echo "  3. Paste the prompt from: ${vault_dir}/PROMPT.md"
        echo "  4. Save generated files to: ${vault_dir}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    fi
}

# Validate generated vault
validate_vault() {
    local vault_dir="$1"
    
    echo -e "${BLUE}🔍 Validating vault: ${vault_dir}${NC}"
    echo ""
    
    local errors=0
    local warnings=0
    
    # Configuration checks
    echo -e "${CYAN}Configuration Checks (5):${NC}"
    
    if [ -d "${vault_dir}/.obsidian" ]; then
        echo -e "  ${GREEN}✓${NC} .obsidian/ directory exists"
    else
        echo -e "  ${RED}✗${NC} .obsidian/ directory missing"
        ((errors++))
    fi
    
    if [ -f "${vault_dir}/.obsidian/app.json" ]; then
        if grep -q '"alwaysUpdateLinks": true' "${vault_dir}/.obsidian/app.json"; then
            echo -e "  ${GREEN}✓${NC} app.json has alwaysUpdateLinks enabled"
        else
            echo -e "  ${YELLOW}⚠${NC} app.json missing alwaysUpdateLinks setting"
            ((warnings++))
        fi
    else
        echo -e "  ${RED}✗${NC} app.json missing"
        ((errors++))
    fi
    
    if [ -f "${vault_dir}/.obsidian/graph.json" ]; then
        echo -e "  ${GREEN}✓${NC} graph.json exists"
    else
        echo -e "  ${YELLOW}⚠${NC} graph.json missing"
        ((warnings++))
    fi
    
    if [ -f "${vault_dir}/.obsidian/templates.json" ]; then
        echo -e "  ${GREEN}✓${NC} templates.json exists"
    else
        echo -e "  ${YELLOW}⚠${NC} templates.json missing"
        ((warnings++))
    fi
    
    if [ -f "${vault_dir}/.obsidian/snippets/zettelkasten-styling.css" ]; then
        echo -e "  ${GREEN}✓${NC} zettelkasten-styling.css exists"
    else
        echo -e "  ${YELLOW}⚠${NC} CSS snippet missing"
        ((warnings++))
    fi
    
    echo ""
    
    # Structure checks
    echo -e "${CYAN}Structure Checks (4):${NC}"
    
    for dir in "00-INDEX" "10-CONTEXTS" "20-STUDY-PLANS" "30-MAPS" "40-RESOURCES"; do
        if [ -d "${vault_dir}/${dir}" ]; then
            echo -e "  ${GREEN}✓${NC} ${dir}/ exists"
        else
            echo -e "  ${RED}✗${NC} ${dir}/ missing"
            ((errors++))
        fi
    done
    
    echo ""
    
    # Content checks
    echo -e "${CYAN}Content Checks:${NC}"
    
    local permanent_notes=$(find "${vault_dir}/10-CONTEXTS" -type f -name "*.md" 2>/dev/null | grep "permanent-notes" | wc -l)
    echo -e "  ${GREEN}ℹ${NC} Permanent notes found: ${permanent_notes}"
    
    if [ $permanent_notes -eq 0 ]; then
        echo -e "  ${YELLOW}⚠${NC} No permanent notes found"
        ((warnings++))
    fi
    
    local study_plans=$(find "${vault_dir}/20-STUDY-PLANS" -type f -name "*.md" 2>/dev/null | wc -l)
    echo -e "  ${GREEN}ℹ${NC} Study plans found: ${study_plans}"
    
    echo ""
    
    # Summary
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
        echo -e "${GREEN}✅ Validation passed! No errors or warnings.${NC}"
        return 0
    elif [ $errors -eq 0 ]; then
        echo -e "${YELLOW}⚠️  Validation passed with ${warnings} warning(s).${NC}"
        return 0
    else
        echo -e "${RED}❌ Validation failed with ${errors} error(s) and ${warnings} warning(s).${NC}"
        return 1
    fi
}

# Setup vault structure
setup_vault_structure() {
    local vault_dir="$1"
    local context_name="$2"
    
    echo -e "${BLUE}📁 Setting up vault structure...${NC}"
    
    # Create directories
    mkdir -p "${vault_dir}/00-INDEX"
    mkdir -p "${vault_dir}/10-CONTEXTS/${context_name}/permanent-notes"
    mkdir -p "${vault_dir}/10-CONTEXTS/${context_name}/literature-notes"
    mkdir -p "${vault_dir}/10-CONTEXTS/${context_name}/fleeting-notes"
    mkdir -p "${vault_dir}/20-STUDY-PLANS"
    mkdir -p "${vault_dir}/30-MAPS/concept-maps"
    mkdir -p "${vault_dir}/30-MAPS/dependency-graphs"
    mkdir -p "${vault_dir}/40-RESOURCES/templates"
    mkdir -p "${vault_dir}/40-RESOURCES/references"
    mkdir -p "${vault_dir}/40-RESOURCES/attachments"
    
    # Copy .obsidian configuration
    if [ -d "${OBSIDIAN_CONFIG}" ]; then
        cp -r "${OBSIDIAN_CONFIG}" "${vault_dir}/"
        echo -e "${GREEN}✓${NC} Copied .obsidian/ configuration"
    else
        echo -e "${YELLOW}⚠${NC} .obsidian/ directory not found in repository"
    fi
    
    echo -e "${GREEN}✅ Vault structure created!${NC}"
}

# Main function
main() {
    local topic=""
    local context_name=""
    local output_dir="${OUTPUT_DIR}"
    local prompt_only=false
    local validate_mode=false
    local lang="en"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--topic)
                topic="$2"
                shift 2
                ;;
            -c|--context)
                context_name="$2"
                shift 2
                ;;
            -o|--output)
                output_dir="$2"
                shift 2
                ;;
            -p|--prompt-only)
                prompt_only=true
                shift
                ;;
            -l|--lang)
                lang="$2"
                shift 2
                ;;
            -v|--validate)
                validate_mode=true
                shift
                ;;
            -h|--help)
                print_banner
                print_help
                exit 0
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                print_help
                exit 1
                ;;
        esac
    done
    
    print_banner
    
    # Validation mode
    if [ "$validate_mode" = true ]; then
        if [ -z "$output_dir" ]; then
            echo -e "${RED}Error: --output DIR required for validation${NC}"
            exit 1
        fi
        validate_vault "$output_dir"
        exit $?
    fi
    
    # Check required arguments
    if [ -z "$topic" ]; then
        echo -e "${RED}Error: --topic is required${NC}"
        echo ""
        print_help
        exit 1
    fi
    
    # Generate context name if not provided
    if [ -z "$context_name" ]; then
        context_name=$(generate_context_name "$topic")
        echo -e "${CYAN}Generated context name: ${context_name}${NC}"
    fi
    
    # Display configuration
    echo -e "${CYAN}Configuration:${NC}"
    echo "  Topic: ${topic}"
    echo "  Context: ${context_name}"
    echo "  Output: ${output_dir}/${context_name}-vault"
    echo "  Language: ${lang}"
    echo "  Prompt only: ${prompt_only}"
    echo ""
    
    # Generate vault
    generate_vault "$topic" "$context_name" "$output_dir" "$prompt_only" "$lang"
    
    echo ""
    echo -e "${GREEN}✅ Done!${NC}"
}

# Execute main function
main "$@"
