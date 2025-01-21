#!/bin/bash

# Specify the folder containing the image files.
FOLDER_PATH="/Volumes/Macintosh HD/Users/jaga/Desktop/bkgpics"

# The rest of your script...

# Specify the base output folder for the JPEG files.
BASE_OUTPUT_FOLDER="$FOLDER_PATH/jpeg"

# Sizes to convert: width (w) or height (h) specifications
declare -a SIZES=("150w" "300w" "1024w" "768h")

# Initialize a counter
counter=0

# Loop through all image files in the folder and subfolders recursively
while IFS= read -r file; do
    if [ -f "$file" ]; then # Check if it is a file and not empty
        relative_path="${file#$FOLDER_PATH/}" # Extract relative path of the file
        base_dir=$(dirname "$relative_path") # Get base directory
        filename=$(basename "$file")
        basefilename="${filename%.*}"

        # Process each specified size
        for size in "${SIZES[@]}"; do
            # Create corresponding subdirectory structure within the size-specific folder
            output_subfolder="$BASE_OUTPUT_FOLDER/$size/$base_dir"
            mkdir -p "$output_subfolder"
            
            if [[ "$size" == *"w" ]]; then # Width specified
                width=${size%w}
                echo "Converting $file to $width width JPEG in $output_subfolder/"
                sips --resampleWidth $width "$file" --setProperty format jpeg --out "$output_subfolder/$basefilename.jpg"
            elif [[ "$size" == *"h" ]]; then # Height specified
                height=${size%h}
                echo "Converting $file to $height height JPEG in $output_subfolder/"
                sips --resampleHeight $height "$file" --setProperty format jpeg --out "$output_subfolder/$basefilename.jpg"
            fi
            ((counter++))
        done
    fi
done < <(find "$FOLDER_PATH" -type f \( -iname "*" \))

if [ $counter -eq 0 ]; then
    echo "No image files found in the specified folder."
else
    echo "Processed $counter image files."
fi
echo "Conversion complete."

