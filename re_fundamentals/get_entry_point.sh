#!/bin/bash

# Source the helper script to load the display_elf_header_info function
if [ -f "./messages.sh" ]; then
    source ./messages.sh
else
    echo "Error: 'messages.sh' not found in the current directory." >&2
    exit 1
fi

# 1. Check if an argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_name>" >&2
    exit 1
fi

file_name="$1"

# 2. Check if the file exists
if [ ! -e "$file_name" ]; then
    echo "Error: File '$file_name' does not exist." >&2
    exit 1
fi

# 3. Check if it is a regular file
if [ ! -f "$file_name" ]; then
    echo "Error: '$file_name' is not a regular file." >&2
    exit 1
fi

# 4. Check if the file is a valid ELF file using readelf
readelf_output=$(readelf -h "$file_name" 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$readelf_output" ]; then
    echo "Error: '$file_name' is not a valid ELF file." >&2
    exit 1
fi

# 5. Extract required fields from the ELF header output
magic_number=$(echo "$readelf_output" | grep -m 1 "Magic:" | sed -E 's/^[[:space:]]*Magic:[[:space:]]*//')
class=$(echo "$readelf_output" | grep -m 1 "Class:" | awk '{print $2}')
byte_order=$(echo "$readelf_output" | grep -m 1 "Data:" | sed -E 's/.*,[[:space:]]*//')
entry_point_address=$(echo "$readelf_output" | grep -m 1 "Entry point address:" | awk '{print $NF}')

# 6. Call the function defined in messages.sh
display_elf_header_info
