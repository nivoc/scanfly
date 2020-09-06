#!/bin/bash

OUT_DIR=/app/scans
TMP_DIR=`mktemp -d`
FILE_NAME=scan_`date +%Y-%m-%d-%H%M%S`
LANGUAGE="deu"                 # the tesseract language - ensure you installed it

echo 'scanning...'
scanimage --resolution 300 \
	  --batch="$TMP_DIR/scan_%03d.tif" \
          --format=tiff \
	  --device="fujitsu:ScanSnap iX500:12691" \
          --mode Gray \
          --source 'ADF Duplex' \
	  --swdeskew="no" \
	  --swskip 15 \
	  --ald="yes" \
	  --brightness 13 \
	  --page-height 297 \
	  --page-width 210 \
	  --buffermode="off"

NUM_FILES=`ls -1q $TMP_DIR | wc -l`
echo "NUM_FILES $NUM_FILES DIR $TMP_DIR"
if [ $NUM_FILES -eq 0 ]
then
	echo "Nothing to scan"
else
	echo "Output saved in $TMP_DIR/scan*.pnm"
	
	cd $TMP_DIR
	tiffcp scan*.tif combined.tif

	echo 'doing OCR...'  
	ocrmypdf --rotate-pages --deskew -l deu combined.tif ocr.pdf

	# create PDF
	echo 'creating PDF...'  
	cp ocr.pdf $OUT_DIR/$FILE_NAME.pdf
	# aws s3 cp ocr.pdf s3://scan-dhnne6h/$FILE_NAME.pdf --endpoint-url=https://s3.eu-central-1.wasabisys.com >> /home/matthias/log.file 2>&1
	# aws s3 cp ocr.pdf s3://scan-todo-jshennn23/$FILE_NAME.pdf >> /home/matthias/log.file 2>&1
	# whoami >> /home/matthias/whoami
fi

rm -rf $TMP_DIR

