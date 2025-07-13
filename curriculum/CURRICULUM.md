# Integrated CLI Development Bootcamp
*Terminal • Vim • Bash • Git - A Complete Development Environment*

## Philosophy

This bootcamp teaches **development fundamentals through the CLI** using an integrated approach where Terminal, Vim, Bash, and Git work together as a unified development environment. Each day builds context-aware scripts that both teach concepts and preserve learning state for LLM continuity.

## Learning Architecture

**Core Pillars (learned in parallel):**
- **Terminal Navigation** - Movement, file operations, system interaction
- **Vim Mastery** - Modal editing, efficiency, muscle memory  
- **Bash Scripting** - Automation, logic, system integration
- **Git Workflow** - Version control, collaboration, project management

**Context Preservation System:**
- Each day ends with a comprehensive setup script
- Scripts encode the day's learning and reproduce environment
- Git commits create learning checkpoints
- LLM uses scripts to maintain context across sessions

---

## Day 1: Foundation & Environment Setup

### Morning: Terminal Fundamentals + Muscle Memory

**Core Navigation (Practice until automatic):**
```bash
# Essential hotkeys - practice 50+ times each
Ctrl+C          # Kill current command
Ctrl+D          # Exit/EOF
Ctrl+L          # Clear screen (alt: clear)
Ctrl+A          # Beginning of line
Ctrl+E          # End of line
Ctrl+U          # Cut line before cursor
Ctrl+K          # Cut line after cursor
Ctrl+Y          # Paste
Ctrl+R          # Reverse search history
!!              # Last command
!$              # Last argument

# Navigation muscle memory drills
pwd && ls -la && cd .. && pwd     # Orientation drill
cd ~ && cd / && cd - && pwd       # Movement drill
mkdir -p test/{a,b,c} && cd test && ls && cd ..  # Creation drill
```

**File Operations Speed Training:**
```bash
# Timed exercises (aim for <5 seconds each)
touch file{1..5}.txt                    # Bulk creation
ls -la | grep txt                       # Filter viewing
cp file1.txt backup.txt                 # Quick copy
mv file2.txt renamed.txt                # Quick rename
rm file{3..5}.txt                       # Bulk deletion
find . -name "*.txt" | wc -l            # Quick count
```

### Afternoon: Vim Introduction + Git Setup

**Vim Fundamentals (20-minute focused sessions):**
```bash
# Vim survival commands - practice until reflexive
vim practice.txt

# In Vim - practice each 10+ times:
i              # Insert mode
Esc            # Normal mode
:w             # Save
:q             # Quit
:wq            # Save and quit
:q!            # Quit without saving

# Basic movement (no arrow keys!)
h j k l        # Left, down, up, right
w b            # Word forward/back
0 $            # Line start/end
gg G           # File start/end
```

**Git Environment Setup:**
```bash
# Global configuration
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
git config --global core.editor vim

# Create learning repository
mkdir ~/cli-bootcamp
cd ~/cli-bootcamp
git init
echo "# CLI Development Bootcamp" > README.md
git add README.md
git commit -m "Initial commit: Begin CLI bootcamp journey"
```

### Evening: Integration Project

**Create Day 1 State Script (in Vim):**
```bash
cd ~/cli-bootcamp
vim scripts/day1_setup.sh
```

