FROM runpod/base:0.6.2-cuda12.1.0 AS base

WORKDIR /workspace

# Install Python 3.12 using deadsnakes PPA
RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y python3.12 python3.12-venv python3.12-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pip for Python 3.12
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12

# Make Python 3.12 the default
RUN update-alternatives --install /usr/local/bin/python python /usr/bin/python3.12 1 \
    && update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.12 1

# Create and activate virtual environment
RUN python3.12 -m venv /workspace/venv

# Set environment variable to automatically activate venv when container starts
ENV PATH="/workspace/venv/bin:$PATH"

# Make sure pip is up to date in the venv
RUN /workspace/venv/bin/pip install --upgrade pip

# Install necessary Python packages
RUN /workspace/venv/bin/pip install --upgrade --no-cache-dir setuptools wheel

# Install PyTorch with CUDA 12.1 support
RUN /workspace/venv/bin/pip install --upgrade --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install ComfyUI and its manager
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && \
    /workspace/venv/bin/pip install -r requirements.txt && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    cd custom_nodes/ComfyUI-Manager && \
    /workspace/venv/bin/pip install -r requirements.txt

RUN /workspace/venv/bin/pip install --upgrade huggingface_hub
RUN /workspace/venv/bin/pip install hf_transfer
RUN /workspace/venv/bin/pip install typer rich typing_extensions

# Copy ComfyUI Manager snapshot
RUN mkdir -p /workspace/ComfyUI/user/default/ComfyUI-Manager/snapshots/
COPY 2025-01-29_07-58-54_snapshot.json /workspace/ComfyUI/user/default/ComfyUI-Manager/snapshots/

# Restore the state of the snapshot with the manager using cm-cli
RUN cd /workspace/ComfyUI/custom_nodes/ComfyUI-Manager && \
    /workspace/venv/bin/python cm-cli.py restore-snapshot /workspace/ComfyUI/user/default/ComfyUI-Manager/snapshots/2025-01-29_07-58-54_snapshot.json || exit 1

# Create necessary directories
RUN mkdir -p /workspace/outputs /workspace/scripts && \
    chmod -R 777 /workspace/outputs /workspace/scripts

# Copy scripts
COPY scripts/pre_start.sh /pre_start.sh

# Copy ClearReality upscaler models
COPY ClearRealityUpscaler/*.pth /workspace/ComfyUI/models/upscale_models/
RUN chmod 644 /workspace/ComfyUI/models/upscale_models/*.pth

COPY scripts/ /workspace/scripts/

# Make scripts executable
RUN chmod +x /workspace/scripts/*.sh
RUN chmod +x /pre_start.sh

CMD [ "/start.sh" ]