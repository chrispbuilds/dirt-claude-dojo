# Meta-Lesson: Setting Up the Shared Learning System

## Overview
Before starting the CLI Development Bootcamp, we'll establish a shared learning repository that contains both the curriculum and the learning environment. This creates a system that others can fork, use, and contribute to.

## Repository Structure
```
cli-bootcamp/
├── curriculum/
│   ├── CURRICULUM.md          # The lesson plan artifact
│   ├── day1-foundations.md    # Daily lesson details
│   ├── day2-text-processing.md
│   └── day3-integration.md
├── scripts/
│   ├── setup_bootcamp.sh     # Initial environment setup
│   ├── day1_setup.sh         # Daily environment scripts
│   ├── day2_setup.sh
│   └── day3_setup.sh
├── practice/                  # Student practice area
├── data/                     # Sample data files
├── exercises/                # Advanced challenges
├── README.md                 # Repository documentation
└── .gitignore               # Git ignore patterns
```

## Meta-Setup Steps

### 1. Clean Slate & Repository Creation
```bash
# Remove existing practice directories
rm -rf ~/bash-bootcamp ~/cli-bootcamp

# Create the new shared learning repository
mkdir ~/cli-bootcamp
cd ~/cli-bootcamp

# Initialize git repository
git init
```

### 2. Create Repository Structure
```bash
# Create directory structure
mkdir -p {curriculum,scripts,practice,data,exercises}
mkdir -p practice/{basics,vim-practice}
mkdir -p exercises/{bash,vim,integration}
mkdir -p data/samples
```

### 3. Create Core Documentation
```bash
# Main README for the repository
cat > README.md << 'EOF'
# CLI Development Bootcamp

An integrated learning system for mastering Terminal, Vim, Bash, and Git through hands-on practice.

## Quick Start

```bash
git clone [your-repo-url] cli-bootcamp
cd cli-bootcamp
./scripts/setup_bootcamp.sh
```

## Learning Philosophy

This bootcamp teaches development fundamentals through the CLI using an integrated approach where Terminal, Vim, Bash, and Git work together as a unified development environment.

### Key Features
- **Integrated Learning**: All tools taught in parallel
- **Context Preservation**: Scripts maintain learning state
- **LLM Compatible**: Designed for AI-assisted learning
- **Self-Documenting**: Every step creates reusable artifacts

## Structure

- `curriculum/` - Lesson plans and learning materials
- `scripts/` - Environment setup and utility scripts  
- `practice/` - Student workspace and exercises
- `data/` - Sample data for processing practice
- `exercises/` - Advanced challenges and projects

## Usage

Each day builds on the previous, creating scripts that preserve and recreate the learning environment. Perfect for:
- Self-paced learning
- LLM-assisted education
- Team training programs
- Educational tool development

## Contributing

This system is designed to be extended and improved. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Personal practice files
practice/personal/
*.tmp
*.log

# System files
.DS_Store
Thumbs.db

# Editor backups
*~
*.swp
*.swo

# Local configuration
.env
config.local
EOF

# Create contributing guidelines
cat > CONTRIBUTING.md << 'EOF'
# Contributing to CLI Development Bootcamp

## How to Contribute

1. **Fork the Repository**
2. **Create a Feature Branch**: `git checkout -b feature/new-lesson`
3. **Make Changes**: Add lessons, fix bugs, improve scripts
4. **Test Changes**: Run setup scripts to ensure they work
5. **Commit Changes**: Use descriptive commit messages
6. **Submit Pull Request**: Describe your changes and their benefits

## Types of Contributions

### New Lessons
- Follow the established format
- Include practice exercises
- Create setup scripts
- Document learning objectives

### Bug Fixes
- Fix script errors
- Improve documentation
- Correct typos or inconsistencies

### Enhancements
- Add new exercises
- Improve existing scripts
- Optimize learning paths
- Add platform support

## Script Standards

All scripts should:
- Include proper error handling (`set -euo pipefail`)
- Use consistent logging format
- Be idempotent (safe to run multiple times)
- Include help/usage information

## Documentation Standards

- Clear learning objectives
- Step-by-step instructions
- Expected outcomes
- Troubleshooting sections
EOF
```