**Script Content (type in Vim for practice):**
```bash
#!/bin/bash
# Day 1: Foundation Setup Script
# This script recreates the Day 1 learning environment

set -euo pipefail

# Learning objectives completed:
# ✓ Terminal navigation and hotkeys
# ✓ File operations and permissions  
# ✓ Vim modal editing basics
# ✓ Git repository initialization

readonly BOOTCAMP_DIR="$HOME/cli-bootcamp"
readonly PRACTICE_DIR="$BOOTCAMP_DIR/practice"

log() { echo "[$(date +%H:%M:%S)] $1"; }

main() {
    log "Setting up Day 1 environment..."
    
    # Ensure we're in the right place
    cd "$BOOTCAMP_DIR" || exit 1
    
    # Create practice structure
    mkdir -p "$PRACTICE_DIR"/{basics,vim-practice,scripts}
    
    # Day 1 practice files
    cat > "$PRACTICE_DIR/basics/navigation-drill.md" << 'EOF'
# Navigation Muscle Memory Checklist
- [ ] pwd (know where you are)
- [ ] ls -la (see everything)
- [ ] cd .. (go up)
- [ ] cd ~ (go home)
- [ ] cd - (go back)
- [ ] Ctrl+R (search history)
- [ ] Ctrl+L (clear screen)
- [ ] Tab completion (autocomplete)
EOF
    
    # Vim practice file
    cat > "$PRACTICE_DIR/vim-practice/movements.txt" << 'EOF'
Practice these movements without arrow keys:
h j k l - basic movement
w b - word navigation  
0 $ - line boundaries
gg G - file boundaries
i a o - insert modes
Esc - always return to normal mode
EOF
    
    # Sample data for tomorrow
    cat > "$PRACTICE_DIR/basics/sample.log" << 'EOF'
2025-07-13 10:30:45 [INFO] System started
2025-07-13 10:31:22 [ERROR] Database connection failed
2025-07-13 10:32:15 [WARN] High memory usage detected
2025-07-13 10:33:08 [INFO] User login: john_doe
2025-07-13 10:34:45 [ERROR] File not found: /missing.txt
EOF
    
    log "Day 1 environment ready!"
    log "Next: Practice vim movements and terminal hotkeys"
    echo "Repository status:"
    git status --short
}

main "$@"
```

**Commit Learning State:**
```bash
chmod +x scripts/day1_setup.sh
./scripts/day1_setup.sh                    # Test the script
git add .
git commit -m "Day 1: Terminal, Vim, Git foundations

- Learned terminal navigation and hotkeys
- Basic vim modal editing (i, Esc, :w, :q)  
- File operations and permissions
- Git repository setup and workflow
- Created context preservation script"
```

---

## Day 2: Text Processing + Vim Efficiency

### Morning: Advanced Terminal + Piping

**Hotkey Mastery Expansion:**
```bash
# History navigation (practice until automatic)
Ctrl+P / Up      # Previous command
Ctrl+N / Down    # Next command  
Ctrl+R           # Reverse search
!!               # Repeat last command
!n               # Repeat command number n
!string          # Last command starting with string

# Line editing mastery
Alt+F / Ctrl+→   # Forward word
Alt+B / Ctrl+←   # Backward word
Alt+D            # Delete word forward
Ctrl+W           # Delete word backward
Ctrl+T           # Transpose characters
```

**Piping and Text Processing:**
```bash
# Build muscle memory with common patterns
cat file | grep pattern | sort | uniq -c
ps aux | grep process | awk '{print $2}'
ls -la | grep "^d" | wc -l
history | tail -20 | grep git
find . -name "*.txt" | xargs grep "pattern"
```

### Afternoon: Vim Productivity Features

**Vim Efficiency Training:**
```bash
vim practice/vim-practice/efficiency.txt
```

**In Vim (practice each command 10+ times):**
```bash
# Advanced movement
f<char>        # Find character on line
t<char>        # Till character on line
/<pattern>     # Search forward
?<pattern>     # Search backward
n / N          # Next/previous search

# Editing efficiency  
dd             # Delete line
yy             # Yank (copy) line
p / P          # Paste after/before
u              # Undo
Ctrl+R         # Redo
x              # Delete character
r<char>        # Replace character

# Visual mode
v              # Visual mode
V              # Visual line mode
y              # Yank selection
d              # Delete selection
```

**Vim Configuration:**
```bash
vim ~/.vimrc
```

**Add to .vimrc:**
```vim
" Essential vim configuration for bootcamp
set number
set relativenumber
set hlsearch
set incsearch
set tabstop=4
set shiftwidth=4
set expandtab
syntax on
```

### Evening: Advanced Script Creation

**Day 2 Integration Script (in Vim):**
```bash
vim scripts/day2_setup.sh
```

