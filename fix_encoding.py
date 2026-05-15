import os
import sys

# 配置
ROOT_DIR = "Web"
BACKUP_DIR = "Web_Encoding_Backup"
EXTENSIONS = ['.cs', '.aspx', '.ascx']

def process_file(file_path):
    """
    处理单个文件：
    1. 检查是否已损坏（包含 UTF-8 替换字符）
    2. 如果是 GBK 编码，转换为 UTF-8
    3. 备份原文件
    """
    try:
        with open(file_path, 'rb') as f:
            raw_data = f.read()

        # 1. 检查是否包含 UTF-8 Replacement Character (U+FFFD -> EF BF BD)
        # 如果包含，说明文件内容已经丢失，无法通过转码修复
        if b'\xef\xbf\xbd' in raw_data:
            return 'Damaged'

        # 2. 尝试 UTF-8 解码
        try:
            raw_data.decode('utf-8')
            return 'UTF-8 OK'
        except UnicodeDecodeError:
            pass

        # 3. 尝试 GBK 解码
        try:
            content = raw_data.decode('gbk')
            
            # 备份
            rel_path = os.path.relpath(file_path, ROOT_DIR)
            backup_path = os.path.join(BACKUP_DIR, rel_path)
            os.makedirs(os.path.dirname(backup_path), exist_ok=True)
            with open(backup_path, 'wb') as f:
                f.write(raw_data)

            # 转换为 UTF-8 保存
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            return 'Converted (GBK->UTF-8)'
        except UnicodeDecodeError:
            return 'Unknown Encoding'

    except Exception as e:
        return f'Error: {str(e)}'

def main():
    if not os.path.exists(ROOT_DIR):
        print(f"Error: Directory '{ROOT_DIR}' not found.")
        return

    stats = {
        'Damaged': [],
        'Converted': [],
        'UTF-8 OK': 0,
        'Unknown': 0,
        'Error': 0
    }

    total_files = 0

    print(f"Scanning '{ROOT_DIR}' for encoding issues...")
    print("-" * 50)

    for root, dirs, files in os.walk(ROOT_DIR):
        for file in files:
            if any(file.endswith(ext) for ext in EXTENSIONS):
                file_path = os.path.join(root, file)
                total_files += 1
                
                result = process_file(file_path)
                
                if result == 'Damaged':
                    stats['Damaged'].append(file_path)
                elif result == 'Converted (GBK->UTF-8)':
                    stats['Converted'].append(file_path)
                elif result == 'UTF-8 OK':
                    stats['UTF-8 OK'] += 1
                elif result == 'Unknown Encoding':
                    stats['Unknown'] += 1
                else:
                    stats['Error'] += 1

    # 打印统计
    print(f"\nScan Complete. Total files: {total_files}")
    print("=" * 50)
    print(f"Valid UTF-8: {stats['UTF-8 OK']}")
    print(f"Converted (GBK->UTF-8): {len(stats['Converted'])}")
    print(f"Damaged (Contains '?'): {len(stats['Damaged'])}")
    print(f"Unknown/Error: {stats['Unknown'] + stats['Error']}")
    print("=" * 50)

    if stats['Converted']:
        print("\n[Converted Files] (First 10):")
        for f in stats['Converted'][:10]:
            print(f"  - {f}")
        if len(stats['Converted']) > 10:
            print(f"  ... and {len(stats['Converted']) - 10} more.")
        print(f"Backups saved to: {BACKUP_DIR}")

    if stats['Damaged']:
        print("\n[Damaged Files] (First 10):")
        print("These files contain '?' (U+FFFD). Original Chinese characters are lost.")
        print("You need to manually fix these or restore from a clean backup.")
        for f in stats['Damaged'][:10]:
            print(f"  - {f}")
        if len(stats['Damaged']) > 10:
            print(f"  ... and {len(stats['Damaged']) - 10} more.")

if __name__ == "__main__":
    main()
