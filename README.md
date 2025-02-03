# Consistent Character - ComfyUI Docker Environment for RunPod

A specialized Docker environment designed to run
[MickMumpitz's](https://www.patreon.com/c/Mickmumpitz/home) amazing ComfyUI
workflows on RunPod. This project makes it easy to create consistent character
generations using advanced Stable Diffusion techniques.

[![Watch MickMumpitz on YouTube](https://img.shields.io/badge/YouTube-@mickmumpitz-red)](https://www.youtube.com/@mickmumpitz)
[![Support on Patreon](https://img.shields.io/badge/Patreon-MickMumpitz-orange)](https://www.patreon.com/c/Mickmumpitz/home)

## Overview

This project provides a containerized environment specifically optimized for
running ComfyUI workflows, with a focus on character generation and consistency.
It includes all necessary models, extensions, and configurations needed to run
MickMumpitz's workflows out of the box on RunPod.

## Features

- 🐳 Ready-to-use Docker environment
- 🎨 Pre-configured ComfyUI installation
- 🤖 Automatic model downloads including:
  - JuggernautXL
  - Photon
  - Flux1
  - Various IP-Adapter models
  - ControlNet models (Union SDXL, OpenPoseXL2)
  - UltraSharp upscaler
  - Face detection models
- 🔧 Optimized for RunPod deployment
- 📝 Jupyter Lab support (optional)
- 🔒 SSH access capability
- 🌐 NGINX proxy configuration

## Prerequisites

- RunPod account
- GPU instance with sufficient VRAM (recommended: 24GB+)
- Docker installed (for local development)

## Quick Start

1. Pull the Docker image from the registry
2. Deploy on RunPod
3. Access ComfyUI through the provided URL
4. Import MickMumpitz's workflows and start creating!

## Docker Image

The Docker image is available on GitHub Container Registry:

```bash
docker pull ghcr.io/imamik/consistent-character:latest
```

Available tags:

- `latest` - Latest stable release
- `vX.Y.Z` - Specific version releases (e.g., `v1.0.0`)
- `sha-XXXXXXX` - Specific commit builds

You can also reference the image directly in your RunPod template:

```
ghcr.io/imamik/consistent-character:latest
```

Each release is automatically built and published using GitHub Actions. The
version number is managed through semantic versioning based on commit messages.

## Environment Variables

- `JUPYTER_PASSWORD`: Set to enable Jupyter Lab (optional)
- `PUBLIC_KEY`: SSH public key for remote access (optional)

## Directory Structure

```
.
├── ComfyUI/           # ComfyUI installation and custom nodes
├── proxy/             # NGINX configuration
├── scripts/           # Utility scripts
│   ├── download_models.sh
│   ├── install_custom_nodes.sh
│   ├── pre_start.sh
│   └── start.sh
└── Dockerfile         # Container configuration
```

## Included Models

The environment comes with a curated selection of models optimized for character
generation:

- **Base Models**
  - JuggernautXL
  - Photon
  - Flux1

- **Upscalers**
  - UltraSharp 4x

- **ControlNet**
  - ControlNet Union SDXL
  - OpenPoseXL2

- **IP-Adapters**
  - Various SDXL and SD1.5 IP-Adapter models
  - Face-specific adapters
  - Kolors IP-Adapter variants

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
