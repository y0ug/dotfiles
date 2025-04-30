import os
import re
import sys


def extract_code_blocks(text):
    """
    Extracts code blocks and filenames (including paths) from a text containing markdown code blocks.

    Args:
        text (str): The input text containing markdown code blocks.

    Returns:
        list: A list of tuples, where each tuple contains (filename, code_block).
              Returns an empty list if no code blocks are found.
    """
    pattern = r"```(\w+)\n..\s*(.*?)\n(.*?)\n```"
    matches = re.findall(pattern, text, re.DOTALL)

    result = []
    for lang, filename, code in matches:
        result.append((lang, filename, code.strip()))
    return result


def create_file(filename, content, dry_run=False):
    # Ensure we don't go below current directory
    if os.path.isabs(filename) or ".." in filename:
        print(
            f"Error: Cannot create {filename} - absolute paths or parent directory references not allowed"
        )
        return False

    # Create directory if needed
    directory = os.path.dirname(filename)
    if directory and not os.path.exists(directory):
        if dry_run:
            print(f"Would create directory: {directory}")
        else:
            try:
                os.makedirs(directory)
                print(f"Created directory: {directory}")
            except Exception as e:
                print(f"Error creating directory {directory}: {e}")
                return False

    # Display file info and ask for confirmation
    print(f"\n{'=' * 50}")
    print(f"File: {filename}")
    print(f"{'=' * 50}")
    print(content)
    print(f"{'=' * 50}")

    if not dry_run:
        # confirmation = input(f"Create this file? (y/n): ").lower()
        # if confirmation != "y":
        #     print(f"Skipping {filename}")
        #     return False
        try:
            with open(filename, "w") as f:
                f.write(content)
            print(f"Created {filename}")
            return True
        except Exception as e:
            print(f"Error creating {filename}: {e}")
            return False
    return True


def validate_filename(filename, pattern, flags=0):
    """Validates a filename using the provided regex pattern."""
    if not filename:  # Explicitly check for empty string
        return False
    # Use re.fullmatch to ensure the entire string matches the pattern
    return bool(re.fullmatch(pattern, filename, flags))


pattern_strict = (
    r'(?![ .])(?!.*[. ]$)[^<>:"|?*\x00-\x1F]{1,255}'  # Removed ^ and $ for fullmatch
)
pattern_windows_simple = r'(?!.*[. ]$)[^<>:"/\\|?*\x00-\x1F]{1,255}'  # Removed ^ and $, needs separate checks
pattern_unix = r"[^/\x00]{1,255}"  # Removed ^ and $


def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py <markdown_file> [--dry-run]")
        return

    markdown_file = sys.argv[1]
    dry_run = "--dry-run" in sys.argv
    if dry_run:
        print("Dry run mode - no files will be created")

    try:
        with open(markdown_file, "r") as f:
            markdown_text = f.read()
    except Exception as e:
        print(f"Error reading {markdown_file}: {e}")
        return

    matches = extract_code_blocks(markdown_text)
    if not matches:
        print("No code blocks with filenames found in the markdown")
        return

    print(f"Found {len(matches)} code blocks with filenames")
    for lang, fn, code in matches:
        fn = fn.strip()
        is_valid = validate_filename(fn, pattern_strict)
        if not is_valid:
            print(f"{fn} is not a valid filename")
            continue
        create_file(fn, code.strip(), dry_run)


if __name__ == "__main__":
    main()
