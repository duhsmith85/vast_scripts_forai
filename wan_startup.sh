#!/bin/bash
set -e

echo
echo
echo "=== Vast.ai ComfyUI startup script ==="
echo
echo

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
install_or_update https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
install_or_update https://github.com/city96/ComfyUI-GGUF
install_or_update https://github.com/ltdrdata/ComfyUI-Impact-Pack
install_or_update https://github.com/pythongosssss/ComfyUI-Custom-Scripts
install_or_update https://github.com/chflame163/ComfyUI_LayerStyle
install_or_update https://github.com/chflame163/ComfyUI_LayerStyle_Advance
install_or_update https://github.com/rgthree/rgthree-comfy
install_or_update https://github.com/yolain/ComfyUI-Easy-Use
install_or_update https://github.com/kijai/ComfyUI-KJNodes
install_or_update https://github.com/1038lab/ComfyUI-RMBG
install_or_update https://github.com/pollockjj/ComfyUI-MultiGPU
install_or_update https://github.com/BadCafeCode/masquerade-nodes-comfyui
install_or_update https://github.com/calcuis/gguf
install_or_update https://github.com/KytraScript/ComfyUI_MatAnyone_Kytra
install_or_update https://github.com/kael558/ComfyUI-GGUF-FantasyTalking

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

hf download ashllay/YOLO_Models bbox/Eyeful_v2-Paired.pt --local-dir ultralytics/bbox
hf download Kijai/WanVideo_comfy FastWan/Wan2_2-TI2V-5B-FastWanFullAttn_bf16.safetensors --local-dir diffusion_models
hf download city96/umt5-xxl-encoder-gguf umt5-xxl-encoder-Q8_0.gguf --local-dir clip
hf download QuantStack/Wan2.1_14B_VACE-GGUF Wan2.1_14B_VACE-Q8_0.gguf --local-dir unet
hf download ussoewwin/Wan2.2_T2V_A14B_VACE-test_fp16_GGUF Wan2.2_T2V_High_Noise_14B_VACE_fp16.gguf --local-dir unet
hf download ussoewwin/Wan2.2_T2V_A14B_VACE-test_fp16_GGUF Wan2.2_T2V_Low_Noise_14B_VACE_fp16.gguf --local-dir unet

# aria2c -c -x 8 -s 8 -d vae \
#   https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors

wget -P ComfyUI/models/vae "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors" --content-disposition

# LoRA (example)
# https://civitai.com/models/1613190/wan-14b-boob-size-slider
wget -P ComfyUI/models/loras "https://civitai.com/api/download/models/1825608?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition
# https://civitai.com/models/1307155/wan-22-experimental-wan-general-nsfw-model
wget -P ComfyUI/models/loras "https://civitai.com/api/download/models/2073605?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition
wget -P ComfyUI/models/loras "https://civitai.com/api/download/models/2083303?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition
hf download DAKARA555/Wan_Breast_Helper_Hearmeman Wan_Breast_Helper_Hearmeman.safetensors --local-dir ComfyUI/models/loras
# https://civitai.com/models/2109996/wan-22-pussy-and-anus-lora
wget -P ComfyUI/models/loras "https://civitai.com/api/download/models/2387016?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition
# https://civitai.com/models/1713337?modelVersionId=1938875  -  self_forcing
wget -P ComfyUI/models/loras "https://civitai.com/api/download/models/1938875?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition

echo "Updating Comfy Frontend"
pip install --upgrade comfyui-frontend-package

# ---- Final message ----
echo "=== Startup script finished ==="
echo "You can now launch ComfyUI."
