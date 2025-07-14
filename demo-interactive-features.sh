#!/bin/bash
# Demo script for new interactive features

set -euo pipefail

echo "🎉 Dirt Claude Dojo - Interactive Features Demo"
echo "==============================================="
echo

echo "🧭 1. Smart Navigation System"
echo "Try these commands:"
echo "  ./dojo-simulator.sh nav                    # Browse all topics"
echo "  ./dojo-simulator.sh nav cli-basics         # Browse CLI basics lessons"
echo "  ./dojo-simulator.sh goto lesson-01         # Jump to a specific lesson"
echo "  ./dojo-simulator.sh status                 # Check your progress"
echo "  ./dojo-simulator.sh search 'file'          # Search lesson content"
echo

echo "🎯 2. Interactive Lessons"
echo "Try these commands:"
echo "  ./dojo-simulator.sh interactive lesson-01  # Start interactive mode"
echo "  ./dojo-simulator.sh review lesson-01       # Read lesson content"
echo

echo "⌨️  3. Tab Completion (after installation)"
echo "Run: ./scripts/install-completion.sh"
echo "Then try: ./dojo-simulator.sh nav <TAB><TAB>"
echo

echo "🔍 4. Enhanced Features"
echo "• Real-time command validation"
echo "• Progress tracking with visual bars"
echo "• Breadcrumb navigation"
echo "• Contextual hints and feedback"
echo "• Success criteria checking"
echo

echo "🚀 Quick Start:"
echo "1. ./dojo-simulator.sh init     # Initialize if not done"
echo "2. ./dojo-simulator.sh start    # Start session"
echo "3. ./dojo-simulator.sh nav      # Browse lessons"
echo "4. ./dojo-simulator.sh goto lesson-01  # Start learning!"
echo

echo "💡 The old commands still work, but the new ones are much better!"
echo "💡 Try 'dojo nav' vs the old 'dojo learn cli-basics'"