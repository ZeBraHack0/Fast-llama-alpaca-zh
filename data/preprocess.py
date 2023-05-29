import os
import re

def clean_chinese_text(text):
    cleaned_text = re.sub(r'[^\u4e00-\u9fa5]', '', text.strip())
    return cleaned_text

def clean_txt_file(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as file:
        data = file.readlines()

    # data = clean_chinese_text(data)
    cleaned_lines = []
    for line in data:
        line = line.strip()
        if line:
            cleaned_lines.append(line)

    cleaned_data = '\n'.join(cleaned_lines)

    with open(output_file, 'w', encoding='utf-8') as file:
        file.write(cleaned_data)

def clean_txt_files_in_directory(in_directory, out_directory):
    for filename in os.listdir(in_directory):
        if filename.endswith(".txt"):
            input_file = os.path.join(in_directory, filename)
            output_file = os.path.join(out_directory, "cleaned_" + filename)
            clean_txt_file(input_file, output_file)

# 示例用法
in_directory = '/workspace/myllm/shu/books/近代'  # 指定目录路径
out_directory = '/workspace/myllm/shu/books'  # 指定目录路径

clean_txt_files_in_directory(in_directory, out_directory)