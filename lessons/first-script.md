# Your First Script

Time to combine everything you've learned into an executable program.

## Create the Script

```bash
touch hello-script.sh
```

## Add the Magic Line

```bash
echo '#!/bin/bash' > hello-script.sh
```

This tells the computer "this is a bash script."

## Add Your Code

```bash
echo 'echo "Hello from my first script!"' >> hello-script.sh
echo 'echo "Today is $(date)"' >> hello-script.sh
```

Check what you created:

```bash
cat hello-script.sh
```

## Make It Executable

```bash
chmod +x hello-script.sh
```

This gives the file permission to run as a program.

## Run Your Script

```bash
./hello-script.sh
```

🎉 **You just created and ran your first program!**

## Make It Interactive

Let's add user input:

```bash
echo 'read -p "What is your name? " user_name' >> hello-script.sh
echo 'echo "Hello, $user_name! Welcome to programming!"' >> hello-script.sh
```

Run it again:

```bash
./hello-script.sh
```

## Challenge

Create a script that:
1. Asks for your name
2. Asks for your age
3. Calculates what year you were born
4. Displays all this information nicely

Hint: Use `$((current_year - age))` for math.

## What's Next?

- **A)** Learn about loops: `cat lessons/loops.md`
- **B)** File permissions deep dive: `cat lessons/file-permissions.md`
- **C)** Build a project tracker: `cat challenges/progress-tracker.md`