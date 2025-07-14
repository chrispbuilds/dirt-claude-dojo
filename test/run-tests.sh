#!/bin/bash
# Dirt Claude Dojo - Automated Test Runner
# Executes comprehensive testing protocol

set -euo pipefail

readonly TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(dirname "$TEST_DIR")"
readonly TEMP_TEST_DIR="/tmp/dojo-test-$(date +%s)"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

log() { echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} $1"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
failure() { echo -e "${RED}❌ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

# Test result tracking
pass_test() {
    local test_name="$1"
    ((TESTS_PASSED++))
    ((TESTS_RUN++))
    success "PASS: $test_name"
}

fail_test() {
    local test_name="$1"
    local error="${2:-Unknown error}"
    ((TESTS_FAILED++))
    ((TESTS_RUN++))
    failure "FAIL: $test_name - $error"
}

# Setup clean test environment
setup_test_env() {
    log "Setting up test environment in $TEMP_TEST_DIR"
    mkdir -p "$TEMP_TEST_DIR"
    cp -r "$PROJECT_DIR"/* "$TEMP_TEST_DIR"/
    cd "$TEMP_TEST_DIR"
}

# Cleanup test environment
cleanup_test_env() {
    log "Cleaning up test environment"
    cd /
    rm -rf "$TEMP_TEST_DIR"
}

# ===============================
# FUNCTIONAL TESTS
# ===============================

test_dojo_init() {
    log "Testing: dojo init"
    
    # Clean slate
    rm -rf .dojo/
    
    # Test init with automated input
    echo "TestUser" | ./dojo-simulator.sh init > /dev/null 2>&1
    
    # Verify directory structure
    if [[ ! -d ".dojo" ]]; then
        fail_test "dojo init" "Failed to create .dojo directory"
        return
    fi
    
    if [[ ! -d ".dojo/events" ]]; then
        fail_test "dojo init" "Failed to create events directory"
        return
    fi
    
    # Verify JSON files
    if ! jq empty .dojo/progress.json 2>/dev/null; then
        fail_test "dojo init" "Invalid progress.json"
        return
    fi
    
    # Verify user data
    local user_name=$(jq -r '.user.name' .dojo/progress.json)
    if [[ "$user_name" != "TestUser" ]]; then
        fail_test "dojo init" "User name not stored correctly: $user_name"
        return
    fi
    
    # Verify initial state
    local level=$(jq -r '.user.current_level' .dojo/progress.json)
    if [[ "$level" != "dirt_claude" ]]; then
        fail_test "dojo init" "Initial level incorrect: $level"
        return
    fi
    
    pass_test "dojo init"
}

test_dojo_start() {
    log "Testing: dojo start"
    
    # Prerequisites
    if [[ ! -f ".dojo/progress.json" ]]; then
        echo "TestUser" | ./dojo-simulator.sh init > /dev/null 2>&1
    fi
    
    # Test start
    ./dojo-simulator.sh start > /dev/null 2>&1
    
    # Verify session increment
    local sessions=$(jq -r '.user.total_sessions' .dojo/progress.json)
    if [[ "$sessions" != "1" ]]; then
        fail_test "dojo start" "Session count incorrect: $sessions"
        return
    fi
    
    # Verify Claude integration
    if ! jq empty .dojo/claude-integration.json 2>/dev/null; then
        fail_test "dojo start" "Claude integration file invalid"
        return
    fi
    
    local active=$(jq -r '.session.active' .dojo/claude-integration.json)
    if [[ "$active" != "true" ]]; then
        fail_test "dojo start" "Session not marked active: $active"
        return
    fi
    
    # Verify event file created
    local event_count=$(ls .dojo/events/event-*.json 2>/dev/null | wc -l)
    if [[ "$event_count" -lt 1 ]]; then
        fail_test "dojo start" "No event files created"
        return
    fi
    
    pass_test "dojo start"
}

test_dojo_learn() {
    log "Testing: dojo learn cli-basics"
    
    # Prerequisites
    if [[ ! -f ".dojo/claude-integration.json" ]]; then
        echo "TestUser" | ./dojo-simulator.sh init > /dev/null 2>&1
        ./dojo-simulator.sh start > /dev/null 2>&1
    fi
    
    # Test learn command
    ./dojo-simulator.sh learn cli-basics > /dev/null 2>&1
    
    # Verify lesson context
    local topic=$(jq -r '.lesson_context.topic' .dojo/claude-integration.json)
    if [[ "$topic" != "cli-basics" ]]; then
        fail_test "dojo learn" "Topic not set correctly: $topic"
        return
    fi
    
    # Verify key concepts loaded
    local concepts_count=$(jq '.lesson_context.key_concepts | length' .dojo/claude-integration.json)
    if [[ "$concepts_count" -lt 5 ]]; then
        fail_test "dojo learn" "Key concepts not loaded: $concepts_count"
        return
    fi
    
    # Verify lesson file exists
    if [[ ! -f "foundations/cli-basics/lesson-01-orientation.md" ]]; then
        fail_test "dojo learn" "Lesson file not found"
        return
    fi
    
    pass_test "dojo learn cli-basics"
}

test_invalid_commands() {
    log "Testing: Invalid command handling"
    
    # Test invalid main command
    if ./dojo-simulator.sh invalid-command >/dev/null 2>&1; then
        fail_test "invalid commands" "Invalid command should fail"
        return
    fi
    
    # Test invalid topic
    if ./dojo-simulator.sh learn nonexistent-topic >/dev/null 2>&1; then
        fail_test "invalid commands" "Invalid topic should fail"
        return
    fi
    
    # Test start without init
    rm -rf .dojo/
    if ./dojo-simulator.sh start >/dev/null 2>&1; then
        fail_test "invalid commands" "Start without init should fail"
        return
    fi
    
    pass_test "invalid command handling"
}

# ===============================
# SECURITY TESTS
# ===============================

test_input_validation() {
    log "Testing: Input validation security"
    
    # Clean environment
    rm -rf .dojo/
    
    # Test command injection attempts
    echo "'; rm -rf /tmp/test-target; echo 'injected" | ./dojo-simulator.sh init >/dev/null 2>&1
    
    # Verify user name was sanitized
    if [[ -f ".dojo/progress.json" ]]; then
        local user_name=$(jq -r '.user.name' .dojo/progress.json)
        if [[ "$user_name" == *"rm -rf"* ]]; then
            fail_test "input validation" "Command injection not prevented"
            return
        fi
    fi
    
    # Test path traversal
    echo "../../../etc/passwd" | ./dojo-simulator.sh init >/dev/null 2>&1
    
    # Verify operations stayed within bounds
    if [[ ! -d ".dojo" ]]; then
        fail_test "input validation" "Path traversal may have prevented normal operation"
        return
    fi
    
    pass_test "input validation security"
}

test_file_permissions() {
    log "Testing: File permissions security"
    
    # Ensure dojo initialized
    if [[ ! -f ".dojo/progress.json" ]]; then
        echo "TestUser" | ./dojo-simulator.sh init > /dev/null 2>&1
    fi
    
    # Check file permissions
    local progress_perms=$(stat -c %a .dojo/progress.json 2>/dev/null || stat -f %A .dojo/progress.json 2>/dev/null)
    if [[ "$progress_perms" == "644" ]] || [[ "$progress_perms" == "664" ]]; then
        pass_test "file permissions security"
    else
        fail_test "file permissions security" "Incorrect permissions: $progress_perms"
    fi
}

# ===============================
# JSON VALIDATION TESTS
# ===============================

test_json_integrity() {
    log "Testing: JSON data integrity"
    
    # Run full workflow
    rm -rf .dojo/
    echo "TestUser" | ./dojo-simulator.sh init > /dev/null 2>&1
    ./dojo-simulator.sh start > /dev/null 2>&1
    ./dojo-simulator.sh learn cli-basics > /dev/null 2>&1
    
    # Validate all JSON files
    local json_valid=true
    
    for file in .dojo/*.json .dojo/events/*.json; do
        if [[ -f "$file" ]]; then
            if ! jq empty "$file" 2>/dev/null; then
                json_valid=false
                fail_test "JSON integrity" "Invalid JSON in $file"
                return
            fi
        fi
    done
    
    if [[ "$json_valid" == "true" ]]; then
        pass_test "JSON data integrity"
    fi
}

# ===============================
# LESSON CONTENT TESTS
# ===============================

test_lesson_content() {
    log "Testing: Lesson content quality"
    
    local lesson_files=(
        "foundations/cli-basics/lesson-01-orientation.md"
        "foundations/cli-basics/lesson-02-file-operations.md"
        "foundations/cli-basics/lesson-03-text-viewing.md"
    )
    
    for lesson in "${lesson_files[@]}"; do
        if [[ ! -f "$lesson" ]]; then
            fail_test "lesson content" "Missing lesson file: $lesson"
            return
        fi
        
        # Check for required sections
        if ! grep -q "Learning Objective" "$lesson"; then
            fail_test "lesson content" "Missing learning objective in $lesson"
            return
        fi
        
        if ! grep -q "Practice:" "$lesson"; then
            fail_test "lesson content" "Missing practice exercises in $lesson"
            return
        fi
    done
    
    pass_test "lesson content quality"
}

# ===============================
# MAIN EXECUTION
# ===============================

show_banner() {
    cat << 'BANNER'
╔═══════════════════════════════════════╗
║     Dirt Claude Dojo Test Suite       ║
║         Comprehensive Testing         ║
╚═══════════════════════════════════════╝
BANNER
}

run_all_tests() {
    log "Starting comprehensive test suite..."
    
    # Functional tests
    test_dojo_init
    test_dojo_start
    test_dojo_learn
    test_invalid_commands
    
    # Security tests
    test_input_validation
    test_file_permissions
    
    # Data integrity tests
    test_json_integrity
    
    # Content tests
    test_lesson_content
}

show_results() {
    echo
    log "Test Results Summary:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Total Tests Run: $TESTS_RUN"
    success "Tests Passed: $TESTS_PASSED"
    if [[ $TESTS_FAILED -gt 0 ]]; then
        failure "Tests Failed: $TESTS_FAILED"
    else
        success "Tests Failed: $TESTS_FAILED"
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        success "🎉 All tests passed! Dirt Claude Dojo is ready for release."
        return 0
    else
        failure "❌ Some tests failed. Please review and fix issues before release."
        return 1
    fi
}

# Script execution
main() {
    show_banner
    
    # Setup
    setup_test_env
    trap cleanup_test_env EXIT
    
    # Run tests
    run_all_tests
    
    # Show results
    show_results
}

# Check if running directly or being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi