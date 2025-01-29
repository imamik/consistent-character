#!/bin/bash

export PYTHONUNBUFFERED=1
source /venv/bin/activate
rsync -au --remove-source-files /ComfyUI/ /workspace/ComfyUI/
ln -s /comfy-models/* /workspace/ComfyUI/models/checkpoints/

cd /workspace/ComfyUI
python main.py --listen --port 3000 &

# Start model downloads in the background
# echo "Starting model downloads..."
#/workspace/scripts/download_models.sh &

# Start filebrowser
filebrowser --address=0.0.0.0 --port=4040 --root=/ --noauth &
