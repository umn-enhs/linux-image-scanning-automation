#!/bin/bash

ocrapp=$1
scan="$2"
tempbase=`mktemp /tmp/ocr-XXXXXX`
ocr_temp="${tempbase}.tif"
pnm_temp="${tempbase}.pnm"

if [ "$3" != "" ]; then
    ocr_temp="$3"
fi

if [ "$4" != "" ]; then
    pnm_temp="$3"
fi

rm -f $tempbase

function ocr {
    local scan_app=$1

    image_folder=`dirname $1`
    pushd ${image_folder} > /dev/null
        image_folder=`pwd`
    popd > /dev/null

    if [ ! -d ${image_folder}/${scan_app} ]; then
        mkdir ${image_folder}/${scan_app}
    fi

    ocr_folder=${image_folder}/${scan_app}

    if [ ! -e ${ocr_folder}/$textbase.txt ]; then
        # Make this step optional for recursive calls
    
        if [ "${scan_app}" == "tesseract" ]; then
			echo -n "OCR-ing $scan using tesseract..."
			nice tesseract ${ocr_temp} ${ocr_folder}/${textbase} -l eng
		fi

	    if [ "${scan_app}" == "gocr" ]; then
			echo "OCR-ing $scan using GOCR/JOCR..."
			nice gocr -i ${pnm_temp} -f ASCII > ${ocr_folder}/${textbase}.txt
        fi

		if [ "${scan_app}" == "ocrad" ]; then
			echo "OCR-ing $scan using OCRAD..."
			nice ocrad --charset=ascii -o ${ocr_folder}/${textbase}.txt ${pnm_temp}
	    fi
		
	fi
}


if [ "${ocrapp}" == "" ]; then
    echo "You must specify an OCR application"
    echo "usage:"
    echo "  $0 [gocr | ocrad | tesseract | all] <imagename.tif> "
    echo ""
elif [ "${#scan}" == "0" ]; then
    echo "You must specify an file name"
    echo "usage:"
    echo "  $0 [gocr | ocrad | tesseract | all] <imagename.tif> "
    echo ""
else
    if [ -f ${scan} ]; then
    
        image_folder=`dirname ${scan}`
		textbase=`basename $scan .tif`
        
        pushd ${image_folder} > /dev/null
            image_folder=`pwd`
        popd > /dev/null
        
        
        echo "Resampling for better OCR accuracy"
        # Downsample image for faster, more accurate processing
        if [ ! -f ${ocr_temp} ]; then
            echo "  Converting to RGB..."
            tiff2rgba ${scan} ${ocr_temp}
            echo "  Scaling to 400 DPI..."
            nice mogrify -adaptive-blur 4x4 -resample 400x400 -shave 100x100 -type Bilevel ${ocr_temp}  
        fi
     
        if [ "${scan_app}" != "tesseract" ] && [ ! -f ${pnm_temp} ]; then
            echo "  Converting to PNM format..."
            #convert ${ocr_temp} -format "pnm" ${pnm_temp}
            nice gm convert ${ocr_temp} -depth 8 pnm:${pnm_temp}
        fi

		pushd ${image_folder} > /dev/null

        if [ "${ocrapp}" == "all" ]; then
            echo "calling OCR, All"
            # Disabling tesseract for now...  too buggy.
            #ocr tesseract
            ocr ocrad
            ocr gocr
        else
            echo "calling OCR, $ocrapp"
            ocr $ocrapp
        fi        
        
		popd > /dev/null    

        # Cleanup
        if [ -f "${pnm_temp}" ]; then
		    rm -f ${pnm_temp}
	    fi
		rm -f ${ocr_temp}
        
	else
	    echo "Invalid file name: $scan"
	fi
fi

