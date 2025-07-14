# Essential Commands

Every programmer needs to navigate and manipulate files. Here are your power tools.

## Where Am I?

```bash
pwd
```

This shows your current directory (Print Working Directory).

## Move Around

```bash
cd lessons
pwd
cd ..
pwd
```

- `cd` = change directory
- `..` = go up one level

## Explore

```bash
ls -la
```

The `-la` flags show:
- `l` = long format (details)
- `a` = all files (including hidden)

## Copy Files

```bash
cp start.md my-copy.md
ls
```

## Move/Rename Files

```bash
mv my-copy.md renamed-file.md
ls
```

## Remove Files (Be Careful!)

```bash
rm renamed-file.md
```

⚠️ **Warning:** This deletes permanently. No trash can.

## Make Directories

```bash
mkdir my-project
cd my-project
pwd
```

## Challenge

1. Create a directory called `practice`
2. Navigate into it
3. Create a file called `notes.txt`
4. Add some content to it
5. Navigate back to the parent directory
6. Copy the entire `practice` directory

## What's Next?

- **A)** Build your first script: `cat lessons/first-script.md`
- **B)** Learn about loops: `cat lessons/loops.md`
- **C)** Advanced file operations: `cat lessons/file-permissions.md`