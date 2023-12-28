#!/bin/bash

# Safari Books Online EPUB to PDF Converter Script

# Define Safari Books Online book IDs
book_ids=("9781789539974" "9781803230030" "9781484292280" "9781484286739" "9781484212257" "9781805128694" "9781484282519" "9781838555702" "9781788992909" "9781484274774" "9798868800351" "9781803234021" "9781800562479" "9781484261316" "9781801816786" "9781838983031" "9781804613276" "9781803238951" "9780134849775" "9781492039273" "9781617293566")

# Define the output directory on the desktop
output_directory="$HOME/Desktop/safaribooks/Books"

# Function to convert EPUB to PDF
convert_epub_to_pdf() {
    book_id=$1
    book_title=$2
    latest_directory=$3
    book_path="$output_directory/$latest_directory"
    echo "$book_path"
    epub_file="$book_path/$book_id.epub"
    pdf_file="$HOME/Desktop/books/$book_title.pdf"

    echo "Converting $book_id to PDF..."

    # Check if EPUB file exists
    if [ -f "$epub_file" ]; then
        # Convert EPUB to PDF using ebook-convert
        ebook-convert "$epub_file" "$pdf_file"
        echo "Conversion completed. PDF saved to: $pdf_file"
    else
        echo "Error: EPUB file not found for $book_id. Please check the download logs."
    fi
}

# Loop through each book ID and perform the conversion
for book_id in "${book_ids[@]}"; do
    echo "Processing book ID: $book_id"

    # Run the Python script to download the book and capture the logs
    download_logs=$(python3 safaribooks.py "$book_id")

    echo "$download_logs"

    if [[ $download_logs == *"Retrieving book info..."* ]]; then
       latest_directory=$(ls -lt $output_directory --time=creation | awk '/^d/ {print substr($0, index($0,$9))}' | head -n 1)

       book_title=$(echo "$latest_directory" | sed -E 's/\(.+//; s/_/ /g; s/ $//')
       book_id=$(echo "$latest_directory" | awk -F'[()]' '{print $2}')

       echo "Title: $book_title"
       echo "Book Id: $book_id"

       # Call the function to convert EPUB to PDF
       convert_epub_to_pdf "$book_id" "$book_title" "$latest_directory"
    else
      echo "book not found"
    fi

done

# Script execution completed
echo "All books processed. Exiting script."

