# Dirt Claude Dojo - Comprehensive Testing Protocol

## 📋 Testing Overview

This protocol ensures Dirt Claude Dojo functions correctly, securely, and provides an excellent learning experience. All tests should be executed before releases and after significant changes.

## 🧪 Test Categories

### 1. **Functional Testing** ⚙️
### 2. **Integration Testing** 🔗  
### 3. **Security Testing** 🛡️
### 4. **User Experience Testing** 👤
### 5. **Performance & Edge Cases** ⚡
### 6. **Automated Testing** 🤖

---

## ⚙️ **1. FUNCTIONAL TESTING**

### **1.1 CLI Command Testing**

#### **Test Environment Setup**
```bash
# Create clean test environment
mkdir -p /tmp/dojo-test
cd /tmp/dojo-test
git clone https://github.com/chrispbuilds/dirt-claude-dojo.git
cd dirt-claude-dojo
```

#### **Test Case 1.1.1: dojo init**
**Objective**: Verify initialization creates proper structure and files

**Steps**:
1. Run `./dojo-simulator.sh init`
2. Enter test name when prompted
3. Verify directory structure created
4. Check JSON files are properly formatted

**Expected Results**:
```bash
# Directory structure exists
ls -la .dojo/
# Should show: events/, progress.json, claude-integration.json

# Progress file contains user data
jq '.user.name' .dojo/progress.json
# Should return: "TestUser"

# Initial state is correct
jq '.user.current_level' .dojo/progress.json  
# Should return: "dirt_claude"

jq '.foundations.cli_basics.status' .dojo/progress.json
# Should return: "available"
```

**Pass Criteria**: ✅ All directories created, JSON files valid, user data stored correctly

#### **Test Case 1.1.2: dojo start**
**Objective**: Verify session management and state tracking

**Prerequisites**: dojo init completed

**Steps**:
1. Run `./dojo-simulator.sh start`
2. Verify session counter increments
3. Check Claude integration file updates
4. Verify event file creation

**Expected Results**:
```bash
# Session count incremented
jq '.user.total_sessions' .dojo/progress.json
# Should return: 1

# Claude integration active
jq '.session.active' .dojo/claude-integration.json
# Should return: true

# Event file created
ls .dojo/events/event-*.json | wc -l
# Should return: 1 (or more)
```

**Pass Criteria**: ✅ Session tracking works, files updated correctly

#### **Test Case 1.1.3: dojo learn cli-basics**
**Objective**: Verify lesson loading and context management

**Prerequisites**: dojo init and start completed

**Steps**:
1. Run `./dojo-simulator.sh learn cli-basics`
2. Verify lesson context updates
3. Check key concepts loaded
4. Verify lesson files accessible

**Expected Results**:
```bash
# Lesson context set
jq '.lesson_context.topic' .dojo/claude-integration.json
# Should return: "cli-basics"

# Key concepts loaded
jq '.lesson_context.key_concepts | length' .dojo/claude-integration.json
# Should return: 8

# Lesson file exists
test -f foundations/cli-basics/lesson-01-orientation.md && echo "PASS" || echo "FAIL"
```

**Pass Criteria**: ✅ Lesson loads correctly, context preserved

#### **Test Case 1.1.4: Invalid Commands**
**Objective**: Verify error handling for invalid input

**Steps**:
1. `./dojo-simulator.sh invalid-command`
2. `./dojo-simulator.sh learn nonexistent-topic`
3. `./dojo-simulator.sh start` (without init)

**Expected Results**:
- Error messages displayed
- No crashes or undefined behavior
- Helpful guidance provided

**Pass Criteria**: ✅ Graceful error handling, informative messages

### **1.2 File System Operations**

#### **Test Case 1.2.1: File Creation and Permissions**
**Objective**: Verify files created with correct permissions

**Steps**:
```bash
./dojo-simulator.sh init
# Check file permissions
ls -la .dojo/progress.json
ls -la .dojo/claude-integration.json
ls -la .dojo/events/
```

**Expected Results**:
- JSON files: `-rw-rw-r--` (644)
- Directories: `drwxrwxr-x` (755)
- Events directory writable by user

**Pass Criteria**: ✅ Correct permissions, security best practices

#### **Test Case 1.2.2: JSON Data Integrity**
**Objective**: Verify JSON files remain valid after operations

