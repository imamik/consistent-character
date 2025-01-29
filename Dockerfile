FROM runpod/base:0.6.2-cuda12.1.0 AS base

WORKDIR /workspace

# Create necessary directories
RUN mkdir -p /workspace/outputs /workspace/scripts /workspace/ComfyUI/user/default/ComfyUI-Manager/snapshots/ && \
    chmod -R 777 /workspace/outputs /workspace/scripts

# Consolidated system package installation with deadsnakes PPA
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    python3.12 \
    python3.12-venv \
    python3.12-dev && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 && \
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.12 1

# Virtual environment setup
RUN python3.12 -m venv /workspace/venv && \
    /workspace/venv/bin/pip install --upgrade pip setuptools wheel

# Set environment variable for venv
ENV PATH="/workspace/venv/bin:$PATH"

# PyTorch installation with force-reinstall
RUN /workspace/venv/bin/pip install --upgrade --no-cache-dir --force-reinstall \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Other ML-related package installation
RUN /workspace/venv/bin/pip install --no-cache-dir \
    facexlib \
    onnxruntime-gpu \
    huggingface_hub \
    hf_transfer \
    typer \
    rich \
    typing_extensions \
    streamdiffusion \
    insightface

# ComfyUI and manager installation
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && \
    /workspace/venv/bin/pip install -r requirements.txt && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    cd custom_nodes/ComfyUI-Manager && \
    /workspace/venv/bin/pip install -r requirements.txt

# Copy files (grouped together)
COPY snapshot.json /workspace/ComfyUI/user/default/ComfyUI-Manager/snapshots/
COPY scripts/pre_start.sh /pre_start.sh
COPY ClearRealityUpscaler/*.pth /workspace/ComfyUI/models/upscale_models/
COPY scripts/ /workspace/scripts/
COPY OpenPose-T-Pose.png /workspace/ComfyUI/input/OpenPose-T-Pose.png
COPY IMAMIK_CC_SDXL.json /workspace/ComfyUI/user/default/workflows/IMAMIK_CC_SDXL.json

# Set permissions (grouped together)
RUN chmod 644 /workspace/ComfyUI/models/upscale_models/*.pth && \
    chmod +x /workspace/scripts/*.sh && \
    chmod +x /pre_start.sh

CMD [ "/start.sh" ]