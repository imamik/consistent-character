#!/usr/bin/env python3

import json
import os
import asyncio
import aiohttp
from pathlib import Path
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

WORKSPACE_PATH = "/workspace/ComfyUI"
MAX_CONCURRENT_DOWNLOADS = 3
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

async def download_file(session: aiohttp.ClientSession, url: str, dest_path: str):
    if os.path.exists(dest_path):
        logger.info(f"Skipping {dest_path} - already exists")
        return True

    try:
        os.makedirs(os.path.dirname(dest_path), exist_ok=True)
        
        async with session.get(url) as response:
            if response.status != 200:
                logger.error(f"Failed to download {url}: HTTP {response.status}")
                return False
                
            total_size = int(response.headers.get('content-length', 0))
            
            with open(dest_path, 'wb') as f:
                downloaded = 0
                async for chunk in response.content.iter_chunked(8192):
                    f.write(chunk)
                    downloaded += len(chunk)
                    if total_size:
                        progress = (downloaded / total_size) * 100
                        print(f"\rDownloading {os.path.basename(dest_path)}: {progress:.1f}%", end='')
                
                print()  # New line after progress
                
        logger.info(f"Successfully downloaded {dest_path}")
        return True
        
    except Exception as e:
        logger.error(f"Error downloading {url}: {str(e)}")
        if os.path.exists(dest_path):
            os.remove(dest_path)
        return False

async def main():
    config_path = os.path.join(SCRIPT_DIR, 'models_config.json')
    with open(config_path, 'r') as f:
        models = json.load(f)
    
    async with aiohttp.ClientSession() as session:
        tasks = []
        for rel_path, url in models.items():
            full_path = os.path.join(WORKSPACE_PATH, rel_path)
            task = download_file(session, url, full_path)
            tasks.append(task)
        
        # Process downloads in chunks of MAX_CONCURRENT_DOWNLOADS
        for i in range(0, len(tasks), MAX_CONCURRENT_DOWNLOADS):
            chunk = tasks[i:i + MAX_CONCURRENT_DOWNLOADS]
            await asyncio.gather(*chunk)

if __name__ == "__main__":
    asyncio.run(main()) 