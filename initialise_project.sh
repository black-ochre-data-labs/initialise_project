#!/usr/bin/env bash

initialise_project() {
    local project_dir="."
    local do_git=true
    local do_readme=true
    local do_rproj=true
    local do_snakemake=true

    # Parse arguments
    for arg in "$@"; do
        case "$arg" in
            --no-git) do_git=false ;;
            --no-readme) do_readme=false ;;
            --no-rproj) do_rproj=false ;;
            --no-snakemake) do_snakemake=false ;;
            *) project_dir="$arg" ;;
        esac
    done

    # Get project name (used for .Rproj)
    local project_name
    project_name=$(basename "$(realpath "$project_dir")")

    echo "Initializing project in: $project_dir"

    # Define general subdirectories
    local subdirs=(
        "analysis"
        "data/external"
        "docs"
        "output"
        "scripts"
    )

    # Add Snakemake structure if enabled
    if $do_snakemake; then
        subdirs+=(
            "workflow"
            "workflow/benchmarks"
            "workflow/envs"
            "workflow/logs"
            "workflow/rules"
            "workflow/scripts"
            "config"
        )
    fi

    # Create directories
    mkdir -p "$project_dir"
    for subdir in "${subdirs[@]}"; do
        mkdir -p "${project_dir}/${subdir}"
    done

    # README.md
    if $do_readme; then
        local readme="${project_dir}/README.md"
        if [[ ! -f "$readme" ]]; then
            cat > "$readme" <<EOF
# ${project_name}

Project initialized on $(date '+%Y-%m-%d').

## Structure

- \`analysis/\`: Analytical notebooks, rmakrdown, quarto, etc. 
- \`data/\`: Any data can go here, with subdirectory for external data
- \`docs/\`: Compiled html output, able to be published on github pages  
- \`output/\`: Additional output files  
- \`scripts/\`: Additional scripts, including standalone R functions and bash
$( $do_snakemake && echo "- \`config/\`: Contains blank config.yml" )
$( $do_snakemake && echo "- \`workflow/\`: Snakemake workflows, rules, environments, benchmarks and scripts" )

EOF
            echo "Created README.md"
        fi
    fi

    # Git init
    if $do_git; then
        if [[ ! -d "${project_dir}/.git" ]]; then
            git -C "$project_dir" init >/dev/null 2>&1
            echo "Initialized Git repository"
        fi
        echo "${project_name}.Rproj" >> "${project_dir}/.gitignore"
        echo 'logs/' >> "${project_dir}/.gitignore"
        echo 'data/' >> "${project_dir}/.gitignore"
    fi

    if $do_snakemake; then
        # config.yml
        touch "${project_dir}/config/config.yml"
    fi

    # R Project file
    if $do_rproj; then
        local rproj="${project_dir}/${project_name}.Rproj"
        if [[ ! -f "$rproj" ]]; then
            cat > "$rproj" <<EOF
Version: 1.0

RestoreWorkspace: No
SaveWorkspace: No
AlwaysSaveHistory: Default

EnableCodeIndexing: Yes
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: UTF-8

RnwWeave: knitr
LaTeX: pdfLaTeX
EOF
            echo "Created ${project_name}.Rproj"
        fi
    fi

    # Snakemake boilerplate
    if $do_snakemake; then
        local snakefile="${project_dir}/workflow/Snakefile"
        if [[ ! -f "$snakefile" ]]; then
            cat > "$snakefile" <<'EOF'

# Snakefile
# Default Snakemake workflow
import pandas as pd
import os

configfile: "config/config.yml"

rule all:
    input:

include:

EOF
            echo "Created workflow/Snakefile"
        fi
    fi

    echo "✅ Project '${project_name}' initialized successfully."
}