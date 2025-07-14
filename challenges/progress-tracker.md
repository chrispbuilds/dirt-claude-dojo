# Challenge: Build Your Own Progress Tracker

Now you'll build the infrastructure you need to track your learning. This is how real programmers work - they build their own tools.

## The Goal

Create a system to track:
- What you've learned
- When you learned it
- What you want to learn next

## Step 1: Create the Structure

```bash
mkdir -p my-progress/{completed,in-progress,planned}
```

## Step 2: Build a Learning Logger Script

Create `log-learning.sh`:

```bash
#!/bin/bash

read -p "What did you learn today? " lesson
read -p "Rate your understanding (1-10): " rating
date_learned=$(date +"%Y-%m-%d")

echo "$date_learned - $lesson (Understanding: $rating/10)" >> my-progress/completed/log.txt

echo "✅ Logged: $lesson"
echo "📊 Your progress is saved in my-progress/completed/log.txt"
```

## Step 3: Build a Progress Viewer

Create `show-progress.sh`:

```bash
#!/bin/bash

echo "=== YOUR LEARNING JOURNEY ==="
echo ""
echo "📚 What you've completed:"
if [ -f "my-progress/completed/log.txt" ]; then
    cat my-progress/completed/log.txt
else
    echo "Nothing logged yet. Start learning!"
fi

echo ""
echo "🎯 What's planned:"
if [ -f "my-progress/planned/goals.txt" ]; then
    cat my-progress/planned/goals.txt
else
    echo "No goals set yet."
fi
```

## Step 4: Build a Goal Setter

Create `set-goal.sh`:

```bash
#!/bin/bash

read -p "What do you want to learn next? " goal
echo "🎯 $goal" >> my-progress/planned/goals.txt
echo "Goal added: $goal"
```

## Step 5: Make Everything Executable

```bash
chmod +x log-learning.sh show-progress.sh set-goal.sh
```

## Step 6: Test Your System

1. Set a goal: `./set-goal.sh`
2. Log some learning: `./log-learning.sh`
3. View your progress: `./show-progress.sh`

## Level Up: Add Features

Once the basics work, enhance your tracker:

- Color output with `echo -e "\033[32mGreen text\033[0m"`
- Calculate learning streaks
- Export to different formats
- Add categories for different subjects

## Reflection

You just built a learning management system from scratch. This is exactly what professional developers do - identify a need and build a solution.

## What's Next?

- **A)** Advanced scripting: `cat lessons/loops.md`
- **B)** File permissions: `cat lessons/file-permissions.md`
- **C)** Version control: `cat lessons/git-basics.md`