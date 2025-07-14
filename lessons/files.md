# Working with Files

Files are how computers remember things. Let's explore.

## See What's Here

```bash
ls
```

This shows all files in your current location.

## Create an Empty File

```bash
touch my-notes.txt
```

Now check:

```bash
ls
```

See your new file?

## Add Content

```bash
echo "I'm learning programming!" > my-notes.txt
```

Read it back:

```bash
cat my-notes.txt
```

## Add More Content

```bash
echo "Files are containers for information." >> my-notes.txt
```

The `>>` adds to the end instead of replacing.

Check what happened:

```bash
cat my-notes.txt
```

## Challenge

Create a file called `progress.txt` and track what you've learned so far.

## What's Next?

- **A)** Learn about variables: `cat lessons/variables.md`
- **B)** Learn about commands: `cat lessons/commands.md`
- **C)** Build your first script: `cat lessons/first-script.md`