**Enhanced Script with Text Processing:**
```bash
#!/bin/bash
# Day 2: Text Processing + Vim Efficiency Setup
# Builds on Day 1 foundation with advanced terminal and vim skills

set -euo pipefail

readonly BOOTCAMP_DIR="$HOME/cli-bootcamp"
readonly DATA_DIR="$BOOTCAMP_DIR/data"
readonly SCRIPTS_DIR="$BOOTCAMP_DIR/scripts"

log() { echo "[$(date +%H:%M:%S)] $1"; }
create_sample_data() {
    # Web server logs for grep/awk practice
    cat > "$DATA_DIR/access.log" << 'EOF'
192.168.1.100 - - [13/Jul/2025:10:30:45] "GET /index.html HTTP/1.1" 200 2048
10.0.0.50 - - [13/Jul/2025:10:31:22] "POST /api/login HTTP/1.1" 200 512
192.168.1.100 - - [13/Jul/2025:10:32:15] "GET /about.html HTTP/1.1" 404 0
203.0.113.25 - - [13/Jul/2025:10:33:08] "GET /contact.php HTTP/1.1" 500 1024
10.0.0.50 - - [13/Jul/2025:10:34:45] "GET /admin/dashboard HTTP/1.1" 403 256
EOF

    # CSV data for cut/sort practice
    cat > "$DATA_DIR/employees.csv" << 'EOF'
id,name,email,department,salary
1,John Doe,john@company.com,Engineering,85000
2,Jane Smith,jane@company.com,Marketing,72000
3,Bob Johnson,bob@company.com,Sales,68000
4,Alice Brown,alice@company.com,Engineering,92000
5,Charlie Wilson,charlie@company.com,Marketing,75000
EOF

    # System logs for advanced grep
    cat > "$DATA_DIR/system.log" << 'EOF'
Jul 13 10:30:45 server01 kernel: [12345.678] USB disconnect
Jul 13 10:31:22 server01 sshd[1234]: Failed password for user from 192.168.1.50
Jul 13 10:32:15 server01 httpd[5678]: [error] File not found: /var/www/missing
Jul 13 10:33:08 server01 mysqld[9012]: [Warning] Slow query detected
Jul 13 10:34:45 server01 sshd[1234]: Accepted publickey for admin from 10.0.0.100
EOF
}

create_analysis_scripts() {
    # Log analyzer with advanced text processing
    cat > "$SCRIPTS_DIR/analyze_logs.sh" << 'EOF'
#!/bin/bash
# Advanced log analysis demonstrating Day 2 concepts

readonly LOG_DIR="$(dirname "$0")/../data"

echo "=== Web Server Analysis ==="
echo "Total requests: $(wc -l < "$LOG_DIR/access.log")"
echo "Unique IPs: $(awk '{print $1}' "$LOG_DIR/access.log" | sort -u | wc -l)"
echo "Status code distribution:"
awk '{print $9}' "$LOG_DIR/access.log" | sort | uniq -c | sort -nr

echo -e "\n=== Top Requested URLs ==="
awk '{print $7}' "$LOG_DIR/access.log" | sort | uniq -c | sort -nr

echo -e "\n=== Error Analysis ==="
grep -c "404\|500\|403" "$LOG_DIR/access.log" || echo "0"

echo -e "\n=== System Events ==="
grep -E "(Failed|error|Warning)" "$LOG_DIR/system.log" | wc -l
EOF
    chmod +x "$SCRIPTS_DIR/analyze_logs.sh"

    # Data processing script
    cat > "$SCRIPTS_DIR/process_data.sh" << 'EOF'
#!/bin/bash
# CSV processing examples

readonly CSV_FILE="$(dirname "$0")/../data/employees.csv"

echo "=== Employee Data Analysis ==="
echo "Total employees: $(($(wc -l < "$CSV_FILE") - 1))"

echo -e "\nBy Department:"
tail -n +2 "$CSV_FILE" | cut -d',' -f4 | sort | uniq -c

echo -e "\nAverage Salary by Department:"
for dept in Engineering Marketing Sales; do
    avg=$(tail -n +2 "$CSV_FILE" | grep "$dept" | cut -d',' -f5 | \
          awk '{sum+=$1; count++} END {print sum/count}')
    printf "%-12s: $%.0f\n" "$dept" "$avg"
done

echo -e "\nHighest Paid Employees:"
tail -n +2 "$CSV_FILE" | sort -t',' -k5 -nr | head -3 | \
    awk -F',' '{printf "%-15s %-12s $%s\n", $2, $4, $5}'
EOF
    chmod +x "$SCRIPTS_DIR/process_data.sh"
}

main() {
    log "Setting up Day 2 environment..."
    
    # Run Day 1 setup first
    [[ -f "$SCRIPTS_DIR/day1_setup.sh" ]] && "$SCRIPTS_DIR/day1_setup.sh"
    
    # Create data directory
    mkdir -p "$DATA_DIR" "$SCRIPTS_DIR"
    
    create_sample_data
    create_analysis_scripts
    
    # Vim practice exercises
    cat > practice/vim-practice/day2-exercises.txt << 'EOF'
VIM EFFICIENCY EXERCISES:
1. Open this file in vim
2. Navigate to each exercise using /Exercise
3. Complete the editing tasks
4. Save with :w

Exercise 1: Delete these three lines
Line to delete 1
Line to delete 2  
Line to delete 3

Exercise 2: Replace 'old' with 'new' in this line
This is the old way of doing things old style old habits

Exercise 3: Copy the line below and paste it 3 times
Copy this line exactly

Exercise 4: Sort these numbers (use visual mode)
5
1
3
2
4
EOF
    
    log "Day 2 environment ready!"
    log "Practice commands:"
    echo "  ./scripts/analyze_logs.sh"
    echo "  ./scripts/process_data.sh"
    echo "  vim practice/vim-practice/day2-exercises.txt"
}

main "$@"
```

