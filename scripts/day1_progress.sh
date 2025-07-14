#!/bin/bash
# Day 1 Progress Tracker
# My first script written in vim!

set -euo pipefail

echo "=== Day 1 Progress Report ==="
echo "Date: $(date)"
echo "User: $(whoami)"
echo "Location: $(pwd)"
echo

echo "=== Skills Practiced Today ==="
echo "✓ Terminal navigation hotkeys"
echo "✓ File operations and permissions"
echo "✓ Vim modal editing basics"
echo "✓ Git repository workflow"
echo

echo "=== Environment Check ==="
echo "Bootcamp directory: $(pwd)"
echo "Practice files: $(find practice -name "*.txt" | wc -l) files"
echo "Scripts created: $(find scripts -name "*.sh" | wc -l) scripts"
echo

echo "=== Next Steps ==="
echo "Tomorrow: Text processing and advanced vim"
echo "Goal: Master piping and grep patterns"
echo

echo "Day 1 complete! 🎉"
