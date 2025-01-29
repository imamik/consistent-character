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
ENV CUDA_HOME="/usr/local/cuda"
ENV TORCH_CUDA_ARCH_LIST="7.5;8.0;8.6;8.9;9.0"

# Install PyTorch and related packages with specific versions
RUN /workspace/venv/bin/pip install --no-cache-dir \
    torch==2.1.2 \
    torchvision==0.16.2 \
    torchaudio==2.1.2 \
    --index-url https://download.pytorch.org/whl/cu121

# Install huggingface hub first to ensure correct version
RUN /workspace/venv/bin/pip install --no-cache-dir \
    huggingface_hub==0.19.4 \
    hf_transfer

# Install diffusers and related packages
RUN /workspace/venv/bin/pip install --no-cache-dir \
    diffusers==0.24.0 \
    transformers==4.36.2 \
    accelerate==0.25.0

# Install onnxruntime and other ML packages
RUN /workspace/venv/bin/pip install --no-cache-dir \
    onnxruntime-gpu==1.16.3 \
    insightface==0.7.3 \
    facexlib==0.3.0 \
    typer \
    rich \
    typing_extensions

# Install ComfyUI and manager
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && \
    /workspace/venv/bin/pip install -r requirements.txt && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    cd custom_nodes/ComfyUI-Manager && \
    /workspace/venv/bin/pip install -r requirements.txt

# Create ComfyUI-Manager config
RUN echo '[default]\nwindows_selector_event_loop_policy = True\nbypass_ssl = True\nfile_logging = True\ndowngrade_blacklist = diffusers, kornia, torch, torchaudio, torchvision' > /workspace/ComfyUI/custom_nodes/ComfyUI-Manager/config.ini

# Copy files (grouped together)
COPY snapshots/ /workspace/ComfyUI/user/default/ComfyUI-Manager/snapshots/
COPY scripts/pre_start.sh /pre_start.sh
COPY ClearRealityUpscaler/*.pth /workspace/ComfyUI/models/upscale_models/
COPY scripts/ /workspace/scripts/
COPY input/ /workspace/ComfyUI/input/
COPY workflows/ /workspace/ComfyUI/user/default/workflows/

# Set permissions (grouped together)
RUN chmod 644 /workspace/ComfyUI/models/upscale_models/*.pth && \
    chmod +x /workspace/scripts/*.sh && \
    chmod +x /pre_start.sh

# Download InsightFace model
RUN mkdir -p /workspace/ComfyUI/models/insightface/models && \
    cd /workspace/ComfyUI/models/insightface/models && \
    wget https://github.com/deepinsight/insightface/releases/download/v0.7/antelopev2.zip && \
    unzip antelopev2.zip && \
    rm antelopev2.zip

CMD [ "/start.sh" ]