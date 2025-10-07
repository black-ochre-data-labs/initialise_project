# Project Initialisation

This contains a simple bash script to initialise a new project directory with a standard structure and files.
The default directories and files will becreated as follows

```
.
├── analysis
│   ├── index.Rmd
│   ├── references.bib
│   └── _site.yml
├── config
│   └── config.yml
├── data
│   └── external
├── docs
├── initial_prophecy_analysis.Rproj
├── output
├── README.md
├── scripts
└── workflow
    ├── benchmarks
    ├── envs
    ├── logs
    ├── rules
    ├── scripts
    └── Snakefile
```

By default:

- The most basic structure for an integrated RMarkdown and Snakemake workflow will be created
    - This includes `analysis/_site.yml` where any subsequent analyses can be added to the compiled html
    - `analysis/index.Rmd` with a basic YAML header, references and `sessionInfo()`
    - An empty `reference.bib` file for citations
    - A basic `Snakefile` and directory structure for Snakemake
- An RStudio project file will be created
- A git repository will be initialised
- A README.md file will be created

Simply source the script `initialise_project.sh` then call

``` bash
initialise_project target_directory
```

If no target directory is provided, the file structure will be created in the current directory.

Key arguments are:

- `--no-git`: Disable the creation of a git repository
- `--no-rproj`: Disable the creation of an R Project file
- `--no-readme`: Do not create a README.md file
- `--no-snakemake`: Do not create the basic template for a Snakemake workflow. This will exclude the contents of the `workflow/` directory and the contents of the  `config/` directory
- `--minimal`: Will turn on all `--no-*` flags and only create a minimal directory structure excluding all template files, the git repository, the `workflow` folder and the R Project file
