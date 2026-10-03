#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_text_file>"
    exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

# Fixed: Using file descriptor 3 to isolate the file reading from stdin
while IFS=";" read -r command output_file <&3 || [ -n "$command" ]; do
    
    command=$(echo "$command" | xargs)
    output_file=$(echo "$output_file" | xargs)

    [[ -z "$command" || "$command" =~ ^# ]] && continue

    echo "Running: $command -> Appending to: $output_file"

    {
        echo "$command"
        echo ""  
        eval "$command" 2>&1  
        echo ""  
        echo "----------------------------------------"
        echo ""
    } >> "$output_file"

done 3< "$INPUT_FILE" # Fixed: Redirecting the input file specifically into descriptor 3

echo "Done! All commands executed."
