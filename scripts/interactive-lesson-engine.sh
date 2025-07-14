#!/bin/bash
# Interactive Lesson Engine for Dirt Claude Dojo
# Transforms static markdown lessons into interactive CLI experiences

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOJO_ROOT="$(dirname "$SCRIPT_DIR")"
readonly DOJO_DIR="$DOJO_ROOT/.dojo"
readonly PROGRESS_FILE="$DOJO_DIR/progress.json"
readonly CLAUDE_FILE="$DOJO_DIR/claude-integration.json"
readonly LESSONS_DIR="$DOJO_ROOT/foundations"

# Colors for better UX
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'
readonly BOLD='\033[1m'

# Lesson state
declare -A LESSON_STATE
LESSON_STATE[current_step]=0
LESSON_STATE[total_steps]=0
LESSON_STATE[lesson_name]=""
LESSON_STATE[topic]=""

log() { echo -e "${GREEN}🥷 $1${NC}"; }
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
highlight() { echo -e "${PURPLE}🎯 $1${NC}"; }
prompt() { echo -e "${CYAN}👉 $1${NC}"; }

show_progress_bar() {
    local current=$1
    local total=$2
    local width=30
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    
    printf "${BLUE}Progress: [${NC}"
    for ((i=0; i<filled; i++)); do printf "${GREEN}█${NC}"; done
    for ((i=filled; i<width; i++)); do printf "${NC}░"; done
    printf "${BLUE}] %d%% (%d/%d)${NC}\n" "$percentage" "$current" "$total"
}

load_lesson_config() {
    local lesson_file="$1"
    
    # Extract lesson metadata from markdown
    LESSON_STATE[lesson_name]=$(grep "^# " "$lesson_file" | head -1 | sed 's/^# //')
    LESSON_STATE[objective]=$(grep -A1 "## Learning Objective" "$lesson_file" 2>/dev/null | tail -1 || echo "Learn essential CLI skills")
    
    # Count practice sections and commands as steps
    local practice_count=$(grep -c "**Practice:**" "$lesson_file" || echo "0")
    local drill_count=$(grep -c "## Muscle Memory Drill" "$lesson_file" || echo "0")
    local criteria_count=$(grep -c "- \[ \]" "$lesson_file" || echo "0")
    
    LESSON_STATE[total_steps]=$((practice_count + drill_count + criteria_count))
    LESSON_STATE[current_step]=0
    
    log "Loaded lesson: ${LESSON_STATE[lesson_name]}"
    info "Objective: ${LESSON_STATE[objective]}"
    show_progress_bar 0 "${LESSON_STATE[total_steps]}"
}

validate_command() {
    local expected="$1"
    local user_input="$2"
    
    # Normalize whitespace
    expected=$(echo "$expected" | tr -s ' ')
    user_input=$(echo "$user_input" | tr -s ' ')
    
    if [[ "$user_input" == "$expected" ]]; then
        return 0
    else
        return 1
    fi
}

wait_for_command() {
    local expected_cmd="$1"
    local description="$2"
    local hint="${3:-}"
    local attempts=0
    local max_attempts=3
    
    while [[ $attempts -lt $max_attempts ]]; do
        prompt "Type this command: ${BOLD}$expected_cmd${NC}"
        if [[ -n "$description" ]]; then
            echo -e "${CYAN}   Purpose: $description${NC}"
        fi
        
        read -p "$ " user_input
        
        if validate_command "$expected_cmd" "$user_input"; then
            success "Perfect! Command executed correctly."
            
            # Actually execute the command if it's safe
            if [[ "$expected_cmd" =~ ^(pwd|ls|cat|head|tail|wc|grep|echo) ]]; then
                echo -e "${BLUE}Output:${NC}"
                eval "$expected_cmd" 2>/dev/null || echo "(Command would execute here)"
            fi
            
            LESSON_STATE[current_step]=$((LESSON_STATE[current_step] + 1))
            show_progress_bar "${LESSON_STATE[current_step]}" "${LESSON_STATE[total_steps]}"
            return 0
        else
            attempts=$((attempts + 1))
            error "Not quite right. Expected: $expected_cmd"
            error "You typed: $user_input"
            
            if [[ $attempts -eq 2 && -n "$hint" ]]; then
                warn "Hint: $hint"
            elif [[ $attempts -eq $max_attempts ]]; then
                error "Too many attempts. Moving on..."
                return 1
            fi
        fi
    done
}

interactive_practice_section() {
    local command="$1"
    local description="$2"
    local hint="${3:-}"
    
    highlight "Practice Time!"
    wait_for_command "$command" "$description" "$hint"
    echo
}

show_concept_explanation() {
    local concept="$1"
    local explanation="$2"
    
    echo -e "${PURPLE}📚 Concept: ${BOLD}$concept${NC}"
    echo -e "${BLUE}$explanation${NC}"
    echo
    read -p "Press Enter when you understand this concept..."
    echo
}

run_muscle_memory_drill() {
    local drill_commands=("$@")
    
    highlight "🏋️ Muscle Memory Drill Time!"
    warn "Type each command in sequence. Build that muscle memory!"
    echo
    
    for cmd in "${drill_commands[@]}"; do
        wait_for_command "$cmd" "Part of muscle memory sequence"
        sleep 0.5
    done
    
    success "Excellent! You completed the muscle memory drill!"
    echo
}

check_success_criteria() {
    local criteria=("$@")
    
    highlight "🎯 Success Criteria Check"
    info "Let's verify you've mastered these skills:"
    echo
    
    local mastered=0
    for criterion in "${criteria[@]}"; do
        echo -e "${CYAN}Can you: $criterion${NC}"
        read -p "Rate yourself (1-5, where 5=mastered): " rating
        
        if [[ "$rating" -ge 4 ]]; then
            success "Great! You've got this skill down."
            mastered=$((mastered + 1))
        elif [[ "$rating" -ge 2 ]]; then
            warn "You're getting there. Consider more practice."
        else
            error "This needs more work. Don't worry, practice makes perfect!"
        fi
    done
    
    local total=${#criteria[@]}
    local percentage=$((mastered * 100 / total))
    
    echo
    if [[ $percentage -ge 80 ]]; then
        success "Outstanding! You've mastered this lesson ($percentage% proficiency)"
        return 0
    elif [[ $percentage -ge 60 ]]; then
        warn "Good progress, but consider reviewing weak areas ($percentage% proficiency)"
        return 1
    else
        error "This lesson needs more practice ($percentage% proficiency)"
        return 2
    fi
}

update_progress() {
    local lesson_name="$1"
    local mastery_score="$2"
    
    # Update progress.json with lesson completion
    if [[ -f "$PROGRESS_FILE" ]]; then
        local temp_file=$(mktemp)
        jq --arg lesson "$lesson_name" --argjson score "$mastery_score" '
            .foundations.cli_basics.lessons_completed += 1 |
            .foundations.cli_basics.mastery_score = ((.foundations.cli_basics.mastery_score + $score) / 2) |
            .last_session = now
        ' "$PROGRESS_FILE" > "$temp_file" && mv "$temp_file" "$PROGRESS_FILE"
    fi
}

run_interactive_lesson() {
    local lesson_file="$1"
    
    if [[ ! -f "$lesson_file" ]]; then
        error "Lesson file not found: $lesson_file"
        return 1
    fi
    
    load_lesson_config "$lesson_file"
    
    echo -e "${BOLD}${PURPLE}================================${NC}"
    echo -e "${BOLD}${PURPLE}  ${LESSON_STATE[lesson_name]}${NC}"
    echo -e "${BOLD}${PURPLE}================================${NC}"
    echo
    
    # This is a demo of how the interactive engine would work
    # In a full implementation, we'd parse the markdown and extract practice sections
    
    case "$lesson_file" in
        *"lesson-01-orientation"*)
            run_lesson_01_interactive
            ;;
        *"lesson-02-file-operations"*)
            run_lesson_02_interactive
            ;;
        *"lesson-03-text-viewing"*)
            run_lesson_03_interactive
            ;;
        *)
            warn "Interactive version not yet available for this lesson"
            info "Falling back to markdown display"
            cat "$lesson_file"
            ;;
    esac
}

run_lesson_01_interactive() {
    show_concept_explanation "pwd - Print Working Directory" "Your location in the filesystem. Like a GPS for the terminal."
    interactive_practice_section "pwd" "See where you are right now"
    
    show_concept_explanation "ls - List Directory Contents" "See what's around you. Your eyes in the filesystem."
    interactive_practice_section "ls" "List files in current directory"
    interactive_practice_section "ls -l" "List files with detailed information"
    interactive_practice_section "ls -la" "List all files including hidden ones"
    
    show_concept_explanation "cd - Change Directory" "Move around the filesystem. Your legs in the terminal."
    interactive_practice_section "cd ~" "Go to your home directory"
    interactive_practice_section "pwd" "Confirm you're home"
    interactive_practice_section "cd .." "Go up one directory level"
    interactive_practice_section "pwd" "See where you moved to"
    
    run_muscle_memory_drill "pwd" "ls -la" "cd .." "pwd" "cd ~" "pwd"
    
    local criteria=(
        "Navigate to any directory without thinking"
        "Always know where you are with pwd"
        "Quickly scan directory contents with ls"
        "Use cd reflexively to move around"
    )
    
    if check_success_criteria "${criteria[@]}"; then
        success "🎉 Lesson 1 completed! You're ready for file operations."
        update_progress "lesson-01-orientation" 85
    else
        warn "Consider practicing more before moving on."
        update_progress "lesson-01-orientation" 60
    fi
}

