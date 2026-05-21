#!/usr/bin/env bash
# Generate all lecture images from prompt files.
# Run from the repo root: bash lectures/lecture4/content/generate_images.sh

set -e

CONTENT_DIR="lectures/lecture5/content"
PROMPT_DIR="$CONTENT_DIR/prompts"
IMAGE_DIR="$CONTENT_DIR/images"

mkdir -p "$IMAGE_DIR"

for f in "$PROMPT_DIR"/*.txt; do
  name=$(basename "$f" .txt).png
  echo "Generating: $name"
  python scripts/generate_image.py "$f" "$IMAGE_DIR/$name"
done

echo "Done. Images saved to $IMAGE_DIR"
