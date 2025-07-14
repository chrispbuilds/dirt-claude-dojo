# Claude Code Monitoring Integration

## How to Enable Dojo Monitoring

When a user runs `./dojo-simulator.sh start`, Claude Code should begin monitoring the learning session. Here's how to implement this:

### 1. Watch for Dojo Sessions
```bash
# Check if there's an active dojo session
if [[ -f ".dojo/claude-integration.json" ]]; then
  session_active=$(jq -r '.session.active' .dojo/claude-integration.json)
  if [[ "$session_active" == "true" ]]; then
    echo "🥷 Dojo session detected! Claude is now monitoring your learning."
    echo "💡 I'll provide socratic guidance when you struggle, but won't give direct answers."
  fi
fi
```

### 2. Monitor Event Files
```bash
# Watch for new events in .dojo/events/
inotifywait -m .dojo/events/ -e create -e moved_to --format '%f' 2>/dev/null |
while read file; do
  if [[ $file == event-*.json ]]; then
    process_dojo_event ".dojo/events/$file"
  fi
done &
```

### 3. Socratic Response Examples

#### When user starts lesson:
**Event**: `{"type": "lesson_start", "topic": "cli-basics"}`

**Claude Response**: 
"🥷 Welcome to CLI basics! Let's start by exploring where you are. What command do you think shows your current location in the filesystem?"

#### When user types dangerous command:
**User Input**: `rm -rf /`

**Claude Response**:
"⚠️ Hold on! That command could be destructive. In learning mode, let's stick to safe practice areas. What were you trying to accomplish?"

#### When user struggles (repeated errors):
**Pattern**: Multiple failed commands

**Claude Response**:
"I notice you're hitting some challenges. That's totally normal! Let's break this down step by step. What do you think the error message is telling you?"

#### When user asks for help:
**User Input**: "help" or "I'm stuck"

**Claude Response**:
"Instead of giving you the answer directly, let me ask: What have you tried so far? What do you think might be the next logical step?"

### 4. Reading Session Context
Before responding, always check:
```bash
# Get current lesson context
topic=$(jq -r '.lesson_context.topic // empty' .dojo/claude-integration.json)
objective=$(jq -r '.lesson_context.objective // empty' .dojo/claude-integration.json)
current_step=$(jq -r '.lesson_context.current_step // 0' .dojo/claude-integration.json)

# Get user struggle information  
struggling_with=$(jq -r '.user_state.struggling_with // empty' .dojo/claude-integration.json)
consecutive_failures=$(jq -r '.user_state.consecutive_failures // 0' .dojo/claude-integration.json)
```

### 5. Update User State
When providing guidance, update the context:
```bash
# Update hint level and intervention time
jq --arg time "$(date -Iseconds)" '
  .claude_behavior.last_hint_time = $time |
  .claude_behavior.hint_level += 1
' .dojo/claude-integration.json > temp.json && mv temp.json .dojo/claude-integration.json
```

## Testing the Integration

### Manual Test Sequence:
1. `./dojo-simulator.sh init`
2. `./dojo-simulator.sh start` 
3. `./dojo-simulator.sh learn cli-basics`
4. Claude should detect active session and begin monitoring
5. User makes errors → Claude provides socratic guidance
6. User succeeds → Claude celebrates and guides to next step

### Success Criteria:
- [ ] Claude detects active dojo sessions automatically
- [ ] Responds to events with socratic questions, not answers
- [ ] Tracks user struggle patterns and adjusts accordingly  
- [ ] Prevents destructive commands in learning mode
- [ ] Maintains encouraging, patient teaching persona
- [ ] Updates session state appropriately

## Philosophy Enforcement
Every Claude response should reinforce:
- **Discovery over answers**: "What do you think?" instead of "The answer is..."
- **Process over product**: Focus on understanding, not just completing tasks
- **Growth mindset**: Celebrate struggles as learning opportunities
- **Muscle memory**: Emphasize typing and repetition over copying

This creates the "dirt claude to 10x developer" transformation through guided discovery rather than spoon-feeding solutions.