run_lesson_02_interactive() {
    highlight "🔨 Time to create and manipulate files!"
    
    show_concept_explanation "touch - Create Files" "Create empty files or update timestamps"
    interactive_practice_section "touch practice-file.txt" "Create your first practice file"
    interactive_practice_section "ls -la" "See your new file"
    
    show_concept_explanation "mkdir - Create Directories" "Make new folders for organization"
    interactive_practice_section "mkdir test-folder" "Create a directory"
    interactive_practice_section "mkdir -p deep/nested/structure" "Create nested directories"
    
    show_concept_explanation "cp - Copy Files" "Duplicate files while keeping originals"
    interactive_practice_section "cp practice-file.txt backup.txt" "Make a backup copy"
    
    show_concept_explanation "mv - Move/Rename Files" "Move files or rename them"
    interactive_practice_section "mv backup.txt renamed-backup.txt" "Rename the backup"
    
    warn "⚠️  DANGER ZONE: rm command ahead!"
    show_concept_explanation "rm - Remove Files" "Delete files permanently. No undo!"
    interactive_practice_section "rm renamed-backup.txt" "Remove the backup (it's safe to delete)"
    
    local drill_commands=(
        "mkdir practice"
        "cd practice"
        "touch test.txt"
        "cp test.txt backup.txt"
        "mv test.txt renamed.txt"
        "ls -la"
        "rm backup.txt"
        "cd .."
        "rm -r practice"
    )
    
    run_muscle_memory_drill "${drill_commands[@]}"
    
    local criteria=(
        "Create files and directories confidently"
        "Copy files for backup without thinking"
        "Rename and move files smoothly"
        "Use rm safely with proper caution"
    )
    
    if check_success_criteria "${criteria[@]}"; then
        success "🎉 Lesson 2 mastered! File operations are now in your toolkit."
        update_progress "lesson-02-file-operations" 85
    else
        warn "Practice more with file operations for better mastery."
        update_progress "lesson-02-file-operations" 60
    fi
}

run_lesson_03_interactive() {
    highlight "👀 Time to read and search through files!"
    
    # Create some sample content for practice
    echo "Welcome to the Dojo!" > sample.txt
    echo "Line 2 of sample content" >> sample.txt
    echo "This contains the word PATTERN" >> sample.txt
    echo "Final line of the file" >> sample.txt
    
    show_concept_explanation "cat - Display File Contents" "Show entire file at once"
    interactive_practice_section "cat sample.txt" "View the sample file contents"
    
    show_concept_explanation "head - First Lines" "See the beginning of files"
    interactive_practice_section "head -2 sample.txt" "Show first 2 lines"
    
    show_concept_explanation "tail - Last Lines" "See the end of files"
    interactive_practice_section "tail -2 sample.txt" "Show last 2 lines"
    
    show_concept_explanation "grep - Search Text" "Find patterns in files"
    interactive_practice_section "grep 'PATTERN' sample.txt" "Search for PATTERN in the file"
    
    show_concept_explanation "wc - Word Count" "Get file statistics"
    interactive_practice_section "wc sample.txt" "Count lines, words, and characters"
    interactive_practice_section "wc -l sample.txt" "Count just the lines"
    
    # Clean up
    rm -f sample.txt
    
    local criteria=(
        "Quickly scan file contents with appropriate viewer"
        "Search for specific patterns efficiently"
        "Get file statistics instantly"
        "Chain commands for complex analysis"
    )
    
    if check_success_criteria "${criteria[@]}"; then
        success "🎉 Text mastery achieved! You can read the digital world."
        update_progress "lesson-03-text-viewing" 85
    else
        warn "More practice with text commands recommended."
        update_progress "lesson-03-text-viewing" 60
    fi
}

# Main function to run interactive lesson
main() {
    local lesson_file="${1:-}"
    
    if [[ -z "$lesson_file" ]]; then
        error "Usage: $0 <lesson-file>"
        exit 1
    fi
    
    run_interactive_lesson "$lesson_file"
}

# Only run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi