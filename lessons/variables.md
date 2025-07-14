# Variables: Containers for Data

Variables let you store and reuse information. Think of them as labeled boxes.

## Your First Variable

```bash
name="YourName"
```

Use it:

```bash
echo "Hello, $name!"
```

## Numbers Too

```bash
age=25
echo "I am $age years old"
```

## Multiple Variables

```bash
name="Alex"
age=30
city="Portland"
echo "$name is $age years old and lives in $city"
```

## User Input

Let the user decide:

```bash
read -p "What's your name? " username
echo "Nice to meet you, $username!"
```

## Challenge

Create variables for your favorite:
- Color
- Food  
- Programming language (even if you don't know any yet)

Then display them in a sentence.

## What's Next?

- **A)** Learn about commands: `cat lessons/commands.md`
- **B)** Build your first script: `cat lessons/first-script.md`
- **C)** Learn about loops: `cat lessons/loops.md`