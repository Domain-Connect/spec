#!/bin/sh

# Enable error handling to stop the script on any error
set -e

# Function to display help
display_help() {
    echo "Usage: $0 filename"
    echo "  filename: The PlantUML file (.puml, .plantuml, .txt, etc.) to process."
    exit 1
}

# Check if a parameter is provided
if [ -z "$1" ]; then
    echo "Error: No filename provided."
    display_help
fi

# Check if the plantuml file exists
if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found."
    display_help
fi

# Check if Docker is installed
if command -v docker >/dev/null 2>&1; then
    echo "Docker is installed. Using Docker to process PlantUML file."
    docker run --rm -v "$(pwd):/data" ghcr.io/plantuml/plantuml /data/"$1" -ttxt -progress
    exit 0  # Exit after successful Docker execution
fi

# Check if Java is installed AND PlantUML jar exists
if command -v java >/dev/null 2>&1 && [ -f "/usr/share/java/plantuml.jar" ]; then
    echo "Java and PlantUML jar found. Using Java to process PlantUML file."
    java -jar /usr/share/java/plantuml.jar -ttxt -progress "$1"
    exit 0  # Exit after successful Java execution
fi

# If neither Docker nor Java/PlantUML are available, error out
echo "Error: Neither Docker nor Java with /usr/share/java/plantuml.jar are available." >&2
echo "Please install either Docker or Java and ensure the PlantUML jar is in the correct location." >&2
exit 1