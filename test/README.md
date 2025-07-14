# Dirt Claude Dojo Testing Suite

## 🧪 Quick Start

### Run All Tests
```bash
./test/run-tests.sh
```

### Manual Testing
```bash
# Follow the comprehensive checklist
cat test/manual-test-checklist.md

# Test Claude integration specifically
cat test/claude-integration-test.md
```

## 📁 Test Files

| File | Purpose |
|------|---------|
| `run-tests.sh` | Automated test suite - runs all functional, security, and integration tests |
| `manual-test-checklist.md` | Step-by-step manual testing procedures for human verification |
| `claude-integration-test.md` | Specific tests for Claude Code integration and socratic teaching |
| `README.md` | This file - testing overview and quick reference |

## 🎯 Test Categories

### ⚙️ **Functional Tests** (Automated)
- CLI command functionality (`init`, `start`, `learn`)
- File system operations and permissions  
- JSON data integrity and validation
- Error handling and edge cases

### 🔗 **Integration Tests** (Manual + Automated)  
- Claude Code monitoring and event generation
- Session state management across operations
- Context preservation and lesson loading
- Event file creation and formatting

### 🛡️ **Security Tests** (Automated)
- Input validation and injection prevention
- File permission security
- Path traversal protection
- Command execution safety

### 👤 **User Experience Tests** (Manual)
- First-time user onboarding flow
- Error recovery and help messages
- Lesson content quality and clarity
- Progress tracking visibility

## 🚀 Pre-Release Testing

Before any release, ensure:

1. **Automated tests pass**: `./test/run-tests.sh`
2. **Manual smoke test**: 5-minute quick validation
3. **Platform testing**: Test on Linux, macOS, WSL
4. **Security review**: No vulnerabilities introduced
5. **Content review**: Lessons maintain educational quality

## 🐛 Bug Reporting

When bugs are found:
1. Use template in `manual-test-checklist.md`
2. Include environment details
3. Provide reproduction steps
4. Test on multiple platforms if possible

## 📊 Success Criteria

### Automated Tests
- **100% pass rate** for functional tests
- **0 security vulnerabilities** detected
- **Valid JSON** in all data files
- **Proper file permissions** (644/755)

### Manual Validation
- **Intuitive user experience** for first-time users
- **Clear error messages** with recovery guidance
- **Educational content quality** maintained
- **Philosophy adherence** (no copy-paste opportunities)

### Claude Integration
- **Session detection** works automatically
- **Socratic method** consistently applied
- **Context awareness** maintained across lessons
- **Safety protection** prevents dangerous commands

## 🔧 Troubleshooting Tests

### Test Suite Not Running
```bash
# Check file permissions
ls -la test/run-tests.sh
# Should be executable

# Check dependencies
which jq  # JSON processing
which bash  # Shell interpreter
```

### Tests Failing Unexpectedly
```bash
# Run in verbose mode for debugging
bash -x test/run-tests.sh

# Check for file system issues
df -h  # Disk space
mount  # File system permissions
```

### Claude Integration Issues
```bash
# Verify dojo session state
jq '.session.active' .dojo/claude-integration.json

# Check event generation
ls -la .dojo/events/

# Validate JSON integrity
find .dojo -name "*.json" -exec jq empty {} \;
```

## 📈 Continuous Improvement

### Performance Monitoring
Track these metrics over time:
- Test execution time
- JSON file sizes after heavy usage
- Memory usage during operations
- Startup/operation latency

### Quality Metrics
- Test coverage percentage
- Bug discovery rate
- User feedback sentiment
- Learning effectiveness

### Adding New Tests
When adding features:
1. Add automated tests in `run-tests.sh`
2. Update manual checklist if needed
3. Consider Claude integration impact
4. Update this README if test structure changes

## 🎯 Testing Philosophy

Our testing approach mirrors the dojo's educational philosophy:

- **Comprehensive**: Like thorough CLI mastery
- **Hands-on**: Manual validation ensures real-world usability  
- **Progressive**: Basic functionality before advanced features
- **Safety-first**: Security testing prevents vulnerabilities
- **User-focused**: Experience testing ensures educational value

Just as the dojo builds CLI masters through deliberate practice, our testing builds confidence through thorough validation.