**Steps**:
```bash
./dojo-simulator.sh init
./dojo-simulator.sh start
./dojo-simulator.sh learn cli-basics

# Validate all JSON files
for file in .dojo/*.json .dojo/events/*.json; do
  echo "Validating $file"
  jq empty "$file" && echo "✅ Valid" || echo "❌ Invalid"
done
```

**Pass Criteria**: ✅ All JSON files remain valid throughout operations

---

## 🔗 **2. INTEGRATION TESTING**

### **2.1 Claude Code Integration**

#### **Test Case 2.1.1: Event Generation**
**Objective**: Verify events are properly generated for Claude monitoring

**Steps**:
1. Complete dojo init and start
2. Run `./dojo-simulator.sh learn cli-basics`
3. Check event files format and content

**Expected Results**:
```bash
# Check latest event file
latest_event=$(ls -t .dojo/events/event-*.json | head -1)
jq '.type' "$latest_event"
# Should return: "lesson_start"

jq '.user' "$latest_event"  
# Should return: user name

jq '.timestamp' "$latest_event"
# Should return: valid ISO timestamp
```

**Pass Criteria**: ✅ Events generated correctly, proper format

#### **Test Case 2.1.2: Session State Management**
**Objective**: Verify Claude integration context is maintained

**Steps**:
```bash
# Start session
./dojo-simulator.sh start

# Check initial state
jq '.claude_behavior.teaching_style' .dojo/claude-integration.json
# Should return: "socratic"

# Start lesson
./dojo-simulator.sh learn cli-basics

# Check updated context
jq '.lesson_context.objective' .dojo/claude-integration.json
# Should contain: "Master terminal navigation..."
```

**Pass Criteria**: ✅ Context properly maintained across operations

### **2.2 Cross-Session Persistence**

#### **Test Case 2.2.1: State Preservation**
**Objective**: Verify state persists across dojo sessions

**Steps**:
```bash
# Session 1
./dojo-simulator.sh init
name1=$(jq -r '.user.name' .dojo/progress.json)

./dojo-simulator.sh start
sessions1=$(jq -r '.user.total_sessions' .dojo/progress.json)

# Session 2 (simulate restart)
./dojo-simulator.sh start
sessions2=$(jq -r '.user.total_sessions' .dojo/progress.json)

# Verify persistence
echo "Name preserved: $name1"
echo "Sessions: $sessions1 -> $sessions2"
```

**Pass Criteria**: ✅ User data persists, sessions increment correctly

---

## 🛡️ **3. SECURITY TESTING**

### **3.1 Input Validation**

#### **Test Case 3.1.1: Malicious Input Handling**
**Objective**: Verify system handles malicious input safely

**Steps**:
```bash
# Test command injection attempts
echo "'; rm -rf /; echo 'hacked" | ./dojo-simulator.sh init
echo "../../../etc/passwd" | ./dojo-simulator.sh init  
echo '<script>alert("xss")</script>' | ./dojo-simulator.sh init

# Verify no damage done
ls -la .dojo/
test -f /etc/passwd && echo "System safe"
```

**Pass Criteria**: ✅ No command execution, files created safely

#### **Test Case 3.1.2: Path Traversal Prevention**
**Objective**: Verify no directory traversal vulnerabilities

**Steps**:
```bash
# Attempt to escape dojo directory
./dojo-simulator.sh learn "../../../etc"
./dojo-simulator.sh learn "../../.ssh/id_rsa"

# Verify operations stayed within bounds
ls -la ../
# Should not show unexpected file modifications
```

**Pass Criteria**: ✅ Operations confined to dojo directory

### **3.2 File Security**

#### **Test Case 3.2.1: Sensitive Data Exposure**
**Objective**: Verify no sensitive data in files or logs

**Steps**:
```bash
# Search for potential secrets
grep -r -i "password\|secret\|key\|token" .dojo/ || echo "No secrets found"

# Check file permissions
find .dojo -type f -exec ls -la {} \; | grep -v "^-rw-"
# Should return empty (no overly permissive files)
```

**Pass Criteria**: ✅ No sensitive data, appropriate permissions

---

## 👤 **4. USER EXPERIENCE TESTING**

### **4.1 First-Time User Experience**

#### **Test Case 4.1.1: Complete New User Flow**
**Objective**: Verify smooth onboarding for new users

**Steps**:
1. Fresh environment: `rm -rf .dojo/`
2. Follow README instructions exactly
3. Complete first lesson workflow
4. Document any confusion points

