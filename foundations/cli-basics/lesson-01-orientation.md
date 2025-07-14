# Lesson 1: Terminal Orientation
*Know where you are, see what's around you*

## Learning Objective
Master the three essential orientation commands that every CLI user needs: `pwd`, `ls`, and `cd`.

## The Philosophy
A samurai knows their surroundings. In the terminal, these three commands are your eyes and legs.

## Core Commands

### `pwd` - Print Working Directory
Your location in the filesystem.

**Practice:**
1. Open your terminal
2. Type `pwd` and press Enter
3. Observe the output - this is your current location

### `ls` - List Directory Contents  
See what's in your current location.

**Practice:**
1. Type `ls` and press Enter
2. Try `ls -l` for detailed view
3. Try `ls -la` to see hidden files too

### `cd` - Change Directory
Move to different locations.

**Practice:**
1. Type `cd ~` to go home
2. Type `pwd` to confirm location
3. Type `cd ..` to go up one level
4. Type `pwd` again to see the change

## Muscle Memory Drill
Repeat this sequence 10 times until it's automatic:
```
pwd → ls -la → cd .. → pwd → cd ~ → pwd
```

## Success Criteria
You've mastered this lesson when you can:
- [ ] Navigate to any directory without thinking
- [ ] Always know where you are with `pwd`
- [ ] Quickly scan directory contents with `ls`
- [ ] Use `cd` reflexively to move around

## What's Next
Lesson 2: File Creation and Manipulation

## Claude Integration Notes
**DO NOT copy-paste these commands!** 
Type each one manually to build muscle memory.

**Struggle Points to Watch:**
- Confusion about file paths
- Forgetting to check location with `pwd`
- Using GUI habits instead of CLI thinking

**Teaching Hints:**
- "Where do you think you are right now?"
- "What do you see when you look around?"
- "How might you move to a different location?"