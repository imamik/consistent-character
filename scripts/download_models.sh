#!/bin/bash

# Set workspace path
WORKSPACE_PATH="/workspace/ComfyUI"

# Create necessary directories
mkdir -p "$WORKSPACE_PATH/models/checkpoints"
mkdir -p "$WORKSPACE_PATH/models/upscalers"

# Function to download file
download_model() {
    local url="$1"
    local dest="$2"
    
    if [ -f "$dest" ]; then
        echo "Skipping $dest - already exists"
        return
    fi
    
    echo "Downloading $(basename "$dest")..."
    wget --progress=bar:force:noscroll \
         --show-progress \
         -O "$dest" \
         "$url"
}

# Download models one by one
echo "Starting model downloads..."

# Juggernaut model
download_model \
    "https://civitai.com/api/download/models/782002?type=Model&format=SafeTensor&size=full&fp=fp16" \
    "$WORKSPACE_PATH/models/checkpoints/juggernautXL_juggXIByRundiffusion.safetensors"

# Photon model
download_model \
    "https://civitai.com/api/download/models/90072?type=Model&format=SafeTensor&size=pruned&fp=fp16" \
    "$WORKSPACE_PATH/models/checkpoints/photon_v1.safetensors"

# ClearReality upscalers
download_model \
    "https://mega.nz/folder/Xc4wnC7T#yUS5-9-AbRxLhpdPW_8f2w/file/PVR3lL7J" \
    "$WORKSPACE_PATH/models/upscalers/4x-ClearRealityV1_Soft.safetensors"

download_model \
    "https://mega.nz/folder/Xc4wnC7T#yUS5-9-AbRxLhpdPW_8f2w/file/fQJ3wDAT" \
    "$WORKSPACE_PATH/models/upscalers/4x-ClearRealityV1.safetensors"

echo "All downloads completed!" 