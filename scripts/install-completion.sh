#!/bin/bash
# Install bash completion for Dirt Claude Dojo

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly COMPLETION_FILE="$SCRIPT_DIR/dojo-completion.bash"

echo "🔧 Installing Dirt Claude Dojo bash completion..."

# Add to .bashrc if not already present
if ! grep -q "dojo-completion.bash" ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo "# Dirt Claude Dojo completion" >> ~/.bashrc
    echo "if [[ -f \"$COMPLETION_FILE\" ]]; then" >> ~/.bashrc
    echo "    source \"$COMPLETION_FILE\"" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
    echo "✅ Added completion to ~/.bashrc"
else
    echo "ℹ️  Completion already installed in ~/.bashrc"
fi

# Source immediately for current session
if [[ -f "$COMPLETION_FILE" ]]; then
    source "$COMPLETION_FILE"
    echo "✅ Completion activated for current session"
fi

echo ""
echo "🎉 Tab completion installed!"
echo "💡 Try typing: ./dojo-simulator.sh nav <TAB><TAB>"
echo "💡 Or: ./dojo-simulator.sh goto <TAB><TAB>"
echo ""
echo "🔄 Restart your terminal or run 'source ~/.bashrc' to use in new sessions"