import pandas as pd

def read_template(file_path):
    # đọc sheet chính, bỏ qua header mặc định
    df = pd.read_excel(file_path, sheet_name=0, engine="calamine", header=None)

    # header nằm ở dòng thứ 2 (index 1), bỏ cột đầu tiên
    headers = df.iloc[1].tolist()[1:]
    
    # column size nằm dòng thứ 3 (index 2), bỏ cột đầu tiên
    col_sizes = df.iloc[2].tolist()[1:]

    # data bắt đầu từ dòng thứ 4 (index 3), bỏ cột đầu tiên
    data = df.iloc[3:, 1:]

    return headers, col_sizes, data


def format_row(row, col_sizes, truncate=True):
    output = ""
    for value, size in zip(row, col_sizes):
        text = str(value) if not pd.isna(value) else ""

        if truncate:
            text = text[:int(size)]
        else:
            if len(text) > int(size):
                raise ValueError(f"Value '{text}' exceeds column size {size}")

        output += text.ljust(int(size))
    return output


def generate_txt(file_path, output_path, truncate=True):
    headers, col_sizes, data = read_template(file_path)

    with open(output_path, "w", encoding="utf-8") as f:
        # ghi header
        header_line = format_row(headers, col_sizes, truncate)
        f.write(header_line + "\n")

        # ghi data
        for _, row in data.iterrows():
            line = format_row(row.tolist(), col_sizes, truncate)
            f.write(line + "\n")

    print(f"✅ File generated: {output_path}")


if __name__ == "__main__":
    input_file = "TEMPLATE_new.xlsm"
    output_file = "output.txt"

    generate_txt(input_file, output_file, truncate=True)