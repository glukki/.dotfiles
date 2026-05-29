#!/bin/bash

# Setup
TEST_BASE_DIR="$(pwd)/test_run_resize_$(date +%s)"
mkdir -p "$TEST_BASE_DIR"
cd "$TEST_BASE_DIR"

# Create dummy image directory
IMG_DIR="my_photos"
mkdir -p "$IMG_DIR"

# Create some tiny valid images using python
python3 -c "
from PIL import Image
# JPG
img1 = Image.new('RGB', (100, 100), color = 'red')
img1.save(f'$IMG_DIR/img1.jpg')
# PNG
img2 = Image.new('RGB', (100, 100), color = 'green')
img2.save(f'$IMG_DIR/img2.png')
# WebP
img3 = Image.new('RGB', (100, 100), color = 'blue')
img3.save(f'$IMG_DIR/img3.png')
"

# Function to clean up
cleanup() {
  echo "Cleaning up..."
  rm -rf "$TEST_BASE_DIR"
}
trap cleanup EXIT

SCRIPT_PATH="$(cd .. && pwd)/,image-resize"

# Test Case 1: Default width
echo "Running Test Case 1: Default width..."
OUTPUT=$(bash "$SCRIPT_PATH" "$IMG_DIR" 2>&1)
EXIT_CODE=$?
echo "$OUTPUT"
echo "Script exited with code $EXIT_CODE"

if [[ $EXIT_CODE -eq 0 ]]; then
    EXPECTED_THUMB_DIR="$IMG_DIR/thumbs"
    if [[ -d "$EXPECTED_THUMB_DIR" ]]; then
      echo "SUCCESS: Found $EXPECTED_THUMB_DIR"
    else
      echo "FAILURE: Expected $EXPECTED_THUMB_DIR not found"
      ls -F
      exit 1
    fi
else
    echo "FAILURE: Script failed with exit code $EXIT_CODE"
    exit 1
fi

# Test Case 2: Specified width
echo "Running Test Case 2: Specified width (50)..."
bash "$SCRIPT_PATH" -w 50 "$IMG_DIR"
EXIT_CODE=$?
echo "Script exited with code $EXIT_CODE"

if [[ $EXIT_CODE -eq 0 ]]; then
    EXPECTED_THUMB_DIR="$IMG_DIR/thumbs"
    # Check width of img1.jpg in thumbs
    WIDTH=$(sips -g pixelWidth "$EXPECTED_THUMB_DIR/img1.jpg" | grep 'pixelWidth:' | awk '{print $2}')
    if [[ "$WIDTH" == "50" ]]; then
      echo "SUCCESS: Width is $WIDTH"
    else
      echo "FAILURE: Expected width 50, but got $WIDTH"
      exit 1
    fi
else
    echo "FAILURE: Script failed with exit code $EXIT_CODE"
    exit 1
fi

# Test Case 3: Non-existent directory
echo "Running Test Case 3: Non-existent directory..."
bash "$SCRIPT_PATH" "non_existent_dir" 2>&1 | grep -q "Error: Directory '.*' does not exist."
if [[ $? -eq 0 ]]; then
  echo "SUCCESS: Correctly handled non-existent directory"
else
  echo "FAILURE: Did not handle non-existent directory correctly"
  exit 1
fi

# Test Case 4: Empty directory
echo "Running Test Case 4: Empty directory..."
EMPTY_DIR="empty_dir"
mkdir -p "$EMPTY_DIR"
bash "$SCRIPT_PATH" "$EMPTY_DIR"
EXIT_CODE=$?
echo "Script exited with code $EXIT_CODE"

if [[ $EXIT_CODE -eq 0 ]]; then
    if [[ -d "$EMPTY_DIR/thumbs" ]]; then
      echo "SUCCESS: Created empty thumbs directory"
    else
      echo "FAILURE: Did not create thumbs directory in empty dir"
      exit 1
    fi

    # Check if thumbs is indeed empty (except for maybe .DS_Store)
    FILE_COUNT=$(find "$EMPTY_DIR/thumbs" -maxdepth 1 -type f | wc -l)
    if [[ "$FILE_COUNT" -eq 0 ]]; then
      echo "SUCCESS: Thumbs directory is empty"
    else
      echo "FAILURE: Thumbs directory is not empty, found $FILE_COUNT files"
      ls -F "$EMPTY_DIR/thumbs"
      exit 1
    fi
else
    echo "FAILURE: Script failed with exit code $EXIT_CODE"
    exit 1
fi

echo "All tests completed successfully."
