#!/bin/bash

# Prompt Optimizer for Obsidian Vault Generation
# Enhances user input to maximize AI model output quality

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTRUCTIONS_FILE="${SCRIPT_DIR}/../.instructions"
ZETTELKASTEN_FILE="${SCRIPT_DIR}/../.zettelkasten"

# Extract key information from user topic
analyze_topic() {
    local topic="$1"
    
    # Detect domain/category
    local domain=""
    if [[ "$topic" =~ [Kk]ubernetes|[Dd]ocker|[Cc]ontainer ]]; then
        domain="DevOps/Cloud"
    elif [[ "$topic" =~ [Mm]achine.*[Ll]earning|AI|[Dd]eep.*[Ll]earning ]]; then
        domain="Data Science/ML"
    elif [[ "$topic" =~ API|REST|GraphQL|HTTP ]]; then
        domain="Backend/API Development"
    elif [[ "$topic" =~ [Rr]eact|Vue|Angular|Frontend ]]; then
        domain="Frontend Development"
    elif [[ "$topic" =~ [Dd]atabase|SQL|NoSQL|MongoDB ]]; then
        domain="Database/Data Management"
    elif [[ "$topic" =~ [Ss]ecurity|[Aa]uth|OAuth ]]; then
        domain="Security"
    else
        domain="General Technology"
    fi
    
    echo "$domain"
}

# Suggest related contexts
suggest_related_contexts() {
    local topic="$1"
    local related=""
    
    if [[ "$topic" =~ [Kk]ubernetes ]]; then
        related="Docker, Containerization, DevOps, Microservices"
    elif [[ "$topic" =~ [Dd]ocker ]]; then
        related="Kubernetes, Containerization, DevOps, Linux"
    elif [[ "$topic" =~ [Mm]achine.*[Ll]earning ]]; then
        related="Python, Statistics, DataScience, NeuralNetworks"
    elif [[ "$topic" =~ GraphQL ]]; then
        related="REST-APIs, HTTP, Backend, TypeScript"
    elif [[ "$topic" =~ [Rr]eact ]]; then
        related="JavaScript, WebDevelopment, Frontend, StateManagement"
    fi
    
    if [ -n "$related" ]; then
        echo "Suggested related contexts: $related"
    fi
}

# Estimate concept count based on topic complexity
estimate_concepts() {
    local topic="$1"
    local word_count=$(echo "$topic" | wc -w)
    
    # Simple heuristic: broader topics = more concepts
    if [ $word_count -eq 1 ]; then
        echo "25-40 atomic concepts recommended (broad topic)"
    elif [ $word_count -eq 2 ]; then
        echo "15-25 atomic concepts recommended (focused topic)"
    else
        echo "10-20 atomic concepts recommended (specific topic)"
    fi
}

# Generate enhanced prompt with context analysis
generate_enhanced_prompt() {
    local topic="$1"
    local context_name="$2"
    local custom_requirements="$3"
    
    local domain=$(analyze_topic "$topic")
    local related=$(suggest_related_contexts "$topic")
    local concept_estimate=$(estimate_concepts "$topic")
    
    cat <<EOF
# Enhanced Vault Generation Request

## Topic Analysis

**Subject**: ${topic}
**Detected Domain**: ${domain}
**Context Name**: ${context_name}
${related:+**Related Contexts**: ${related}}
${concept_estimate:+**Scope**: ${concept_estimate}}
${custom_requirements:+**Custom Requirements**: ${custom_requirements}}

## Required Reference Files

1. **\`.instructions\`** — Vault architecture, templates, conventions, 28-point validation checklist (§1–§8)
2. **\`.zettelkasten\`** — 7-step atomic decomposition, Bloom's Taxonomy, quality criteria (§1–§7)

## Methodology (from .zettelkasten §2)

1. Identify first principles (domain axioms)
2. Map conceptual domains (3–6 clusters)
3. Extract atomic concepts (5–10 per domain)
4. Classify by Bloom level (remember → create)
5. Map dependencies as DAG (no cycles)
6. Create declarative titles (Subject-Verb-Object)
7. Assign tags \`#CONTEXT-REFERENCE\`

## Cognitive Progression (5 phases — from .instructions §4.2)

| Phase | Bloom | Focus |
|:------|:------|:------|
| 1 — Foundations | Remember, Understand | Axioms, definitions, primary principles |
| 2 — Structural Concepts | Understand, Apply | Patterns, mechanisms, relationships |
| 3 — Application | Apply, Analyze | Use cases, implementations, trade-offs |
| 4 — Analysis & Integration | Analyze, Evaluate | Cross-domain integration, anti-patterns |
| 5 — Creation & Extension | Evaluate, Create | Original projects, contributions |

## Required Deliverables

1. **Atomic decomposition table** (Seq, Title, Description, Prerequisites, Bloom, Tags)
2. **15–50 permanent notes** (200–300 words each, in \`10-CONTEXTS/${context_name}/permanent-notes/\`)
3. **Study plan** with Mermaid diagram and 5 phases (in \`20-STUDY-PLANS/${context_name}-Study-Plan.md\`)
4. **Master Index** and **Context Map** (in \`00-INDEX/\`)
5. **Dependency graph** in Mermaid (in \`30-MAPS/concept-maps/\`)

## Conventions (from .instructions §2)

- Titles: \`Subject-Verb-Object\` with hyphens
- Tags: \`#CONTEXT-REFERENCE\` PascalCase, 3–7 per note
- Links: WikiLinks \`[[note]]\` exclusively
- Diagrams: Mermaid exclusively
- Frontmatter: include \`bloom_level\` per note

## Validation (from .instructions §7 — 28 checks)

§7.1 Configuration (5) · §7.2 Structure (4) · §7.3 Content (7) · §7.4 Study Plan (5) · §7.5 Graph View (7)

---

**TOPIC**: ${topic}
**CONTEXT NAME**: ${context_name}

BEGIN GENERATION.

EOF
}

# Main execution
main() {
    local topic="$1"
    local context_name="$2"
    local custom_requirements="$3"
    
    if [ -z "$topic" ]; then
        echo "Usage: $0 <topic> [context_name] [custom_requirements]"
        exit 1
    fi
    
    if [ -z "$context_name" ]; then
        # Auto-generate context name from topic
        context_name=$(echo "$topic" | sed -e 's/[^a-zA-Z0-9 ]//g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1' | sed 's/ //g')
    fi
    
    generate_enhanced_prompt "$topic" "$context_name" "$custom_requirements"
}

# Execute if run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
