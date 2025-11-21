#!/usr/bin/env bash

echo "===== Checking Dependencies (Absolute Paths) ====="

# --------------------
# Python3
# --------------------
if command -v python3 >/dev/null 2>&1; then
    echo "[OK] python3: $(python3 --version)"
else
    echo "[ERR] python3 not found in PATH. Checking for python..."
    # --------------------
    # Python
    # --------------------
    if command -v python >/dev/null 2>&1; then
        echo "[OK] python: $(python --version)"
    else
        echo "[ERR] python not found in PATH"
    fi
fi





# --------------------
# make.exe (absolute path)
# --------------------
MAKE_PATH="/c/ECEN20/make.exe"

echo ""
echo "===== Checking make ====="

if [ -f "$MAKE_PATH" ]; then
    echo "[OK] make.exe exists at: $MAKE_PATH"
    "$MAKE_PATH" --version
else
    echo "[ERR] make.exe NOT found at: $MAKE_PATH"
fi


# --------------------
# Check if bash_profile defines make
# --------------------
echo ""
echo "===== Checking .bash_profile for make alias or PATH ====="

if [ -f "$HOME/.bash_profile" ]; then

    # Search for alias make=... or PATH export containing /c/ECEN20
    if grep -q "alias make=" "$HOME/.bash_profile"; then
        echo "[OK] Found alias make= in ~/.bash_profile"
        grep "alias make=" "$HOME/.bash_profile"
    elif grep -q "/c/ECEN20" "$HOME/.bash_profile"; then
        echo "[OK] Found PATH entry including /c/ECEN20 in ~/.bash_profile"
        grep "/c/ECEN20" "$HOME/.bash_profile"
    else
        echo "[ERR] No 'make' alias or PATH entry for /c/ECEN20 found in ~/.bash_profile"
        echo "      Expected something like:"
        echo "      alias make=/c/ECEN20/make.exe"
        echo "      or"
        echo "      export PATH=\"/c/ECEN20:\$PATH\""
    fi

else
    echo "[ERR] ~/.bash_profile does not exist"
fi


# --------------------
# arm-none-eabi-gcc (absolute path)
# --------------------
echo ""
echo "===== Checking arm-none-eabi-gcc ====="

# --- Check arm-none-eabi-gcc & compute QORC_TC_PATH ---
if command -v arm-none-eabi-gcc >/dev/null 2>&1; then
    TOOL_DIR="$(which arm-none-eabi-gcc)"
    QORC_TC_PATH="$(echo "$TOOL_DIR" | sed 's|/arm-none-eabi-gcc||')"
    echo "[OK] arm-none-eabi-gcc found: $TOOL_DIR"
    echo "QORC_TC_PATH = $QORC_TC_PATH"
else
    echo "[ERR] arm-none-eabi-gcc not found"
fi


# --------------------
# Print bash_profile contents
# --------------------
echo ""
echo "===== ~/.bash_profile contents ====="
if [ -f "$HOME/.bash_profile" ]; then
    cat "$HOME/.bash_profile"
else
    echo "(No ~/.bash_profile found)"
fi
