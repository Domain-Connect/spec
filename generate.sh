#!/bin/sh

# Enable error handling to stop the script on any error
set -e

# Needed if one has done: sudo snap install metanorma
PATH="$PATH:/snap/bin"

# Function to display help
display_help() {
    echo "Usage: $0 filename (without .adoc extension)" >&2
    exit 1
}

# Check if a parameter is provided
if [ -z "$1" ]; then
    filename=`echo draft-kowalik-domainconnect-*.adoc | sed 's/.adoc$//'`
    echo "warning: using default filename: $filename" >&2
else
    filename="$1"
fi

# Check if the .adoc file exists
if [ ! -f "$filename.adoc" ]; then
    echo "Error: File $filename.adoc not found." >&2
    display_help
fi

# Run the metanorma command
metanorma -t ietf "$filename.adoc"

# Rename and update the xml file
mv "$filename.rfc.xml" "$filename.xml"

# Fixup content
sed -i 's|<stream>Legacy</stream>|<stream>IETF</stream>|g' "$filename.xml"

# Generate text, html, and pdf versions
xml2rfc --text --html --pdf "$filename.xml"

# Generate a clean text version
xml2rfc --text --no-pagination -o "$filename.clean.txt" "$filename.xml"
