import os

def clean_assembly_file(input_filename, output_filename):
    # 检查文件是否存在
    if not os.path.exists(input_filename):
        print(f"错误: 找不到文件 '{input_filename}'")
        return

    cleaned_lines = []
    
    # 1. 读取文件
    with open(input_filename, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    for line in lines:
        # 2. 去除注释 (只保留 # 之前的部分)
        if '#' in line:
            line = line.split('#')[0]
        
        # 3. 去除首尾空白 (实现左对齐)
        line = line.strip()
        
        # 4. 如果变为空行，跳过
        if not line:
            continue

        # 5. 处理以 . 开头的行
        if line.startswith('.'):
            # 如果是标签（以 : 结尾），比如 .LBB0_1:，必须保留
            if line.endswith(':'):
                cleaned_lines.append(line)
            # 其他所有以 . 开头的伪指令 (.text, .file, .cfi 等) 全部丢弃
            continue

        # 6. 保留普通指令 (add, sw, jr) 和普通标签 (main:)
        cleaned_lines.append(line)

    # 7. 生成结果文本
    result_text = "\n".join(cleaned_lines)

    # 8. 打印到控制台
    print(f"--- 处理结果 ({input_filename}) ---")
    print(result_text)
    print("-----------------------------------")

    # 9. 保存到新文件
    with open(output_filename, 'w', encoding='utf-8') as f:
        f.write(result_text)
    print(f"已保存到文件: {output_filename}")

if __name__ == "__main__":
    # 指定文件名
    INPUT_FILE = "fib_stack.s"
    OUTPUT_FILE = "fib_stack_clean.s"
    
    clean_assembly_file(INPUT_FILE, OUTPUT_FILE)