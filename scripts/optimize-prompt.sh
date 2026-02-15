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
# 🎯 ENHANCED VAULT GENERATION REQUEST

## TOPIC ANALYSIS

**Subject**: ${topic}
**Detected Domain**: ${domain}
**Context Name**: ${context_name}
${related:+**Related Contexts**: ${related}}
${concept_estimate:+**Scope**: ${concept_estimate}}

[Continue with full enhanced prompt from previous version...]

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