### 4. Save the Curriculum Artifact
```bash
# Copy the curriculum from our artifact into version control
vim curriculum/CURRICULUM.md
```

**In vim, paste the complete curriculum artifact we created. Then:**
```vim
:w
:q
```

### 5. Create the Master Setup Script
```bash
vim scripts/setup_bootcamp.sh
```

**Master setup script:**
```bash
#!/bin/bash
# CLI Development Bootcamp - Master Setup Script
# Creates the complete learning environment from scratch

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BOOTCAMP_DIR="$(dirname "$SCRIPT_DIR")"
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

log() { echo -e "${GREEN}[$(date +%H:%M:%S)]${NC} $1"; }
info() { echo -e "${BLUE}ℹ${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }

show_banner() {
    cat << 'BANNER'
╔═══════════════════════════════════════╗
║     CLI Development Bootcamp          ║
║   Terminal • Vim • Bash • Git         ║
╚═══════════════════════════════════════╝
BANNER
}

check_prerequisites() {
    local missing=()
    
    command -v git >/dev/null || missing+=("git")
    command -v vim >/dev/null || missing+=("vim")
    command -v bash >/dev/null || missing+=("bash")
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        warn "Missing prerequisites: ${missing[*]}"
        echo "Please install missing tools and try again."
        exit 1
    fi
}

setup_git_config() {
    # Only set if not already configured
    if [[ -z "$(git config --global user.name 2>/dev/null || true)" ]]; then
        warn "Git not configured. Please set up git first:"
        echo "  git config --global user.name 'Your Name'"
        echo "  git config --global user.email 'your.email@example.com'"
        exit 1
    fi
    
    # Set vim as default editor if not set
    if [[ -z "$(git config --global core.editor 2>/dev/null || true)" ]]; then
        git config --global core.editor vim
        log "Set vim as default git editor"
    fi
}

create_directory_structure() {
    log "Creating directory structure..."
    
    cd "$BOOTCAMP_DIR"
    
    # Ensure all directories exist
    mkdir -p practice/{basics,vim-practice,advanced}
    mkdir -p data/{samples,logs,csv}
    mkdir -p exercises/{bash,vim,integration}
    mkdir -p scripts/utils
    
    # Create practice subdirectories
    mkdir -p practice/basics/{navigation,file-ops,permissions}
    mkdir -p practice/vim-practice/{movements,editing,configuration}
}

create_initial_practice_files() {
    log "Creating initial practice files..."
    
    # Basic navigation practice
    cat > practice/basics/navigation/commands.md << 'EOF'
# Navigation Commands Practice

## Essential Commands
- `pwd` - Print working directory
- `ls` - List files
- `ls -la` - List all files with details
- `cd` - Change directory
- `cd ~` - Go home
- `cd ..` - Go up one level
- `cd -` - Go to previous directory

## Practice Exercises
1. Navigate to your home directory
2. List all files including hidden ones
3. Go to the root directory and back
4. Use tab completion for directory names
EOF

    # Vim practice file
    cat > practice/vim-practice/movements/basic.txt << 'EOF'
VIM MOVEMENT PRACTICE FILE

Use this file to practice vim movements:

1. Basic movements: h j k l (left, down, up, right)
2. Word movements: w (next word), b (previous word)
3. Line movements: 0 (start), $ (end)
4. File movements: gg (top), G (bottom)
5. Search: /pattern (forward), ?pattern (backward)

Practice moving around this file without using arrow keys!

Line 1: Navigate here with gg
Line 2: Move word by word with w and b
Line 3: Jump to start with 0, end with $
Line 4: Search for "target" to find -> target
Line 5: Go to bottom with G
EOF

    # Sample data files
    cat > data/samples/practice.log << 'EOF'
2025-07-13 10:30:45 [INFO] Application started
2025-07-13 10:31:22 [ERROR] Database connection failed
2025-07-13 10:32:15 [WARN] High memory usage detected
2025-07-13 10:33:08 [INFO] User authentication successful
2025-07-13 10:34:45 [ERROR] File not found: config.xml
2025-07-13 10:35:12 [INFO] Processing complete
EOF
}

setup_vim_config() {
    log "Setting up vim configuration..."
    
    # Create basic vimrc if it doesn't exist
    if [[ ! -f "$HOME/.vimrc" ]]; then
        cat > "$HOME/.vimrc" << 'EOF'
" CLI Bootcamp Vim Configuration
set number
set relativenumber
set hlsearch
set incsearch
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
syntax on

" Disable arrow keys to enforce hjkl
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
EOF
        log "Created basic .vimrc configuration"
    else
        info "Existing .vimrc found, skipping vim configuration"
    fi
}

create_welcome_script() {
    cat > scripts/welcome.sh << 'EOF'
#!/bin/bash
# Welcome script for CLI Bootcamp

cat << 'WELCOME'
🎉 Welcome to CLI Development Bootcamp! 🎉

Your learning environment is ready. Here's how to get started:

📚 CURRICULUM:
   View the full curriculum: cat curriculum/CURRICULUM.md
   
🚀 QUICK START:
   Day 1: Terminal foundations and vim basics
   Day 2: Text processing and piping
   Day 3: Bash scripting and git integration
   
📂 PRACTICE AREAS:
   practice/basics/        - Terminal and file operations
   practice/vim-practice/  - Vim movement and editing
   exercises/             - Advanced challenges
   
🔧 USEFUL COMMANDS:
   ./scripts/day1_setup.sh  - Set up Day 1 environment
   git log --oneline        - View your progress
   vim practice/vim-practice/movements/basic.txt - Start vim practice
   
💡 TIPS:
   - Commit your progress after each day
   - Practice vim movements daily
   - Use the scripts to recreate environments
   - Don't be afraid to break things in practice/
   
Ready to become a CLI master? Start with Day 1! 🚀
WELCOME
EOF
    chmod +x scripts/welcome.sh
}

finalize_setup() {
    log "Finalizing setup..."
    
    cd "$BOOTCAMP_DIR"
    
    # Make all scripts executable
    find scripts -name "*.sh" -exec chmod +x {} \;
    
    # Initial git commit
    git add .
    git commit -m "Initial setup: CLI Development Bootcamp

- Created repository structure
- Added curriculum documentation
- Set up practice areas and sample data
- Configured vim for learning
- Ready for Day 1 of bootcamp"
    
    # Show completion message
    echo
    log "🎉 CLI Development Bootcamp setup complete!"
    info "Repository initialized at: $BOOTCAMP_DIR"
    warn "Next steps:"
    echo "  1. Review curriculum: cat curriculum/CURRICULUM.md"
    echo "  2. Start Day 1: Begin with terminal foundations"
    echo "  3. Practice daily: Use practice areas and exercises"
    echo "  4. Commit progress: Document your learning journey"
    echo
    echo "Run './scripts/welcome.sh' anytime for a quick refresher!"
}

main() {
    show_banner
    log "Starting CLI Development Bootcamp setup..."
    
    check_prerequisites
    setup_git_config
    create_directory_structure
    create_initial_practice_files
    setup_vim_config
    create_welcome_script
    finalize_setup
}

main "$@"
```

### 6. Initial Commit and GitHub Setup
```bash
# Make setup script executable
chmod +x scripts/setup_bootcamp.sh

# Add all files to git
git add .

# Initial commit
git commit -m "Meta-setup: Create CLI Development Bootcamp repository

- Established repository structure
- Added curriculum documentation
- Created master setup script
- Prepared for collaborative learning
- Ready for GitHub publication"

# Create GitHub repository (assuming you have GitHub CLI)
# gh repo create cli-bootcamp --public --description "Integrated CLI development learning system"

# Or add remote manually:
# git remote add origin https://github.com/yourusername/cli-bootcamp.git
# git push -u origin main
```

### 7. Test the System
```bash
# Test that our setup script works
./scripts/setup_bootcamp.sh

# Show the welcome message
./scripts/welcome.sh

# Verify structure
tree . -L 3
```

## Next Steps

Now you have a **complete learning system** that is:
- ✅ **Version controlled** - Every change is tracked
- ✅ **Shareable** - Others can clone and use
- ✅ **Self-documenting** - Scripts explain themselves
- ✅ **LLM-friendly** - Context preserved in git history
- ✅ **Extensible** - Easy to add new lessons and features

Ready to proceed with Day 1 of the integrated curriculum?