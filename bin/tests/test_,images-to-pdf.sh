#!/bin/bash
set -e

# Setup
TEST_BASE_DIR="$(pwd)/test_run_$(date +%s)"
mkdir -p "$TEST_BASE_DIR"
cd "$TEST_BASE_DIR"

# Create dummy image directory
IMG_DIR="my_photos"
mkdir -p "$IMG_DIR"

# Create some tiny valid images using python
python3 -c "
from PIL import Image
for i in range(3):
    img = Image.new('RGB', (10, 10), color = 'red')
    img.save(f'$IMG_DIR/img_{i}.jpg')
"

# Function to clean up
cleanup() {
  echo "Cleaning up..."
  rm -rf "$TEST_BASE_DIR"
}
trap cleanup EXIT

SCRIPT_PATH="$(cd .. && pwd)/,images-to-pdf"

# Test Case 1: No output specified, using a directory name
echo "Running Test Case 1: No output specified, using directory name..."
bash "$SCRIPT_PATH" "$IMG_DIR"

EXPECTED_FILE="${IMG_DIR}.pdf"
if [[ -f "$EXPECTED_FILE" ]]; then
  echo "SUCCESS: Found $EXPECTED_FILE"
else
  echo "FAILURE: Expected $EXPECTED_FILE not found"
  ls -F
  exit 1
fi

# Test Case 2: Output specified
echo "Running Test Case 2: Output specified..."
CUSTOM_OUTPUT="custom.pdf"
bash "$SCRIPT_PATH" -o "$CUSTOM_OUTPUT" "$IMG_DIR"

if [[ -f "$CUSTOM_OUTPUT" ]]; then
  echo "SUCCESS: Found $CUSTOM_OUTPUT"
else
  echo "FAILURE: Expected $CUSTOM_OUTPUT not found"
  ls -F
  exit 1
fi

# Test Case 3: Current directory (.) - New Behavior
echo "Running Test Case 3: Current directory (.) - New Behavior"
python3 -c "
from PIL import Image
for i in range(2):
    img = Image.new('RGB', (10, 10), color = 'blue')
    img.save(f'root_img_{i}.jpg')
"

bash "$SCRIPT_PATH" .

EXPECTED_FILE="$(basename "$(pwd)").pdf"
if [[ -f "$EXPECTED_FILE" ]]; then
  echo "SUCCESS: Found $EXPECTED_FILE"
else
  echo "FAILURE: Expected $EXPECTED_FILE not found"
  ls -F
  exit 1
fi

echo "All behavior tests passed."

# Test Case 4: Root directory (/) - Verification of Logic via stdout
echo "Running Test Case 4: Root directory (/) - Verification of Logic via stdout"
# We can't easily run on / because it won't find images, 
# but we can see what the script WOULD do if it were to run.
# Since the script exits if no images are found, we check the error/output.

# We'll check if the script handles / without crashing and if we can see the directory name logic.
# If we pass / and it finds no images, it should error out.
# But we want to see if the OUTPUT_FILE was set correctly before it failed.
# Since we can't easily see the variable state, let's just check if it's the correct error.

# We'll use a subshell to capture output
OUTPUT=$(bash "$SCRIPT_PATH" / 2>&1 || true)

if echo "$OUTPUT" | grep -q "Error: No supported images found in directory: /"; then
  echo "SUCCESS: Script correctly identified / as the directory."
else
  echo "FAILURE: Script behavior on / was unexpected"
  echo "Output: $OUTPUT"
  exit 1
fi

# To truly test the '/' case, we'd need to mock the 'command -v img2pdf' or the image collection.
# For now, this confirms it accepts / as a directory.

echo "All tests completed."
