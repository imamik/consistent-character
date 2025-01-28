FROM runpod/base:0.6.2-cuda12.4.1 AS base

WORKDIR /workspace

# Install Python 3.12.7 using deadsnakes PPA
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

# Install PyTorch with CUDA 12.4 support
RUN /workspace/venv/bin/pip install --upgrade --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# Install ComfyUI and its manager
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && \
    /workspace/venv/bin/pip install -r requirements.txt && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    cd custom_nodes/ComfyUI-Manager && \
    /workspace/venv/bin/pip install -r requirements.txt

RUN /workspace/venv/bin/pip install --upgrade huggingface_hub

# Download models
RUN wget --progress=bar:force:noscroll "https://civitai.com/api/download/models/782002?type=Model&format=SafeTensor&size=full&fp=fp16" -O /workspace/ComfyUI/models/checkpoints/juggernaut.safetensors
RUN wget --progress=bar:force:noscroll "https://civitai.com/api/download/models/90072?type=Model&format=SafeTensor&size=pruned&fp=fp16" -O /workspace/ComfyUI/models/checkpoints/photon.safetensors
# RUN wget --progress=bar:force:noscroll "https://huggingface.co/Comfy-Org/flux1-dev/blob/main/flux1-dev-fp8.safetensors" -O /workspace/ComfyUI/models/checkpoints/flux1-dev-fp8.safetensors

# Create necessary directories
RUN mkdir -p /workspace/outputs && \
    chmod -R 777 /workspace/outputs

# Start Scripts
COPY pre_start.sh /pre_start.sh
RUN chmod +x /pre_start.sh /start.sh

CMD [ "/start.sh" ]