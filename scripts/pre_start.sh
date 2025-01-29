#!/bin/bash

export PYTHONUNBUFFERED=1
source /workspace/venv/bin/activate

# Ensure we're in the correct directory
cd /workspace/ComfyUI

# Start model downloads in the background
echo "Starting model downloads..."
/workspace/scripts/download_models.sh &

# Start ComfyUI in the background
echo "Starting ComfyUI server..."
python main.py --listen --port 3000 --output-directory /workspace/outputs &
