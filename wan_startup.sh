#!/bin/bash
set -e

echo "=== Vast.ai ComfyUI startup script ==="

# ---- Paths ----
COMFY_DIR="/workspace/ComfyUI"
CUSTOM_NODES="$COMFY_DIR/custom_nodes"
MODELS="$COMFY_DIR/models"

# ---- Make sure directories exist ----
mkdir -p "$CUSTOM_NODES"
mkdir -p "$MODELS"/{checkpoints,loras,vae,controlnet}

# ---- Update system packages (optional but common) ----
apt-get update
apt-get install -y git wget aria2

# ---- Pull / update ComfyUI itself ----
if [ -d "$COMFY_DIR/.git" ]; then
  echo "Updating ComfyUI..."
  git -C "$COMFY_DIR" pull
else
  echo "Cloning ComfyUI..."
  git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFY_DIR"
fi

# ---- Install custom nodes (extensions) ----
cd "$CUSTOM_NODES"

install_or_update () {
  REPO_URL=$1
  DIR_NAME=$(basename "$REPO_URL" .git)

  if [ -d "$DIR_NAME" ]; then
    echo "Updating $DIR_NAME..."
    git -C "$DIR_NAME" pull
  else
    echo "Cloning $DIR_NAME..."
    git clone "$REPO_URL"
  fi
}

install_or_update https://github.com/ltdrdata/ComfyUI-Manager.git
install_or_update https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
install_or_update https://github.com/Fannovel16/comfyui_controlnet_aux.git
install_or_update https://github.com/WASasquatch/was-node-suite-comfyui.git

# ---- Install Python requirements for custom nodes ----
echo "Installing Python requirements..."
pip install -r "$COMFY_DIR/requirements.txt" || true

# Some custom nodes have their own requirements
for req in $(find "$CUSTOM_NODES" -name requirements.txt); do
  pip install -r "$req" || true
done

# ---- Download models ----
cd "$MODELS"

echo "Downloading models..."

# Checkpoints
aria2c -c -x 8 -s 8 -d checkpoints \
  https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.ckpt

# VAE
aria2c -c -x 8 -s 8 -d vae \
  https://huggingface.co/stabilityai/sd-vae-ft-mse/resolve/main/sd-vae-ft-mse.safetensors

# LoRA (example)
aria2c -c -x 8 -s 8 -d loras \
  https://huggingface.co/latent-consistency/lcm-lora-sdv1-5/resolve/main/lcm-lora-sdv1-5.safetensors

# ControlNet
aria2c -c -x 8 -s 8 -d controlnet \
  https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth

# ---- Final message ----
echo "=== Startup script finished ==="
echo "You can now launch ComfyUI."
