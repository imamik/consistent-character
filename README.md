# Consistent Character - ComfyUI Docker Environment for GPU Cloud Platforms

A specialized Docker environment designed to run
[MickMumpitz's](https://www.patreon.com/c/Mickmumpitz/home) amazing ComfyUI
workflows on GPU cloud platforms like RunPod and Vast.ai. This project makes it
easy to create consistent character generations using advanced Stable Diffusion
techniques.

[![Watch MickMumpitz on YouTube](https://img.shields.io/badge/YouTube-@mickmumpitz-red)](https://www.youtube.com/@mickmumpitz)
[![Support on Patreon](https://img.shields.io/badge/Patreon-MickMumpitz-orange)](https://www.patreon.com/c/Mickmumpitz/home)

## Overview

This project provides a containerized environment specifically optimized for
running ComfyUI workflows, with a focus on character generation and consistency.
It comes pre-configured with all necessary models, extensions, and custom nodes
needed to run MickMumpitz's workflows (Standard, Advanced, PULID) out of the box
on GPU cloud platforms.

## Features

- 🐳 Ready-to-use Docker environment
- 🎨 Pre-configured ComfyUI installation (accessible on port 3000)
- 📂 Web-based file browser (accessible on port 4040)
- 🤖 Pre-installed model categories:
  - Base models (JuggernautXL, Flux1)
  - IP-Adapters (SDXL & SD1.5 variants)
  - ControlNet models
  - Face detection models
  - Upscalers
- 🔧 Optimized for GPU cloud platforms (RunPod, Vast.ai)
- 🔒 SSH access capability
- 🌐 NGINX proxy configuration

## Prerequisites

- RunPod or Vast.ai account
- GPU instance with sufficient VRAM (recommended: 24GB+)
- Docker installed (for local development)

## Quick Start

### Cloud Deployment

1. Pull the Docker image from the registry
2. Deploy on your preferred GPU cloud platform
3. Access ComfyUI through port 3000
4. Use the web file browser on port 4040 to manage your files
5. Import MickMumpitz's workflows and start creating!

### Local Usage

To run the environment locally:

```bash
# Pull the image
docker pull ghcr.io/imamik/consistent-character:latest

# Run the container
docker run -it --gpus all \
  -p 3000:3000 \
  -p 4040:4040 \
  -v /path/to/your/inputs:/opt/ComfyUI/input \
  -v /path/to/your/outputs:/opt/ComfyUI/output \
  ghcr.io/imamik/consistent-character:latest

# Access ComfyUI at http://localhost:3000
# Access file browser at http://localhost:4040
```

Note: Replace `/path/to/your/inputs` and `/path/to/your/outputs` with your
actual local paths for input and output directories.

## Docker Image

The Docker image is available on GitHub Container Registry:

```bash
docker pull ghcr.io/imamik/consistent-character:latest
```

Available tags:

- `latest` - Latest stable release
- `vX.Y.Z` - Specific version releases (e.g., `v1.0.0`)
- `sha-XXXXXXX` - Specific commit builds

You can also reference the image directly in your cloud platform template:

```
ghcr.io/imamik/consistent-character:latest
```

Each release is automatically built and published using GitHub Actions. The
version number is managed through semantic versioning based on commit messages.

## Development

To build the Docker image locally:

```bash
docker build -t consistent-character .
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file
for details.

## Acknowledgments

- Special thanks to [MickMumpitz](https://www.youtube.com/@mickmumpitz) for
  creating the amazing ComfyUI workflows that inspired this project
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) team for the base
  application
- All model creators and contributors

## Support

- For workflow-specific questions, please support MickMumpitz on
  [Patreon](https://www.patreon.com/c/Mickmumpitz/home)
- For environment/deployment issues, please open an issue in this repository
