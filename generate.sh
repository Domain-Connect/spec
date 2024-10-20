#!/bin/sh

# Enable error handling to stop the script on any error
set -e

# Function to display help
display_help() {
    echo "Usage: $0 filename (without .adoc extension)"
    exit 1
}

# Check if a parameter is provided
if [ -z "$1" ]; then
    echo "Error: No filename provided."
    display_help
fi

# Check if the .adoc file exists
if [ ! -f "$1.adoc" ]; then
    echo "Error: File $1.adoc not found."
    display_help
fi

# Run the metanorma command
metanorma -t ietf "$1.adoc"

# Rename and update the xml file
mv "$1.rfc.xml" "$1.xml" && sed -i 's|<stream>Legacy</stream>|<stream>IETF</stream>|g' "$1.xml"

# Generate text, html, and pdf versions
xml2rfc --text --html --pdf "$1.xml"

# Generate a clean text version
xml2rfc --text --no-pagination -o "$1.clean.txt" "$1.xml"
