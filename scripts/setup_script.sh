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