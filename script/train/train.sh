#!/bin/bash

source ../include/YCFile.sh
source ../include/YCLog.sh
source ../include/YCTool.sh
source ../include/YCOS.sh

####################################################
root_dir=$(cd $(dirname $0); cd ../../; pwd)
echo_info "root path: ${root_dir}"
script_dir="${root_dir}/Chinese-LLaMA-Alpaca/scripts"
llama_tokenizer_dir="${root_dir}/llama-7b-hf"
chinese_sp_model_file="${root_dir}/Chinese-LLaMA-Alpaca/scripts/chinese_sp.model"
output_dir="${root_dir}/output"
####################################################

show_usage() {
    appname=$0
    echo_info "Usage: ${appname} [command], e.g., ${appname} merge"
    echo_info "  -- setup"
    echo_info "  -- merge [token|lora_pt|lora_sft]"
    echo_info "  -- pretrain"
    echo_info "  -- finetune"
    echo_info "  -- inference"
    echo_info "  -- help                          show help message"
}

setup () {
    echo_back "cd ../../"
    echo_back "pip install transformers==4.28.1 sentencepiece==0.1.97 google protobuf deepspeed==0.9.2 datasets -i https://pypi.tuna.tsinghua.edu.cn/simple  --trusted-host pypi.tuna.tsinghua.edu.cn"
    echo_back "git clone https://github.com/ymcui/Chinese-LLaMA-Alpaca.git"
    echo_back "apt-get install git-lfs"
    echo_back "git lfs clone https://huggingface.co/yahma/llama-7b-hf"
    echo_back "mkdir cache"
    echo_back "mkdir output"
    echo_back "git clone https://github.com/huggingface/peft.git"
    echo_back "cd peft"
    echo_back "git checkout 13e53fc"
    echo_back "pip install . -i https://pypi.tuna.tsinghua.edu.cn/simple  --trusted-host pypi.tuna.tsinghua.edu.cn"
}

merge_tokenizers() {
    echo_back "python ${script_dir}/merge_tokenizers.py --llama_tokenizer_dir ${llama_tokenizer_dir} --chinese_sp_model_file ${chinese_sp_model_file}"
    echo_back "mv ${root_dir}/script/train/merged_tokenizer_hf ${output_dir}"
    echo_back "mv ${root_dir}/script/train/merged_tokenizer_sp ${output_dir}"
}

merge_lora_pt() {
    echo_back "cp merge_llama_with_chinese_lora.py ${script_dir}"
    echo_back "python merge_llama_with_chinese_lora.py --base_model ${llama_tokenizer_dir} --tokenizer_path ${output_dir}/merged_tokenizer_hf --lora_model ${output_dir}/llama-zh/lora --output_type huggingface --output_dir ${output_dir}/merge-lora-hf"
}

merge_lora_sft() {
    echo_back "cp merge_llama_with_chinese_lora.py ${script_dir}"
    echo_back "python merge_llama_with_chinese_lora.py --base_model ${llama_tokenizer_dir} --tokenizer_path ${output_dir}/llama-zh,${output_dir}/llama-alpaca-zh --lora_model ${output_dir}/llama-zh/lora,${output_dir}/llama-alpaca-zh/lora --output_type huggingface --output_dir ${output_dir}/merge-alpaca-hf"
}

merge () {
    local merge_type=${1}
    case ${merge_type} in
        "token")
            merge_tokenizers
            ;;
        "lora_pt")
            merge_lora_pt
            ;;
        "lora_sft")
            merge_lora_sft
            ;;
        *)
            show_usage
            ;;
    esac
}

pretrain_lora() {
    echo_back "cp run_pt.sh ${script_dir}"
    echo_back "cp run_clm_pt_with_peft.py ${script_dir}"
    echo_back "bash ${script_dir}/run_pt.sh"
}

finetune_lora() {
    echo_back "cp run_sft.sh ${script_dir}"
    echo_back "cp run_clm_sft_with_peft.py ${script_dir}"
    echo_back "cd ${script_dir}"
    echo_back "bash ${script_dir}/run_sft.sh"
}

inference() {
    echo_back "python ${script_dir}/inference_hf.py --base_model ${output_dir}/merge-alpaca-hf --with_prompt --interactive"
}

################################################################
####################    * Main Process *    ####################
################################################################
export LC_ALL=C

if (( $# == 0 )); then
    echo_warn "Argument cannot be NULL!"
    show_usage
    exit 0
fi

username=`whoami | awk '{print $1}'`

global_choice=${1}
case ${global_choice} in
    "setup")
        setup
        ;;
    "merge")
        merge ${2}
        ;;
    "pretrain")
        pretrain_lora
        ;;
    "finetune")
        finetune_lora 
        ;;
    "inference")
        inference
        ;;
    "help")
        show_usage 
        ;;
    *)
        echo_erro "Unrecognized argument!"
        show_usage
        ;;
esac
