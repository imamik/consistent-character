#!/bin/bash

export PYTHONUNBUFFERED=1

# Ensure workspace directories exist
mkdir -p /workspace/ComfyUI
mkdir -p /workspace/venv

# Sync venv files
if ! rsync -a /venv/ /workspace/venv/; then
    echo "Error: Failed to sync venv files to workspace"
    exit 1
fi

# Activate the workspace venv
source /workspace/venv/bin/activate

# Sync ComfyUI files
if ! rsync -a --ignore-existing /ComfyUI/ /workspace/ComfyUI/; then
    echo "Error: Failed to sync ComfyUI files to workspace"
    exit 1
fi

cd /workspace/ComfyUI || exit 1
python main.py --listen --port 3000 &

# Start model downloads in the background
# echo "Starting model downloads..."
/download_models.sh &

# Start filebrowser
filebrowser --address=0.0.0.0 --port=4040 --root=/ --noauth &