**Commit Progress:**
```bash
chmod +x scripts/day2_setup.sh
./scripts/day2_setup.sh
git add .
git commit -m "Day 2: Text processing and Vim efficiency

- Advanced terminal hotkeys and history navigation
- Piping and text processing with grep, awk, sort, uniq
- Vim productivity: search, visual mode, editing commands
- Created sample data and analysis scripts
- Enhanced vim configuration for development"
```

---

## Day 3: Bash Scripting + Version Control Integration

### Morning: Scripting Fundamentals

**Variables and Logic in Practice:**
```bash
# Create interactive scripts in vim
vim scripts/interactive_demo.sh
```

**Script Development Workflow:**
```bash
#!/bin/bash
# Interactive demonstration of bash concepts

# Variables and user input
read -p "Enter your name: " username
echo "Hello, $username! Today is $(date +%A)"

# Conditional logic
if [[ -f "$HOME/.bashrc" ]]; then
    echo "Found your bash configuration"
else
    echo "No bash config found"
fi

# Loop demonstration  
echo "Counting to 5:"
for i in {1..5}; do
    echo "  $i"
    sleep 0.5
done

# Function example
greet_user() {
    local name="$1"
    local time=$(date +%H)
    
    if [[ $time -lt 12 ]]; then
        echo "Good morning, $name!"
    elif [[ $time -lt 17 ]]; then
        echo "Good afternoon, $name!"
    else
        echo "Good evening, $name!"
    fi
}

greet_user "$username"
```

### Afternoon: Git Workflow Mastery

**Git Commands Muscle Memory:**
```bash
# Practice these until automatic
git status              # Check repository state
git add .              # Stage all changes
git add file.txt       # Stage specific file
git commit -m "msg"    # Commit with message
git log --oneline      # View commit history
git diff               # See unstaged changes
git diff --staged      # See staged changes
git checkout file      # Discard changes
git reset HEAD file    # Unstage file
```

**Branching for Feature Development:**
```bash
git checkout -b feature/day3-scripting
# Work on Day 3 features
git add .
git commit -m "Add Day 3 scripting exercises"
git checkout main
git merge feature/day3-scripting
git branch -d feature/day3-scripting
```

