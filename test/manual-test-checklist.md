# Manual Testing Checklist

## Pre-Release Testing Checklist

### ✅ **Quick Smoke Test** (5 minutes)
Run this before any release or major change:

```bash
# 1. Clean environment test
rm -rf .dojo/
./dojo-simulator.sh init
# ✅ Initialization works, prompts for name

./dojo-simulator.sh start  
# ✅ Session starts, shows monitoring message

./dojo-simulator.sh learn cli-basics
# ✅ Lesson loads, shows first lesson path

# 2. Verify files created
ls -la .dojo/
# ✅ Directory structure exists
# ✅ JSON files present and readable

# 3. Test automated suite
./test/run-tests.sh
# ✅ All tests pass
```

### 📋 **Comprehensive Manual Testing** (30 minutes)

#### **1. User Experience Flow**
- [ ] README instructions are clear and complete
- [ ] First-time user can complete setup without confusion
- [ ] Error messages are helpful and actionable
- [ ] Help text is informative
- [ ] Banner and branding appear correctly

#### **2. Core Functionality**
- [ ] `dojo init` creates all required files and directories
- [ ] `dojo start` increments session counter correctly
- [ ] `dojo learn cli-basics` loads lesson context properly
- [ ] JSON files remain valid after all operations
- [ ] Event files are created with correct timestamps

#### **3. Content Quality**
- [ ] Lesson files are present and readable
- [ ] Learning objectives are clear
- [ ] Practice exercises are hands-on
- [ ] Safety warnings are present for dangerous commands
- [ ] No copy-paste opportunities (philosophy adherence)

#### **4. Error Handling**
- [ ] Invalid commands show helpful errors
- [ ] Running commands out of order handled gracefully
- [ ] Corrupted files are detected and handled
- [ ] Missing dependencies are identified

#### **5. Security Verification**
- [ ] No dangerous shell operations in code
- [ ] File permissions are appropriate (644/755)
- [ ] Input validation prevents injection
- [ ] Operations confined to dojo directory

#### **6. Platform Testing**
Test on multiple environments:
- [ ] Linux (Ubuntu/Debian)
- [ ] macOS
- [ ] Windows WSL
- [ ] Different shell environments (bash, zsh)

#### **7. Performance & Scale**
- [ ] Large number of sessions doesn't cause issues
- [ ] Event files don't grow excessively
- [ ] JSON parsing remains fast
- [ ] No memory leaks or resource exhaustion

### 🐛 **Bug Reproduction Template**

When bugs are found, document them with:

```markdown
## Bug Report

**Environment:**
- OS: [Ubuntu 22.04 / macOS 13.0 / Windows 11 WSL]
- Shell: [bash 5.1 / zsh 5.8]
- Dojo Version: [commit hash]

**Steps to Reproduce:**
1. 
2. 
3. 

**Expected Behavior:**


**Actual Behavior:**


**Error Output:**
```
[paste error output here]
```

**Additional Context:**
- First occurrence or repeatable?
- Any recent changes that might be related?
- Workaround available?
```

### 🚀 **Release Readiness Checklist**

Before marking a release as ready:

- [ ] All automated tests pass
- [ ] Manual testing completed on 2+ platforms
- [ ] Documentation is up to date
- [ ] No known critical bugs
- [ ] Security review completed
- [ ] Performance is acceptable
- [ ] Code is clean and commented
- [ ] Git history is clean (no sensitive data)

### 📊 **Performance Benchmarks**

Track these metrics to ensure performance doesn't regress:

```bash
# Time to initialize
time ./dojo-simulator.sh init

# Time to start session  
time ./dojo-simulator.sh start

# JSON file sizes after 10 sessions
for i in {1..10}; do ./dojo-simulator.sh start; done
ls -lah .dojo/

# Memory usage during operations
ps aux | grep dojo-simulator
```

**Expected Performance:**
- Init: < 1 second
- Start: < 0.5 seconds  
- Learn: < 0.5 seconds
- JSON files: < 10KB after 100 sessions
- Memory: < 50MB during operations

### 🔍 **Security Testing Commands**

Run these to verify security posture:

```bash
# Check for dangerous patterns
grep -r "rm -rf\|sudo\|eval\|exec" . --exclude-dir=.git

# Verify file permissions
find . -type f -executable | grep -v ".git"
find . -perm 777

# Check for secrets
grep -ri "password\|secret\|key\|token" . --exclude-dir=.git

# Test input validation
echo "'; rm /tmp/test; echo 'injected" | ./dojo-simulator.sh init

# Verify path traversal protection
./dojo-simulator.sh learn "../../../etc"
```

All security tests should show no vulnerabilities or concerning patterns.