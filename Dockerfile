FROM nvidia/cuda:12.4.1-base-ubuntu20.04 AS base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set working directory and environment variables
ENV SHELL=/bin/bash
ENV PYTHONUNBUFFERED=True
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /

# Set up system
RUN apt-get update --yes && \
    apt-get upgrade --yes && \
    apt install --yes --no-install-recommends git wget curl bash libgl1 software-properties-common openssh-server nginx rsync \
    build-essential gcc g++ && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y --no-install-recommends \
    python3.12 \
    python3.12-venv \
    python3.12-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

# Set up Python and pip
RUN ln -s /usr/bin/python3.12 /usr/bin/python && \
    rm /usr/bin/python3 && \
    ln -s /usr/bin/python3.12 /usr/bin/python3 && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py


RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Install necessary Python packages
RUN pip install --upgrade --no-cache-dir pip && \
    pip install --upgrade setuptools && \
    pip install --upgrade wheel

# Install dependencies in the correct order
RUN pip install --upgrade --no-cache-dir diffusers && \
    pip install --upgrade --no-cache-dir huggingface_hub && \
    pip install --upgrade --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124 && \
    pip install --upgrade --no-cache-dir xformers==0.0.29.post2

# Install ComfyUI and ComfyUI Manager
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd /ComfyUI && \
    pip install -r requirements.txt && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    cd custom_nodes/ComfyUI-Manager && \
    pip install -r requirements.txt

RUN scripts/install_custom_nodes.sh

# Install Filebrowser
# Create a non-root user for brew install
RUN useradd -m brewuser && \
    echo "brewuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R brewuser:brewuser /home/linuxbrew/.linuxbrew
# Switch to the non-root user
USER brewuser
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
RUN brew update && brew install gcc && brew install pyenv
RUN brew tap filebrowser/tap && HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 brew install filebrowser
# Temporary while bash path gets fixed https://github.com/astral-sh/uv/issues/1586
RUN brew install uv
# Switch back to root 
USER root

# NGINX Proxy
COPY proxy/nginx.conf /etc/nginx/nginx.conf
COPY proxy/readme.html /usr/share/nginx/html/readme.html
COPY README.md /usr/share/nginx/html/README.md

# Copy the ComfyUI data
COPY ComfyUI/ /ComfyUI/

# Start Scripts
COPY scripts/ /
RUN chmod +x /start.sh /pre_start.sh /download_models.sh /install_custom_nodes.sh

CMD [ "/start.sh" ]