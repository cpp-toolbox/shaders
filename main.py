import os
import re
import argparse
import logging


def setup_logging():
    """
    Configures the logging settings for the script.
    """
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            # logging.FileHandler("shader_compiler.log"),
            logging.StreamHandler()
        ]
    )


def process_shader(file_path, current_dir, included_files=None):
    """
    Processes a GLSL shader file, replacing #include directives with the content of the included files.

    :param file_path: Path to the shader file being processed.
    :param current_dir: Directory of the shader being processed, for resolving relative includes.
    :param included_files: Set of already included files to prevent multiple inclusions.
    :return: Processed shader code.
    """
    if included_files is None:
        included_files = set()

    processed_code = []

    try:
        with open(file_path, 'r') as shader_file:
            logging.info(f"Processing shader file: {file_path}")
            for line in shader_file:
                include_match = re.match(r'^\s*#include\s+"(.+)"\s*$', line)
                if include_match:
                    include_path = include_match.group(1)
                    full_include_path = os.path.join(current_dir, include_path)

                    if full_include_path in included_files:
                        logging.info(f"Skipping already included file: {include_path}")
                        continue

                    if not os.path.isfile(full_include_path):
                        logging.error(f"Included file not found: {include_path}")
                        raise FileNotFoundError(f"Included file not found: {include_path}")

                    logging.info(f"Including file: {include_path}")
                    included_files.add(full_include_path)
                    processed_code.append(f"// Begin include: {include_path}\n")
                    processed_code.append(
                        process_shader(full_include_path, os.path.dirname(full_include_path), included_files)
                    )
                    processed_code.append(f"// End include: {include_path}\n")
                else:
                    processed_code.append(line)
    except Exception as e:
        logging.error(f"Error processing file {file_path}: {e}")
        raise

    return ''.join(processed_code)


def compile_shaders(src_dir, out_dir):
    """
    Compiles all shaders in the source directory by processing #include directives.

    :param src_dir: Source directory containing the shaders.
    :param out_dir: Output directory for processed shaders.
    """
    if not os.path.isdir(src_dir):
        logging.error(f"Source directory does not exist: {src_dir}")
        raise ValueError(f"Source directory does not exist: {src_dir}")

    os.makedirs(out_dir, exist_ok=True)
    logging.info(f"Compiling shaders from {src_dir} to {out_dir}")

    for root, _, files in os.walk(src_dir):
        for file in files:
            if file.endswith('.glsl') or file.endswith('.frag') or file.endswith('.vert'):
                src_path = os.path.join(root, file)
                relative_path = os.path.relpath(src_path, src_dir)
                out_path = os.path.join(out_dir, relative_path)

                os.makedirs(os.path.dirname(out_path), exist_ok=True)

                logging.info(f"Processing: {src_path} -> {out_path}")
                try:
                    processed_shader = process_shader(src_path, os.path.dirname(src_path))
                    with open(out_path, 'w') as out_file:
                        out_file.write(processed_shader)
                    logging.info(f"Successfully processed: {src_path}")
                except Exception as e:
                    logging.error(f"Failed to process {src_path}: {e}")


def main():
    setup_logging()

    parser = argparse.ArgumentParser(description="Compile GLSL shaders with support for #include directives.")
    parser.add_argument('src_dir', help="Source directory containing GLSL shader files.")
    parser.add_argument('out_dir', help="Output directory for processed GLSL shader files.")
    args = parser.parse_args()

    try:
        compile_shaders(args.src_dir, args.out_dir)
        logging.info("Shader compilation completed successfully.")
    except Exception as e:
        logging.critical(f"Critical error: {e}")


if __name__ == '__main__':
    main()
