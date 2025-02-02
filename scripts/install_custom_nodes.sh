#!/bin/bash

# Assuming we're in the ComfyUI/custom_nodes directory
CUSTOM_NODES_PATH="/ComfyUI/custom_nodes"

# Array of repositories to clone
REPOS=(
    "https://github.com/Limitex/ComfyUI-Diffusers.git"
    "https://github.com/cumulo-autumn/StreamDiffusion.git"
    "https://github.com/huanngzh/ComfyUI-MVAdapter"
    "https://github.com/chrisgoringe/cg-use-everywhere"
    "https://github.com/cubiq/ComfyUI_IPAdapter_plus"
    "https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/WASasquatch/was-node-suite-comfyui"
    "https://github.com/yolain/ComfyUI-Easy-Use"
    "https://github.com/kijai/ComfyUI-Florence2"
    "https://github.com/kijai/ComfyUI-IC-Light"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/lldacing/ComfyUI_BiRefNet_ll"
    "https://github.com/ltdrdata/ComfyUI-Impact-Subpack"
    "https://github.com/jakechai/ComfyUI-JakeUpgrade"
    "https://github.com/giriss/comfy-image-saver"
    "https://github.com/spacepxl/ComfyUI-Image-Filters"
    "https://github.com/liusida/ComfyUI-AutoCropFaces"
    "https://github.com/KoreTeknology/ComfyUI-Universal-Styler"
    "https://github.com/un-seen/comfyui-tensorops"
    "https://github.com/Vaibhavs10/ComfyUI-DDUF"
    "https://github.com/ssitu/ComfyUI_UltimateSDUpscale"
)

# Function to install requirements if they exist
install_requirements() {
    local dir="$1"
    if [ -f "$dir/requirements.txt" ]; then
        echo "Installing requirements for $dir..."
        pip install -r "$dir/requirements.txt"
    fi
    
    # Some repos use install.py
    if [ -f "$dir/install.py" ]; then
        echo "Running install.py for $dir..."
        python "$dir/install.py"
    fi
}

# Clone and install each repository
for repo in "${REPOS[@]}"; do
    # Extract repo name from URL
    repo_name=$(basename "$repo" .git)
    
    echo "Processing $repo_name..."
    
    # Check if directory already exists
    if [ -d "$CUSTOM_NODES_PATH/$repo_name" ]; then
        echo "Directory $repo_name already exists, updating..."
        cd "$CUSTOM_NODES_PATH/$repo_name"
        git pull --recurse-submodules
        cd ..
    else
        echo "Cloning $repo..."
        # Special handling for UltimateSDUpscale
        if [[ "$repo_name" == "ComfyUI_UltimateSDUpscale" ]]; then
            git clone --recursive "$repo" "$CUSTOM_NODES_PATH/$repo_name"
        else
            git clone "$repo" "$CUSTOM_NODES_PATH/$repo_name"
        fi
    fi
    
    # Install requirements if they exist
    install_requirements "$CUSTOM_NODES_PATH/$repo_name"
    
    echo "Finished processing $repo_name"
    echo "----------------------------------------"
done

echo "All repositories have been processed!"
