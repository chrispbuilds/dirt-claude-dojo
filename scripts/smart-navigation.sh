#!/bin/bash
# Smart Navigation System for Dirt Claude Dojo
# Provides intuitive navigation, tab completion, and lesson discovery

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOJO_ROOT="$(dirname "$SCRIPT_DIR")"
readonly DOJO_DIR="$DOJO_ROOT/.dojo"
readonly PROGRESS_FILE="$DOJO_DIR/progress.json"
readonly LESSONS_DIR="$DOJO_ROOT/foundations"

# Colors
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'
readonly BOLD='\033[1m'

log() { echo -e "${GREEN}🧭 $1${NC}"; }
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
highlight() { echo -e "${PURPLE}🎯 $1${NC}"; }

show_navigation_help() {
    echo -e "${BOLD}${PURPLE}🧭 Dirt Claude Dojo Navigation${NC}"
    echo -e "${PURPLE}════════════════════════════════════${NC}"
    echo
    echo -e "${CYAN}NAVIGATION COMMANDS:${NC}"
    echo -e "  ${BOLD}dojo nav${NC}                    Show available lessons and topics"
    echo -e "  ${BOLD}dojo nav <topic>${NC}            Browse lessons in a specific topic"
    echo -e "  ${BOLD}dojo goto <lesson>${NC}          Jump directly to a lesson"
    echo -e "  ${BOLD}dojo status${NC}                 Show current progress and next steps"
    echo -e "  ${BOLD}dojo search <term>${NC}          Search lessons for specific content"
    echo -e "  ${BOLD}dojo path${NC}                   Show recommended learning path"
    echo
    echo -e "${CYAN}LESSON MANAGEMENT:${NC}"
    echo -e "  ${BOLD}dojo interactive <lesson>${NC}   Start interactive lesson"
    echo -e "  ${BOLD}dojo review <lesson>${NC}        Review lesson in markdown format"
    echo -e "  ${BOLD}dojo practice <topic>${NC}       Quick practice session"
    echo
    echo -e "${CYAN}EXAMPLES:${NC}"
    echo -e "  ${YELLOW}dojo nav cli-basics${NC}         Browse CLI basics lessons"
    echo -e "  ${YELLOW}dojo goto lesson-01${NC}         Jump to orientation lesson"
    echo -e "  ${YELLOW}dojo search 'file operations'${NC} Find lessons about files"
    echo
}