### Evening: Master Integration Script

**Day 3 Complete Environment (in Vim):**
```bash
vim scripts/day3_setup.sh
```

**Comprehensive Script:**
```bash
#!/bin/bash
# Day 3: Complete CLI Development Environment
# Integrates Terminal, Vim, Bash, and Git workflows

set -euo pipefail

readonly BOOTCAMP_DIR="$HOME/cli-bootcamp"
readonly SCRIPTS_DIR="$BOOTCAMP_DIR/scripts" 
readonly EXERCISES_DIR="$BOOTCAMP_DIR/exercises"

# Color output for better UX
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

log() { echo -e "${GREEN}[$(date +%H:%M:%S)]${NC} $1"; }
info() { echo -e "${BLUE}ℹ${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }

setup_git_hooks() {
    # Pre-commit hook to run tests
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Run basic checks before commit

echo "Running pre-commit checks..."

# Check for bash syntax errors
for script in scripts/*.sh; do
    if [[ -f "$script" ]]; then
        bash -n "$script" || {
            echo "Syntax error in $script"
            exit 1
        }
    fi
done

echo "All checks passed!"
EOF
    chmod +x .git/hooks/pre-commit
}

create_advanced_exercises() {
    mkdir -p "$EXERCISES_DIR"/{bash,vim,integration}
    
    # Bash scripting challenges
    cat > "$EXERCISES_DIR/bash/system_monitor.sh" << 'EOF'
#!/bin/bash
# System monitoring script exercise
# TODO: Implement these functions

monitor_disk_usage() {
    # Show disk usage for all mounted filesystems
    # Alert if any filesystem is >80% full
    echo "TODO: Implement disk monitoring"
}

monitor_memory() {
    # Show memory usage
    # Calculate percentage used
    echo "TODO: Implement memory monitoring"  
}

monitor_processes() {
    # Show top 5 CPU-consuming processes
    # Show total process count
    echo "TODO: Implement process monitoring"
}

generate_report() {
    # Combine all monitoring into a report
    # Include timestamp and hostname
    echo "TODO: Generate comprehensive report"
}

main() {
    monitor_disk_usage
    monitor_memory
    monitor_processes
    generate_report
}

main "$@"
EOF
    
    # Vim efficiency challenges
    cat > "$EXERCISES_DIR/vim/refactoring_practice.txt" << 'EOF'
VIM REFACTORING EXERCISE:
Use vim commands to transform this messy code into clean, readable format.

Challenges:
1. Fix indentation (use >> and << in visual mode)
2. Add proper spacing around operators
3. Rename variables consistently
4. Remove duplicate lines
5. Sort function definitions alphabetically

MESSY CODE TO CLEAN UP:
function badlyNamed(){
var x=5;
var y=10;
var result=x+y;
return result;
}
function badlyNamed(){
var x=5;
var y=10;
var result=x+y;
return result;
}
function anotherFunction(){
var a=1;
var b=2;
return a+b;
}
function yetAnother(){
var data="hello world";
return data.toUpperCase();
}
EOF

    # Integration challenge
    cat > "$EXERCISES_DIR/integration/project_manager.sh" << 'EOF'
#!/bin/bash
# Project manager - integrates all skills learned
# This script should demonstrate terminal, vim, bash, and git skills

# TODO: Implement a script that:
# 1. Creates a new project directory structure
# 2. Initializes a git repository  
# 3. Creates template files using vim/heredocs
# 4. Sets up a development workflow
# 5. Includes error handling and logging
# 6. Provides interactive menu system

echo "TODO: Build complete project management system"
echo "Skills to demonstrate:"
echo "  - File/directory operations"
echo "  - Git workflow automation"  
echo "  - Script organization and functions"
echo "  - User interaction and menus"
echo "  - Error handling and validation"
EOF
    
    chmod +x "$EXERCISES_DIR"/{bash,integration}/*.sh
}

create_bootcamp_summary() {
    cat > BOOTCAMP_PROGRESS.md << 'EOF'
# CLI Development Bootcamp Progress

## Skills Mastered

### Terminal Proficiency
- [x] Navigation and file operations
- [x] Hotkeys and shortcuts (Ctrl+R, Ctrl+A, etc.)
- [x] Piping and redirection
- [x] Text processing (grep, awk, sort, cut)
- [x] Process management

### Vim Mastery  
- [x] Modal editing (normal, insert, visual)
- [x] Movement commands (hjkl, w/b, 0/$, gg/G)
- [x] Editing efficiency (dd, yy, p, u, search)
- [x] Configuration and customization
- [x] Integration with development workflow

### Bash Scripting
- [x] Variables and user input
- [x] Conditional statements and loops
- [x] Functions and script organization
- [x] Error handling and best practices
- [x] System interaction and automation

### Git Workflow
- [x] Repository initialization and configuration
- [x] Basic workflow (add, commit, status, log)
- [x] Branching and merging
- [x] Integration with development process
- [x] Hooks and automation

## Context Preservation System

Each day's learning is preserved through:
- **Setup Scripts**: Recreate entire learning environment
- **Git Commits**: Version control with detailed messages
- **Progress Tracking**: Markdown documentation of skills
- **Exercise Collections**: Hands-on practice materials

## Next Steps

Ready for advanced topics:
- Advanced bash scripting patterns
- Vim plugins and advanced configuration  
- Git collaboration workflows
- CLI-based development tools integration
- System administration and DevOps practices

## Repository Structure
```
cli-bootcamp/
├── scripts/           # Daily setup and utility scripts
├── practice/          # Basic exercises and drills
├── data/             # Sample data for processing
├── exercises/        # Advanced challenges
└── BOOTCAMP_PROGRESS.md
```
EOF
}

main() {
    log "Setting up Day 3 complete environment..."
    
    cd "$BOOTCAMP_DIR" || exit 1
    
    # Ensure previous days are set up
    for day in 1 2; do
        if [[ -f "$SCRIPTS_DIR/day${day}_setup.sh" ]]; then
            log "Running Day $day setup..."
            "$SCRIPTS_DIR/day${day}_setup.sh"
        fi
    done
    
    setup_git_hooks
    create_advanced_exercises  
    create_bootcamp_summary
    
    log "Day 3 environment complete!"
    info "Try these commands:"
    echo "  git log --oneline --graph"
    echo "  vim exercises/vim/refactoring_practice.txt"
    echo "  ./exercises/bash/system_monitor.sh"
    
    warn "Don't forget to commit your progress!"
    echo "  git add ."
    echo "  git commit -m 'Complete Day 3: Advanced integration'"
}

main "$@"
```

