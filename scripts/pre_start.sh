#!/bin/bash

export PYTHONUNBUFFERED=1

# Start filebrowser
filebrowser --address=0.0.0.0 --port=4040 --root=/ --noauth &

cd /ComfyUI || exit 1
mkdir -p /workspace/output
python main.py --listen --port 3000 --output-directory /workspace/output &

# Start model downloads in the background
/download_models.sh &