discover_lessons() {
    local topic="${1:-}"
    
    if [[ -z "$topic" ]]; then
        # Show all available topics
        highlight "📚 Available Learning Topics"
        echo
        
        for topic_dir in "$LESSONS_DIR"/*/; do
            if [[ -d "$topic_dir" ]]; then
                local topic_name=$(basename "$topic_dir")
                local lesson_count=$(find "$topic_dir" -name "lesson-*.md" | wc -l)
                local status=$(get_topic_status "$topic_name")
                
                echo -e "${CYAN}📂 ${BOLD}$topic_name${NC} ${status}"
                echo -e "   └─ $lesson_count lessons available"
                
                # Show first few lessons as preview
                find "$topic_dir" -name "lesson-*.md" | sort | head -3 | while read -r lesson; do
                    local lesson_name=$(basename "$lesson" .md)
                    local lesson_title=$(grep "^# " "$lesson" | head -1 | sed 's/^# //' || echo "Unknown")
                    echo -e "      • $lesson_name: $lesson_title"
                done
                
                if [[ $lesson_count -gt 3 ]]; then
                    echo -e "      • ... and $((lesson_count - 3)) more"
                fi
                echo
            fi
        done
        
        echo -e "${BLUE}💡 Use 'dojo nav <topic>' to explore a specific topic${NC}"
        echo -e "${BLUE}💡 Use 'dojo goto <lesson>' to jump to a specific lesson${NC}"
        
    else
        # Show lessons in specific topic
        local topic_dir="$LESSONS_DIR/$topic"
        
        if [[ ! -d "$topic_dir" ]]; then
            error "Topic '$topic' not found"
            info "Available topics:"
            find "$LESSONS_DIR" -maxdepth 1 -type d -exec basename {} \; | grep -v "^foundations$" | sort
            return 1
        fi
        
        highlight "📖 Lessons in '$topic'"
        echo
        
        find "$topic_dir" -name "lesson-*.md" | sort | while read -r lesson; do
            local lesson_name=$(basename "$lesson" .md)
            local lesson_title=$(grep "^# " "$lesson" | head -1 | sed 's/^# //' || echo "Unknown")
            local lesson_status=$(get_lesson_status "$lesson_name")
            
            echo -e "${CYAN}📄 ${BOLD}$lesson_name${NC} $lesson_status"
            echo -e "   $lesson_title"
            
            # Show objective if available
            local objective=$(grep -A1 "## Learning Objective" "$lesson" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//' || echo "")
            if [[ -n "$objective" && "$objective" != "## Learning Objective" ]]; then
                echo -e "   ${BLUE}🎯 $objective${NC}"
            fi
            echo
        done
        
        echo -e "${BLUE}💡 Use 'dojo interactive <lesson-name>' to start an interactive lesson${NC}"
        echo -e "${BLUE}💡 Use 'dojo review <lesson-name>' to read the lesson content${NC}"
    fi
}

get_topic_status() {
    local topic="$1"
    
    if [[ ! -f "$PROGRESS_FILE" ]]; then
        echo "${YELLOW}[Not Started]${NC}"
        return
    fi
    
    local status=$(jq -r ".foundations.\"${topic//-/_}\".status // \"unknown\"" "$PROGRESS_FILE" 2>/dev/null || echo "unknown")
    
    case "$status" in
        "available"|"in_progress")
            echo "${GREEN}[Available]${NC}"
            ;;
        "completed")
            echo "${GREEN}[✓ Completed]${NC}"
            ;;
        "locked")
            echo "${RED}[🔒 Locked]${NC}"
            ;;
        *)
            echo "${YELLOW}[Unknown]${NC}"
            ;;
    esac
}

get_lesson_status() {
    local lesson_name="$1"
    
    # This is a simplified status check - in a full implementation,
    # you'd track individual lesson completion
    if [[ -f "$PROGRESS_FILE" ]]; then
        local completed=$(jq -r '.foundations.cli_basics.lessons_completed // 0' "$PROGRESS_FILE" 2>/dev/null || echo "0")
        local lesson_num=$(echo "$lesson_name" | grep -o '[0-9]\+' | head -1 || echo "99")
        
        if [[ $lesson_num -le $completed ]]; then
            echo "${GREEN}[✓ Completed]${NC}"
        elif [[ $lesson_num -eq $((completed + 1)) ]]; then
            echo "${YELLOW}[📍 Current]${NC}"
        else
            echo "${BLUE}[Available]${NC}"
        fi
    else
        echo "${BLUE}[Available]${NC}"
    fi
}

goto_lesson() {
    local lesson_identifier="$1"
    
    # Find the lesson file
    local lesson_file=""
    
    # Try exact match first
    if [[ -f "$LESSONS_DIR/cli-basics/$lesson_identifier.md" ]]; then
        lesson_file="$LESSONS_DIR/cli-basics/$lesson_identifier.md"
    else
        # Search for partial matches
        lesson_file=$(find "$LESSONS_DIR" -name "*$lesson_identifier*.md" | head -1)
    fi
    
    if [[ -z "$lesson_file" || ! -f "$lesson_file" ]]; then
        error "Lesson '$lesson_identifier' not found"
        info "Available lessons:"
        find "$LESSONS_DIR" -name "lesson-*.md" -exec basename {} .md \; | sort
        return 1
    fi
    
    local lesson_name=$(basename "$lesson_file" .md)
    local lesson_title=$(grep "^# " "$lesson_file" | head -1 | sed 's/^# //' || echo "Unknown")
    
    highlight "🎯 Jumping to: $lesson_name"
    info "Title: $lesson_title"
    echo
    
    # Ask user how they want to proceed
    echo -e "${CYAN}How would you like to experience this lesson?${NC}"
    echo -e "  ${BOLD}1)${NC} Interactive mode (recommended)"
    echo -e "  ${BOLD}2)${NC} Review mode (markdown)"
    echo -e "  ${BOLD}3)${NC} Quick preview"
    echo
    
    read -p "Choose option (1-3): " choice
    
    case "$choice" in
        1)
            if [[ -f "$SCRIPT_DIR/interactive-lesson-engine.sh" ]]; then
                log "Starting interactive lesson..."
                bash "$SCRIPT_DIR/interactive-lesson-engine.sh" "$lesson_file"
            else
                error "Interactive engine not available"
                info "Falling back to review mode"
                cat "$lesson_file"
            fi
            ;;
        2)
            log "Opening lesson in review mode..."
            if command -v less &> /dev/null; then
                less "$lesson_file"
            else
                cat "$lesson_file"
            fi
            ;;
        3)
            log "Quick preview of lesson structure:"
            echo
            grep "^#" "$lesson_file" | head -10
            echo
            info "Use option 1 or 2 for full lesson"
            ;;
        *)
            warn "Invalid choice. Showing quick preview:"
            grep "^#" "$lesson_file" | head -5
            ;;
    esac
}

show_learning_status() {
    if [[ ! -f "$PROGRESS_FILE" ]]; then
        warn "No progress file found. Run 'dojo init' first."
        return 1
    fi
    
    local name=$(jq -r '.user.name' "$PROGRESS_FILE")
    local level=$(jq -r '.user.current_level' "$PROGRESS_FILE")
    local sessions=$(jq -r '.user.total_sessions' "$PROGRESS_FILE")
    local streak=$(jq -r '.user.streak_days' "$PROGRESS_FILE")
    
    highlight "📊 Your Dojo Progress"
    echo -e "${CYAN}Student:${NC} $name"
    echo -e "${CYAN}Level:${NC} $level"
    echo -e "${CYAN}Sessions:${NC} $sessions"
    echo -e "${CYAN}Streak:${NC} $streak days"
    echo
    
    # Show topic progress
    echo -e "${BOLD}📚 Topic Progress:${NC}"
    
    local cli_completed=$(jq -r '.foundations.cli_basics.lessons_completed // 0' "$PROGRESS_FILE")
    local cli_total=$(jq -r '.foundations.cli_basics.total_lessons // 12' "$PROGRESS_FILE")
    local cli_mastery=$(jq -r '.foundations.cli_basics.mastery_score // 0' "$PROGRESS_FILE")
    
    echo -e "${CYAN}CLI Basics:${NC} $cli_completed/$cli_total lessons (${cli_mastery}% mastery)"
    
    # Show progress bar
    local percentage=$((cli_completed * 100 / cli_total))
    local filled=$((cli_completed * 20 / cli_total))
    
    printf "  Progress: ["
    for ((i=0; i<filled; i++)); do printf "${GREEN}█${NC}"; done
    for ((i=filled; i<20; i++)); do printf "░"; done
    printf "] %d%%\n" "$percentage"
    echo
    
    # Show next recommended lesson
    if [[ $cli_completed -lt $cli_total ]]; then
        local next_lesson_num=$((cli_completed + 1))
        local next_lesson_file=$(find "$LESSONS_DIR/cli-basics" -name "lesson-$(printf "%02d" $next_lesson_num)-*.md" | head -1)
        
        if [[ -n "$next_lesson_file" ]]; then
            local next_lesson_name=$(basename "$next_lesson_file" .md)
            local next_lesson_title=$(grep "^# " "$next_lesson_file" | head -1 | sed 's/^# //' || echo "Unknown")
            
            highlight "🎯 Next Recommended Lesson:"
            echo -e "${CYAN}$next_lesson_name: $next_lesson_title${NC}"
            echo -e "${BLUE}💡 Start with: dojo goto $next_lesson_name${NC}"
        fi
    else
        success "🎉 CLI Basics completed! Ready for advanced topics."
    fi
}

search_lessons() {
    local search_term="$1"
    
    highlight "🔍 Searching for: '$search_term'"
    echo
    
    local results_found=false
    
    find "$LESSONS_DIR" -name "*.md" | while read -r lesson_file; do
        if grep -qi "$search_term" "$lesson_file"; then
            results_found=true
            local lesson_name=$(basename "$lesson_file" .md)
            local lesson_title=$(grep "^# " "$lesson_file" | head -1 | sed 's/^# //' || echo "Unknown")
            
            echo -e "${CYAN}📄 $lesson_name${NC}"
            echo -e "   $lesson_title"
            
            # Show matching lines with context
            grep -i -n -A1 -B1 "$search_term" "$lesson_file" | head -6 | while read -r line; do
                if [[ "$line" =~ ^[0-9]+-.*$ ]]; then
                    echo -e "   ${YELLOW}$line${NC}"
                elif [[ "$line" =~ ^[0-9]+:.*$ ]]; then
                    # Highlight the search term in the matching line
                    local highlighted_line=$(echo "$line" | sed "s/${search_term}/${RED}&${NC}/gi")
                    echo -e "   ${GREEN}$highlighted_line${NC}"
                fi
            done
            echo
        fi
    done
    
    if [[ "$results_found" != "true" ]]; then
        warn "No lessons found containing '$search_term'"
        info "Try different search terms or browse available lessons with 'dojo nav'"
    fi
}

show_learning_path() {
    highlight "🛤️  Recommended Learning Path"
    echo
    
    echo -e "${BOLD}Phase 1: Foundation${NC}"
    echo -e "${CYAN}🏗️  CLI Basics${NC} - Master terminal fundamentals"
    echo -e "   • Navigation and orientation"
    echo -e "   • File operations"
    echo -e "   • Text viewing and manipulation"
    echo -e "   • Permissions and ownership"
    echo
    
    echo -e "${BOLD}Phase 2: Power User${NC}"
    echo -e "${CYAN}🔧 Advanced Terminal${NC} - Efficiency and automation"
    echo -e "   • Pipes and redirection"
    echo -e "   • Process management"
    echo -e "   • Environment variables"
    echo
    
    echo -e "${BOLD}Phase 3: Developer${NC}"
    echo -e "${CYAN}📝 Version Control${NC} - Git mastery"
    echo -e "${CYAN}🖥️  Scripting${NC} - Bash automation"
    echo -e "${CYAN}🔌 System Integration${NC} - DevOps basics"
    echo
    
    # Show current position in path
    if [[ -f "$PROGRESS_FILE" ]]; then
        local cli_completed=$(jq -r '.foundations.cli_basics.lessons_completed // 0' "$PROGRESS_FILE")
        local cli_total=$(jq -r '.foundations.cli_basics.total_lessons // 12' "$PROGRESS_FILE")
        
        if [[ $cli_completed -lt $cli_total ]]; then
            highlight "📍 You are currently in: Phase 1 - CLI Basics"
            info "Continue with foundation lessons to unlock advanced content"
        else
            highlight "📍 Ready for: Phase 2 - Power User skills"
            success "Foundation complete! Advanced content unlocked."
        fi
    fi
}

# Tab completion support
generate_completions() {
    local command="$1"
    local current_word="$2"
    
    case "$command" in
        "nav")
            # Complete topic names
            find "$LESSONS_DIR" -maxdepth 1 -type d -exec basename {} \; | grep -v "^foundations$" | sort
            ;;
        "goto"|"interactive"|"review")
            # Complete lesson names
            find "$LESSONS_DIR" -name "lesson-*.md" -exec basename {} .md \; | sort
            ;;
        "search")
            # No completion for search terms
            ;;
        *)
            echo "nav goto status search path interactive review practice"
            ;;
    esac
}

main() {
    local command="${1:-help}"
    
    case "$command" in
        "nav"|"browse")
            discover_lessons "${2:-}"
            ;;
        "goto"|"go")
            if [[ $# -lt 2 ]]; then
                error "Usage: dojo goto <lesson-name>"
                info "Use 'dojo nav' to see available lessons"
                exit 1
            fi
            goto_lesson "$2"
            ;;
        "status"|"progress")
            show_learning_status
            ;;
        "search"|"find")
            if [[ $# -lt 2 ]]; then
                error "Usage: dojo search <search-term>"
                exit 1
            fi
            search_lessons "$2"
            ;;
        "path"|"roadmap")
            show_learning_path
            ;;
        "interactive")
            if [[ $# -lt 2 ]]; then
                error "Usage: dojo interactive <lesson-name>"
                exit 1
            fi
            local lesson_file=$(find "$LESSONS_DIR" -name "*$2*.md" | head -1)
            if [[ -n "$lesson_file" && -f "$SCRIPT_DIR/interactive-lesson-engine.sh" ]]; then
                bash "$SCRIPT_DIR/interactive-lesson-engine.sh" "$lesson_file"
            else
                error "Interactive lesson not found or engine unavailable"
            fi
            ;;
        "review"|"read")
            if [[ $# -lt 2 ]]; then
                error "Usage: dojo review <lesson-name>"
                exit 1
            fi
            local lesson_file=$(find "$LESSONS_DIR" -name "*$2*.md" | head -1)
            if [[ -n "$lesson_file" ]]; then
                if command -v less &> /dev/null; then
                    less "$lesson_file"
                else
                    cat "$lesson_file"
                fi
            else
                error "Lesson not found: $2"
            fi
            ;;
        "completions")
            # Used by bash completion
            generate_completions "$2" "$3"
            ;;
        "help"|"--help"|"-h"|*)
            show_navigation_help
            ;;
    esac
}

# Only run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi