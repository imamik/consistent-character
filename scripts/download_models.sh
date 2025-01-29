#!/bin/bash

# Set workspace path
WORKSPACE_PATH="/workspace/ComfyUI/models"

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
    "$WORKSPACE_PATH/checkpoints/juggernautXL_juggXIByRundiffusion.safetensors"

# TODO: remove this exit
exit 0

# Photon model
download_model \
    "https://civitai.com/api/download/models/90072?type=Model&format=SafeTensor&size=pruned&fp=fp16" \
    "$WORKSPACE_PATH/checkpoints/photon_v1.safetensors"

# UltraSharp upscaler
download_model \
    "https://huggingface.co/Kim2091/UltraSharp/resolve/main/4x-UltraSharp.pth" \
    "$WORKSPACE_PATH/upscale_models/4x-UltraSharp.pth"

# ControlNet Union SDXL
download_model \
    "https://huggingface.co/xinsir/controlnet-union-sdxl-1.0/resolve/main/diffusion_pytorch_model_promax.safetensors" \
    "$WORKSPACE_PATH/controlnet/SDXL/controlnet-union-sdxl-1.0/diffusion_pytorch_model_promax.safetensors"

# OpenPoseXL2 ControlNet
download_model \
    "https://huggingface.co/thibaud/controlnet-openpose-sdxl-1.0/resolve/main/OpenPoseXL2.safetensors" \
    "$WORKSPACE_PATH/controlnet/OpenPoseXL2.safetensors"

# IC-Light Model
download_model \
    "https://huggingface.co/lllyasviel/ic-light/resolve/main/iclight_sd15_fbc.safetensors" \
    "$WORKSPACE_PATH/diffusion_models/IC-Light/iclight_sd15_fbc.safetensors"

# CLIP Vision Models for IP-Adapter
download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors" \
    "$WORKSPACE_PATH/clip_vision/CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"

download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/image_encoder/model.safetensors" \
    "$WORKSPACE_PATH/clip_vision/CLIP-ViT-bigG-14-laion2B-39B-b160k.safetensors"

# IP-Adapter Models
download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors" \
    "$WORKSPACE_PATH/ipadapter/ip-adapter_sd15.safetensors"

download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15_light_v11.bin" \
    "$WORKSPACE_PATH/ipadapter/ip-adapter_sd15_light_v11.bin"

download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sd15.safetensors" \
    "$WORKSPACE_PATH/ipadapter/ip-adapter-plus_sd15.safetensors"

download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus-face_sd15.safetensors" \
    "$WORKSPACE_PATH/ipadapter/ip-adapter-plus-face_sd15.safetensors"

download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-full-face_sd15.safetensors" \
    "$WORKSPACE_PATH/ipadapter/ip-adapter-full-face_sd15.safetensors"

download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15_vit-G.safetensors" \
    "$WORKSPACE_PATH/ipadapter/ip-adapter_sd15_vit-G.safetensors"

download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl.safetensors" \
    "$WORKSPACE_PATH/ipadapter/ip-adapter_sdxl.safetensors"

download_model \
    "https://huggingface.co/ostris/ip-composition-adapter/resolve/main/ip_plus_composition_sd15.safetensors" \
    "$WORKSPACE_PATH/ipadapter/ip_plus_composition_sd15.safetensors"

download_model \
    "https://huggingface.co/Kwai-Kolors/Kolors-IP-Adapter-Plus/resolve/main/ip_adapter_plus_general.bin" \
    "$WORKSPACE_PATH/ipadapter/Kolors-IP-Adapter-Plus.bin"

download_model \
    "https://huggingface.co/Kwai-Kolors/Kolors-IP-Adapter-FaceID-Plus/resolve/main/ipa-faceid-plus.bin" \
    "$WORKSPACE_PATH/ipadapter/Kolors-IP-Adapter-FaceID-Plus.bin"

# Face Detection Model
download_model \
    "https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt" \
    "$WORKSPACE_PATH/ultralytics/bbox/face_yolov8m.pt"

# SDXL IP-Adapter ViT-H Models
download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus-face_sdxl_vit-h.safetensors" \
    "$WORKSPACE_PATH/ipadapter/ip-adapter-plus-face_sdxl_vit-h.safetensors"

download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl_vit-h.safetensors" \
    "$WORKSPACE_PATH/ipadapter/ip-adapter_sdxl_vit-h.safetensors"

download_model \
    "https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus_sdxl_vit-h.safetensors" \
    "$WORKSPACE_PATH/ipadapter/ip-adapter-plus_sdxl_vit-h.safetensors"

echo "All downloads completed!" 