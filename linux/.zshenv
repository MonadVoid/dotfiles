# Add user local binaries (pipx, custom scripts, etc.) to PATH
export PATH="$HOME/.local/bin:$PATH"

# Default editor for git, sudoedit, and CLI tools
export EDITOR="nvim"
export VISUAL="nvim"

# --- WSL2 Hardware Acceleration (Uncomment on WDDM 2.9+ GPUs like Intel Iris Xe) ---
# Disabled by default because older GPUs (e.g., Intel HD 4400 / WDDM 2.0) fall back to CPU rendering
# export LIBVA_DRIVER_NAME="d3d12"