---

## Bootcamp Outcomes

**By Day 3, you will have:**

### Technical Skills
- **Terminal**: Navigate efficiently, use hotkeys reflexively, chain commands with pipes
- **Vim**: Edit code efficiently, use modal editing naturally, customize environment
- **Bash**: Write functional scripts, handle errors, automate workflows  
- **Git**: Manage code versions, work with branches, integrate with development

### Development Environment
- **Integrated Workflow**: All tools work together seamlessly
- **Context Persistence**: Scripts preserve and recreate learning state
- **Version Control**: Every step documented and recoverable
- **Automation**: Repetitive tasks scripted and efficient

### Bootcamp Infrastructure
- **Self-Documenting**: Scripts explain what was learned each day
- **LLM Context**: Detailed commit messages and documentation
- **Reproducible**: Complete environment recreation from any script
- **Extensible**: Foundation for advanced development topics

## Usage for LLM Context

**For each session:**
1. `git log --oneline` - See learning progression
2. `cat BOOTCAMP_PROGRESS.md` - Review skills status  
3. `./scripts/day{X}_setup.sh` - Recreate environment
4. Continue from documented stopping point

**For extending bootcamp:**
- Fork approach for specialized tracks (DevOps, Web Dev, etc.)
- Use existing scripts as templates
- Maintain context preservation pattern
- Build on established muscle memory

This creates a **self-sustaining learning system** where the environment evolves with the learner and maintains continuity across sessions.