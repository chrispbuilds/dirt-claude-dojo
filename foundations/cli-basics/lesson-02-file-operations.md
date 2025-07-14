# Lesson 2: File Operations
*Create, copy, move, and remove with confidence*

## Learning Objective
Master the fundamental file manipulation commands: `touch`, `mkdir`, `cp`, `mv`, and `rm`.

## The Philosophy
A master craftsperson knows their tools. These commands are your chisel, hammer, and brush for shaping the digital world.

## Core Commands

### `touch` - Create Files
Creates empty files or updates timestamps.

**Practice:**
1. `touch practice-file.txt`
2. `ls -la` to see your new file
3. `touch file{1..5}.txt` to create multiple files

### `mkdir` - Create Directories
Makes new directories for organization.

**Practice:**
1. `mkdir test-folder`
2. `mkdir -p deep/nested/structure` (creates parent dirs)
3. `ls -la` to see your new directories

### `cp` - Copy Files and Directories
Duplicates files while keeping originals.

**Practice:**
1. `cp practice-file.txt backup.txt`
2. `cp -r test-folder test-folder-copy` (recursive for directories)
3. `ls -la` to verify copies

### `mv` - Move/Rename Files
Moves files to new locations or renames them.

**Practice:**
1. `mv backup.txt renamed-backup.txt`
2. `mv file1.txt test-folder/`
3. `ls test-folder/` to verify the move

### `rm` - Remove Files (Use Carefully!)
Deletes files permanently.

**Practice:**
1. `rm file2.txt` (removes single file)
2. `rm file{3..5}.txt` (removes multiple files)
3. `rm -r test-folder-copy` (removes directory and contents)

## Safety First!
- Always double-check before using `rm`
- Use `ls` to verify what you're about to delete
- Practice in safe directories, not important areas
- `rm` is permanent - there's no "undo"

## Muscle Memory Drill
Create this workflow until it's automatic:
```
mkdir practice → cd practice → touch test.txt → cp test.txt backup.txt → 
mv test.txt renamed.txt → ls -la → rm backup.txt → cd .. → rm -r practice
```

## Real-World Application
**Project Setup Pattern:**
```
mkdir my-project
cd my-project
mkdir src docs tests
touch README.md src/main.py tests/test_main.py
```

## Success Criteria
You've mastered this lesson when you can:
- [ ] Create files and directories confidently
- [ ] Copy files for backup without thinking
- [ ] Rename and move files smoothly
- [ ] Use `rm` safely with proper caution
- [ ] Set up project structures quickly

## What's Next
Lesson 3: File Content and Text Manipulation

## Claude Integration Notes
**CRITICAL: NO COPY-PASTE!**
Students must type every command manually.

**Common Struggle Points:**
- Forgetting `-r` flag for directory operations
- Using `rm` carelessly without checking
- Confusion between `cp` and `mv` behavior
- Path navigation when moving files

**Socratic Guidance Triggers:**
- "What do you think the `-r` flag does?"
- "How can you verify what's in that directory before removing it?"
- "What's the difference between copying and moving a file?"
- "Where do you think that file went when you moved it?"

**Dangerous Command Protection:**
Watch for patterns like `rm -rf /` or `rm *` in root directories.