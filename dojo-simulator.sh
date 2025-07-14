#!/bin/bash
# Dirt Claude Dojo Simulator
# Simulates the Go CLI tool functionality for testing without Go installation

set -euo pipefail

readonly DOJO_DIR=".dojo"
readonly EVENTS_DIR=".dojo/events"
readonly PROGRESS_FILE=".dojo/progress.json"
readonly CLAUDE_FILE=".dojo/claude-integration.json"

log() { echo "🥷 $1"; }
info() { echo "ℹ️  $1"; }
warn() { echo "⚠️  $1"; }
success() { echo "✅ $1"; }

show_banner() {
    cat << 'BANNER'
╔═══════════════════════════════════════╗
║        Dirt Claude Dojo 🥷            ║
║   From dirt clod poor to 10x dev     ║
╚═══════════════════════════════════════╝
BANNER
}

cmd_init() {
    log "Initializing Dirt Claude Dojo..."
    
    # Create directory structure
    mkdir -p "$DOJO_DIR/events" foundations practice summaries
    
    # Check if already initialized
    if [[ -f "$PROGRESS_FILE" ]]; then
        info "Dojo already initialized! Use './dojo-simulator.sh start' to begin training."
        return
    fi
    
    # Get user info
    read -p "Enter your name (or nickname): " name
    
    # Create progress file
    cat > "$PROGRESS_FILE" << EOF
{
  "user": {
    "name": "$name",
    "start_date": "$(date +%Y-%m-%d)",
    "current_level": "dirt_clod",
    "total_sessions": 0,
    "streak_days": 0
  },
  "foundations": {
    "cli_basics": {
      "status": "available",
      "lessons_completed": 0,
      "total_lessons": 12,
      "mastery_score": 0
    },
    "version_control": {
      "status": "locked",
      "lessons_completed": 0,
      "total_lessons": 8,
      "mastery_score": 0
    },
    "scripting": {
      "status": "locked",
      "lessons_completed": 0,
      "total_lessons": 15,
      "mastery_score": 0
    }
  },
  "achievements": [],
  "last_session": null
}
EOF
    
    success "Welcome to the dojo, $name!"
    info "📚 Your CLI mastery journey begins now."
    warn "💪 Remember: No copy-paste, only deliberate practice."
    echo
    info "🚀 Ready to start? Run: ./dojo-simulator.sh learn cli-basics"
}

cmd_start() {
    if [[ ! -f "$PROGRESS_FILE" ]]; then
        warn "Dojo not initialized. Run './dojo-simulator.sh init' first."
        return 1
    fi
    
    # Read user name from progress file
    local name=$(jq -r '.user.name' "$PROGRESS_FILE")
    local level=$(jq -r '.user.current_level' "$PROGRESS_FILE")
    local sessions=$(jq -r '.user.total_sessions' "$PROGRESS_FILE")
    
    # Update session count
    jq '.user.total_sessions += 1' "$PROGRESS_FILE" > temp.json && mv temp.json "$PROGRESS_FILE"
    
    # Create Claude integration state
    cat > "$CLAUDE_FILE" << EOF
{
  "session": {
    "active": true,
    "start_time": "$(date -Iseconds)",
    "current_lesson": null,
    "current_topic": null,
    "learning_mode": "practice"
  },
  "user_state": {
    "struggling_with": null,
    "consecutive_failures": 0,
    "needs_encouragement": false
  },
  "claude_behavior": {
    "teaching_style": "socratic",
    "intervention_threshold": 3,
    "hint_level": 1
  },
  "lesson_context": {
    "topic": null,
    "objective": null,
    "current_step": 0,
    "total_steps": 0,
    "key_concepts": []
  }
}
EOF
    
    # Log session start event
    log_event "session_start" "$name" "User started training session"
    
    success "Training session started for $name"
    info "📊 Current level: $level"
    info "🔄 Session #$((sessions + 1))"
    info "👁️  Claude Code monitoring enabled"
    echo
    warn "💡 Claude will provide guidance when you struggle, but won't give direct answers."
    info "🎯 Use './dojo-simulator.sh learn <topic>' to begin a lesson."
}

cmd_learn() {
    local topic="$1"
    
    if [[ ! -f "$PROGRESS_FILE" ]]; then
        warn "Dojo not initialized. Run './dojo-simulator.sh init' first."
        return 1
    fi
    
    case "$topic" in
        "cli-basics")
            local name=$(jq -r '.user.name' "$PROGRESS_FILE")
            
            # Update Claude integration
            jq --arg topic "$topic" '
                .session.current_topic = $topic |
                .lesson_context.topic = $topic |
                .lesson_context.objective = "Master terminal navigation, file operations, and basic commands" |
                .lesson_context.total_steps = 12 |
                .lesson_context.key_concepts = ["pwd", "ls", "cd", "mkdir", "touch", "cp", "mv", "rm"]
            ' "$CLAUDE_FILE" > temp.json && mv temp.json "$CLAUDE_FILE"
            
            # Log lesson start
            log_event "lesson_start" "$name" "Started lesson: $topic"
            
            info "📚 Starting lesson: $topic"
            info "🎯 Objective: Master terminal navigation, file operations, and basic commands"
            info "📊 Progress: 0/12 lessons completed"
            echo
            success "🥷 Begin your practice. Claude is watching and ready to guide you."
            warn "💡 Remember: Type everything manually. No copy-paste!"
            echo
            info "📖 First lesson available at: foundations/cli-basics/lesson-01-orientation.md"
            info "👀 Try: cat foundations/cli-basics/lesson-01-orientation.md"
            ;;
        *)
            warn "Topic '$topic' not found or locked."
            info "Available topics: cli-basics"
            ;;
    esac
}

log_event() {
    local event_type="$1"
    local user="$2" 
    local message="$3"
    
    local timestamp=$(date -Iseconds)
    local filename="$EVENTS_DIR/event-$(date +%Y%m%d-%H%M%S).json"
    
    cat > "$filename" << EOF
{
  "timestamp": "$timestamp",
  "type": "$event_type",
  "user": "$user",
  "message": "$message"
}
EOF
}

show_help() {
    show_banner
    echo
    echo "COMMANDS:"
    echo "  init                    Initialize your dojo training environment"
    echo "  start                   Begin daily session with Claude monitoring"
    echo "  learn <topic>          Start learning a specific topic"
    echo "  help                   Show this help message"
    echo
    echo "EXAMPLES:"
    echo "  ./dojo-simulator.sh init"
    echo "  ./dojo-simulator.sh start" 
    echo "  ./dojo-simulator.sh learn cli-basics"
    echo
    echo "PHILOSOPHY:"
    echo "  From dirt clod poor to 10x developer through:"
    echo "  • NO_COPY_PASTE: Build muscle memory by typing"
    echo "  • SOCRATIC_METHOD: Claude guides, never provides answers"
    echo "  • PROGRESSIVE_DISCLOSURE: Earn advanced features"
    echo "  • LEARNING_BY_BUILDING: Curriculum grows with you"
}

main() {
    case "${1:-help}" in
        "init")
            cmd_init
            ;;
        "start")
            cmd_start
            ;;
        "learn")
            if [[ $# -lt 2 ]]; then
                warn "Usage: $0 learn <topic>"
                info "Available topics: cli-basics"
                exit 1
            fi
            cmd_learn "$2"
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            warn "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"