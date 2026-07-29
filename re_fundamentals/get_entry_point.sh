#!/bin/bash

# Source messages.sh to import display_elf_header_info function
if [ -f "./messages.sh" ]; then
    source ./messages.sh
elif [ -f "messages.sh" ]; then
    source messages.sh
else
    echo "Error: messages.sh not found." >&2
    exit 1
fi

# 1. Ensure a file argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file_name>" >&2
    exit 1
fi

file_name="$1"

# 2. Ensure file exists and is a regular file
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist or is not a regular file." >&2
    exit 1
fi

# 3. Read ELF header and validate file
readelf_output=$(readelf -h "$file_name" 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$readelf_output" ]; then
    echo "Error: File '$file_name' is not a valid ELF file." >&2
    exit 1
fi

# 4. Extract information and trim trailing whitespace
magic_number=$(echo "$readelf_output" | grep -m 1 "Magic:" | sed -E 's/^[[:space:]]*Magic:[[:space:]]*//' | xargs)
class=$(echo "$readelf_output" | grep -m 1 "Class:" | awk '{print $2}' | xargs)
byte_order=$(echo "$readelf_output" | grep -m 1 "Data:" | sed -E 's/.*,[[:space:]]*//' | xargs)
entry_point_address=$(echo "$readelf_output" | grep -m 1 "Entry point address:" | awk '{print $NF}' | xargs)

# 5. Display output using function from messages.sh
display_elf_header_info
