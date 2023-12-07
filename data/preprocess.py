import os
import re

# def clean_text(file_path, output_path):
#     with open(file_path, 'r', encoding='utf-8') as file:
#         content = file.read()

#     # 保留中文、英文、数字及常见标点
#     cleaned_content = re.sub(r'[^\u4e00-\u9fa5a-zA-Z0-9，。？！：；“”（）《》、—…\s]', '', content)

#     with open(output_path, 'w', encoding='utf-8') as file:
#         file.write(cleaned_content)

# # 使用示例
# input_path = 'path_to_your_input_file.txt'  # 输入文件的路径
# output_path = 'path_to_your_output_file.txt'  # 清理后文件的保存路径

# clean_text(input_path, output_path)



def clean_chinese_text(text):
    cleaned_text = re.sub(r'[^\u4e00-\u9fa5]', '', text.strip())
    return cleaned_text

def clean_txt_file(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8', errors='ignore') as file:
        data = file.readlines()

    # data = clean_chinese_text(data)
    cleaned_lines = []
    for line in data:
        line = line.strip()
        if line:
            cleaned_lines.append(line)

    cleaned_data = '\n'.join(cleaned_lines)

    with open(output_file, 'w', encoding='utf-8', errors='ignore') as file:
        file.write(cleaned_data)

def clean_txt_files_in_directory(in_directory, out_directory):
    for filename in os.listdir(in_directory):
        if filename.endswith(".txt"):
            input_file = os.path.join(in_directory, filename)
            output_file = os.path.join(out_directory, "cleaned_" + filename)
            clean_txt_file(input_file, output_file)

# 示例用法
in_directory = 'book/'  # 指定目录路径
out_directory = 'clean_book/'  # 指定目录路径

clean_txt_files_in_directory(in_directory, out_directory)