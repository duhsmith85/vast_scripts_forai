#!/bin/bash

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI

# Packages are installed after nodes so we can fix them...

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    "bitsandbytes"
    "comfy-kitchen>=0.2.0"
)

hf download ashllay/YOLO_Models bbox/Eyeful_v2-Paired.pt --local-dir "${COMFYUI_DIR}/models/ultralytics/bbox"
hf download Kijai/WanVideo_comfy FastWan/Wan2_2-TI2V-5B-FastWanFullAttn_bf16.safetensors --local-dir "${COMFYUI_DIR}/models/diffusion_models"
hf download city96/umt5-xxl-encoder-gguf umt5-xxl-encoder-Q8_0.gguf --local-dir "${COMFYUI_DIR}/models/clip"
# hf download QuantStack/Wan2.1_14B_VACE-GGUF Wan2.1_14B_VACE-Q8_0.gguf --local-dir unet
hf download lym00/Wan2.2_T2V_A14B_VACE-test Wan2.2_T2V_High_Noise_14B_VACE-Q8_0.gguf --local-dir "${COMFYUI_DIR}/models/unet"
hf download lym00/Wan2.2_T2V_A14B_VACE-test Wan2.2_T2V_Low_Noise_14B_VACE-Q8_0.gguf --local-dir "${COMFYUI_DIR}/models/unet"

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager.git"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/city96/ComfyUI-GGUF"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts"
    "https://github.com/chflame163/ComfyUI_LayerStyle"
    "https://github.com/chflame163/ComfyUI_LayerStyle_Advance"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/yolain/ComfyUI-Easy-Use"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/1038lab/ComfyUI-RMBG"
    "https://github.com/pollockjj/ComfyUI-MultiGPU"
    "https://github.com/BadCafeCode/masquerade-nodes-comfyui"
    "https://github.com/calcuis/gguf"
    "https://github.com/KytraScript/ComfyUI_MatAnyone_Kytra"
    "https://github.com/kael558/ComfyUI-GGUF-FantasyTalking"
)

WORKFLOWS=(
    "https://raw.githubusercontent.com/Lightricks/ComfyUI-LTXVideo/refs/heads/master/example_workflows/LTX-2_I2V_Distilled_wLora.json"
    "https://raw.githubusercontent.com/Lightricks/ComfyUI-LTXVideo/refs/heads/master/example_workflows/LTX-2_I2V_Full_wLora.json"
    "https://raw.githubusercontent.com/Lightricks/ComfyUI-LTXVideo/refs/heads/master/example_workflows/LTX-2_V2V_Detailer.json"
)

INPUT=(
    "https://comfyanonymous.github.io/ComfyUI_examples/ltxv/island.jpg"
)

# hf auth login --token $HF_AUTH_TOKEN

# https://huggingface.co/Lightricks/LTX-2/blob/main
CHECKPOINT_MODELS=(
    "https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-19b-dev-fp8.safetensors"
    "https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-19b-distilled-fp8.safetensors"
)

CLIP_MODELS=(
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors"
    "https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors"
)

UPSCALE_MODELS=(
    "https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-spatial-upscaler-x2-1.0.safetensors"
)

TEXT_ENCODERS=(
    "https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-spatial-upscaler-x2-1.0.safetensors"
)

UNET_MODELS=(
)
# LoRA (example)
# https://civitai.com/models/1613190/wan-14b-boob-size-slider
wget -P loras "https://civitai.com/api/download/models/1825608?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition
# https://civitai.com/models/1307155/wan-22-experimental-wan-general-nsfw-model
wget -P loras "https://civitai.com/api/download/models/2073605?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition
wget -P loras "https://civitai.com/api/download/models/2083303?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition
hf download DAKARA555/Wan_Breast_Helper_Hearmeman Wan_Breast_Helper_Hearmeman.safetensors --local-dir loras
# https://civitai.com/models/2109996/wan-22-pussy-and-anus-lora
wget -P loras "https://civitai.com/api/download/models/2387016?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition
# https://civitai.com/models/1434650/nsfwfemale-genitals-helper-for-wan-t2vi2v?modelVersionId=1621698
wget -P loras "https://civitai.com/api/download/models/1621698?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition
# https://civitai.com/models/1713337?modelVersionId=1938875  -  self_forcing
wget -P loras "https://civitai.com/api/download/models/1938875?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition
# https://civitai.com/models/2077390/wan-21-14b-t2v-breast-and-nipples-helper  - 2.3GB!!
wget -P loras "https://civitai.com/api/download/models/2350593?&token=dec1abd15d9725beeeaa7df9616c4eb1" --content-disposition

LORA_MODELS=(
    "https://civitai.com/api/download/models/1825608?&token=dec1abd15d9725beeeaa7df9616c4eb1"
    "https://civitai.com/api/download/models/2073605?&token=dec1abd15d9725beeeaa7df9616c4eb1"
    "https://civitai.com/api/download/models/2083303?&token=dec1abd15d9725beeeaa7df9616c4eb1"
    "https://huggingface.co/DAKARA555/Wan_Breast_Helper_Hearmeman/resolve/main/Wan_Breast_Helper_Hearmeman.safetensors"
    "https://civitai.com/api/download/models/2387016?&token=dec1abd15d9725beeeaa7df9616c4eb1"
    "https://civitai.com/api/download/models/1621698?&token=dec1abd15d9725beeeaa7df9616c4eb1"
    "https://civitai.com/api/download/models/1938875?&token=dec1abd15d9725beeeaa7df9616c4eb1"
    "https://civitai.com/api/download/models/2350593?&token=dec1abd15d9725beeeaa7df9616c4eb1"
)

VAE_MODELS=(
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors"
)

ESRGAN_MODELS=(
)

CONTROLNET_MODELS=(
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_update_comfyui
    provisioning_get_nodes
    provisioning_get_pip_packages
    workflows_dir="${COMFYUI_DIR}/user/default/workflows"
    mkdir -p "${workflows_dir}"
    provisioning_get_files \
        "${workflows_dir}" \
        "${WORKFLOWS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/input" \
        "${INPUT[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/checkpoints" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        "${UNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/lora" \
        "${LORA_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/clip" \
        "${CLIP_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/latent_upscale_models" \
        "${UPSCALE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/text_encoders" \
        "${TEXT_ENCODERS[@]}"
    provisioning_print_end
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip install --no-cache-dir ${PIP_PACKAGES[@]}
    fi
    echo "Updating Comfy Frontend"
    pip install --upgrade comfyui-frontend-package
}

# We must be at release tag v0.7.0 or greater for node support
provisioning_update_comfyui() {
    required_tag="v0.7.0"
    cd ${COMFYUI_DIR}
    git fetch --all --tags
    current_commit=$(git rev-parse HEAD)
    required_commit=$(git rev-parse "$required_tag")
    if git merge-base --is-ancestor "$current_commit" "$required_commit"; then
        git checkout "$required_tag"
        pip install --no-cache-dir -r requirements.txt
    fi
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="${COMFYUI_DIR}/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip install --no-cache-dir -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip install --no-cache-dir -r "${requirements}"
            fi
        fi
    done
}

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 1; fi
    
    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Application will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

# Allow user to disable provisioning if they started with a script they didn't want
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi