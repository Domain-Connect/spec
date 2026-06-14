#!/bin/sh

# Enable error handling to stop the script on any error
set -e

# Needed if one has done: sudo snap install metanorma
PATH="$PATH:/snap/bin"

# Output directory for all generated files
OUTDIR="./docs"

# Function to display help
display_help() {
    echo "Usage: $0 filename (without .adoc extension)" >&2
    exit 1
}

# Check if a parameter is provided
if [ -z "$1" ]; then
    filename=`echo draft-ietf-dconn-domainconnect-*.adoc | sed 's/.adoc$//'`
    echo "warning: using default filename: $filename" >&2
else
    filename="$1"
fi

# Check if the .adoc file exists
if [ ! -f "$filename.adoc" ]; then
    echo "Error: File $filename.adoc not found." >&2
    display_help
fi

# Ensure output directory exists
mkdir -p "$OUTDIR"

# Run the metanorma command
metanorma -t ietf "$filename.adoc"

# Remove files created by metanorma's internal xml2rfc call and all temp log/error files
rm -f "$filename.txt" "$filename.html" "$filename".*.log.* "$filename".err.* metanorma.*.log.*

# Rename and update the xml file, move to docs
mv "$filename.rfc.xml" "$OUTDIR/$filename.xml"

# Fixup content
sed -i 's|<stream>Legacy</stream>|<stream>IETF</stream>|g' "$OUTDIR/$filename.xml"

# Generate text, html, and pdf versions into docs (--path for multi-format output)
xml2rfc --text --html --pdf --path "$OUTDIR" "$OUTDIR/$filename.xml"

# Generate a clean text version into docs
xml2rfc --text --no-pagination -o "$OUTDIR/$filename.clean.txt" "$OUTDIR/$filename.xml"

# Update the links for THIS spec in the landing page (docs/index.html), which
# lists the editor's copies of all specs. Only links whose base name matches the
# spec just built are rewritten to the new version, so building one spec does not
# disturb the links of the other(s). The base is the filename without the
# trailing two-digit version (e.g. "...-async-00" -> base "...-async").
cd "$OUTDIR"
base=`echo "$filename" | sed 's/-[0-9]\{2\}$//'`
sed -i "s/$base-[0-9]\{2\}\./$filename./g" index.html
