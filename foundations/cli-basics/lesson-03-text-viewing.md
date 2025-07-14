# Lesson 3: Text Viewing and Basic Manipulation
*Read, search, and understand file contents*

## Learning Objective
Master essential text viewing commands: `cat`, `less`, `head`, `tail`, `grep`, and `wc`.

## The Philosophy
Information is power. These commands turn you from blind to all-seeing in the filesystem.

## Core Commands

### `cat` - Display File Contents
Shows entire file contents at once.

**Practice:**
1. `cat foundations/cli-basics/lesson-01-orientation.md`
2. `cat .dojo/progress.json` (see your progress!)
3. Create a test file: `echo "Hello Dojo" > test.txt`, then `cat test.txt`

### `less` - Paginated File Viewing
Navigate through large files comfortably.

**Practice:**
1. `less foundations/cli-basics/lesson-01-orientation.md`
2. Use arrow keys or `j/k` to navigate
3. Press `/` to search, `q` to quit
4. Try `less .dojo/claude-integration.json`

### `head` - First Lines of File
See the beginning of files quickly.

**Practice:**
1. `head -5 foundations/cli-basics/lesson-01-orientation.md`
2. `head .dojo/progress.json`
3. `head -n 3 /etc/passwd` (first 3 lines)

### `tail` - Last Lines of File
Monitor file endings, great for logs.

**Practice:**
1. `tail foundations/cli-basics/lesson-01-orientation.md`
2. `tail -n 5 .dojo/progress.json` (last 5 lines)
3. `tail -f .dojo/events/event-*.json` (follow new additions - Ctrl+C to stop)

### `grep` - Search Text Patterns
Find specific content in files.

**Practice:**
1. `grep "philosophy" foundations/cli-basics/lesson-01-orientation.md`
2. `grep -i "claude" .dojo/claude-integration.json` (case insensitive)
3. `grep -n "lesson" foundations/cli-basics/lesson-*.md` (show line numbers)

### `wc` - Word, Line, and Character Count
Get file statistics.

**Practice:**
1. `wc foundations/cli-basics/lesson-01-orientation.md`
2. `wc -l .dojo/progress.json` (just line count)
3. `wc -w foundations/cli-basics/lesson-*.md` (word count for all lessons)

## Power Combinations
Chain commands for greater insight:

**File Analysis Pattern:**
```
ls -la *.md | wc -l          # Count markdown files
grep -c "Practice" lesson-*.md    # Count practice sections
head -1 lesson-*.md          # See all lesson titles
```

**Log Monitoring Pattern:**
```
tail -f logfile.txt | grep "ERROR"    # Watch for errors in real-time
grep "user" .dojo/events/*.json | wc -l    # Count user events
```

## Muscle Memory Drill
Practice this investigation sequence:
```
ls -la → cat somefile.txt → less bigfile.txt → 
head -5 bigfile.txt → tail -5 bigfile.txt → 
grep "pattern" *.txt → wc -l *.txt
```

## Real-World Applications

**Log Analysis:**
```
tail -100 /var/log/syslog | grep "error"
head -20 access.log | grep "404"
```

**Code Review:**
```
grep -n "TODO" src/*.py
wc -l src/*.py | sort -n
```

**Configuration Checking:**
```
grep "^#" config.file        # Find commented lines
tail -20 config.file         # See recent changes
```

## Success Criteria
You've mastered this lesson when you can:
- [ ] Quickly scan file contents with appropriate viewer
- [ ] Search for specific patterns efficiently
- [ ] Monitor files for changes in real-time
- [ ] Get file statistics and counts instantly
- [ ] Chain commands for complex text analysis

## What's Next
Lesson 4: File Permissions and Ownership

## Claude Integration Notes
**Encourage Exploration:**
Don't just show the commands - have students investigate their own dojo files!

**Discovery Questions:**
- "What do you think is in that JSON file?"
- "How could you find all mentions of 'lesson' in these files?"
- "What would happen if you combine grep and wc?"

**Common Struggles:**
- Forgetting how to exit `less` (press 'q')
- Not understanding grep pattern matching
- Overwhelming output from `cat` on large files
- Confusion about when to use head vs tail vs less

**Guided Discovery:**
Instead of explaining flags, ask: "What do you think the `-n` flag might do? Try it and see!"