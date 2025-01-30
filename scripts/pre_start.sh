#!/bin/bash

export PYTHONUNBUFFERED=1
source /venv/bin/activate

# Ensure workspace directory exists
mkdir -p /workspace/ComfyUI

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
