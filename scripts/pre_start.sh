#!/bin/bash

export PYTHONUNBUFFERED=1

# Create workspace models directory if it doesn't exist
mkdir -p /workspace/models
mkdir -p /workspace/output

# Sync initial models from ComfyUI to workspace and remove original
rsync -av /ComfyUI/models/ /workspace/models/
rm -rf /ComfyUI/models
ln -sf /workspace/models /ComfyUI/models

# Start filebrowser
filebrowser --address=0.0.0.0 --port=4040 --root=/ --noauth &

cd /ComfyUI || exit 1
python main.py --listen --port 3000 --output-directory /workspace/output &

# Start model downloads in the background
/download_models.sh &
