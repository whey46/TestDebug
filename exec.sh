#!/bin/bash

# Check if the input text file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_text_file>"
    exit 1
fi

INPUT_FILE="$1"

# Verify the input file actually exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

# Read the file line by line, splitting by the semicolon delimiter
while IFS=";" read -r command output_file || [ -n "$command" ]; do
    
    # Trim leading/trailing whitespace from the variables
    command=$(echo "$command" | xargs)
    output_file=$(echo "$output_file" | xargs)

    # Skip empty lines or comment lines starting with #
    [[ -z "$command" || "$command" =~ ^# ]] && continue

    echo "Running: $command -> Appending to: $output_file"

    # Append the command and its output to the specified file
    {
        echo "$command"
        echo ""  # Newline separator
        eval "$command" 2>&1  # Runs command and captures both stdout and stderr
        echo ""  # Extra newline padding at the end
        echo "----------------------------------------"
        echo ""
    } >> "$output_file"

done < "$INPUT_FILE"

echo "Done! All commands executed."