**Expected User Journey**:
```bash
git clone <repo>
cd dirt-claude-dojo
./dojo-simulator.sh init
# [User enters name]
# ✅ Welcome message clear and encouraging

./dojo-simulator.sh start  
# ✅ Instructions clear about next steps

./dojo-simulator.sh learn cli-basics
# ✅ First lesson loads, guidance provided

cat foundations/cli-basics/lesson-01-orientation.md
# ✅ Lesson content clear and actionable
```

**Pass Criteria**: ✅ Intuitive flow, clear instructions, no confusion

#### **Test Case 4.1.2: Error Recovery**
**Objective**: Verify users can recover from mistakes

**Steps**:
```bash
# Simulate user mistakes
./dojo-simulator.sh start  # (before init)
./dojo-simulator.sh learn python  # (invalid topic)
./dojo-simulator.sh halp  # (typo)

# Verify helpful error messages
```

**Pass Criteria**: ✅ Clear error messages, recovery guidance

### **4.2 Learning Experience Validation**

#### **Test Case 4.2.1: Lesson Content Quality**
**Objective**: Verify lesson content is educational and clear

**Manual Review Checklist**:
- [ ] Learning objectives clearly stated
- [ ] Practice exercises are hands-on
- [ ] Safety warnings for dangerous commands
- [ ] Progressive difficulty appropriate
- [ ] No copy-paste opportunities (philosophy adherence)
- [ ] Claude integration notes helpful for teaching

**Pass Criteria**: ✅ All checklist items satisfied

#### **Test Case 4.2.2: Progress Tracking**
**Objective**: Verify users can see their progress

**Steps**:
```bash
./dojo-simulator.sh init
./dojo-simulator.sh start

# Check progress visibility
jq '.user | {name, current_level, total_sessions}' .dojo/progress.json

# Verify meaningful status indicators
jq '.foundations.cli_basics' .dojo/progress.json
```

**Pass Criteria**: ✅ Progress clearly visible and meaningful

---

## ⚡ **5. PERFORMANCE & EDGE CASES**

### **5.1 Performance Testing**

#### **Test Case 5.1.1: Large-Scale Operations**
**Objective**: Verify performance with extensive usage

**Steps**:
```bash
# Simulate heavy usage
for i in {1..100}; do
  ./dojo-simulator.sh start
done

# Check file sizes and performance
ls -lah .dojo/events/
wc -l .dojo/events/event-*.json

# Verify no memory leaks or excessive resource usage
```

**Pass Criteria**: ✅ Reasonable performance, no resource exhaustion

#### **Test Case 5.1.2: Concurrent Usage**
**Objective**: Verify system handles multiple simultaneous operations

**Steps**:
```bash
# Simulate concurrent operations (if applicable)
./dojo-simulator.sh start &
./dojo-simulator.sh learn cli-basics &
wait

# Check for race conditions or data corruption
jq empty .dojo/*.json
```

**Pass Criteria**: ✅ No data corruption, stable operation

### **5.2 Edge Cases**

#### **Test Case 5.2.1: File System Edge Cases**
**Objective**: Test unusual file system conditions

**Steps**:
```bash
# Test with read-only directory
chmod -w .
./dojo-simulator.sh init
chmod +w .

# Test with existing corrupted files
echo "invalid json" > .dojo/progress.json
./dojo-simulator.sh start

# Test with missing directories
rm -rf .dojo/events
./dojo-simulator.sh start
```

**Pass Criteria**: ✅ Graceful handling of edge cases

#### **Test Case 5.2.2: Platform Compatibility**
**Objective**: Verify cross-platform functionality

**Test Environments**:
- Ubuntu/Debian Linux
- macOS 
- Windows with WSL
- Different shell environments (bash, zsh)

**Pass Criteria**: ✅ Works consistently across platforms

---

## 🤖 **6. AUTOMATED TESTING FRAMEWORK**

### **6.1 Automated Test Suite**

<function_calls>
<invoke name="TodoWrite">
<parameter name="todos">[{"id": "1", "content": "Create functional testing protocol for CLI commands", "status": "completed", "priority": "high"}, {"id": "2", "content": "Design integration testing for Claude Code monitoring", "status": "in_progress", "priority": "high"}, {"id": "3", "content": "Develop security testing procedures", "status": "pending", "priority": "medium"}, {"id": "4", "content": "Create user experience testing scenarios", "status": "pending", "priority": "medium"}, {"id": "5", "content": "Design performance and edge case testing", "status": "pending", "priority": "low"}, {"id": "6", "content": "Create automated testing framework", "status": "pending", "priority": "low"}]