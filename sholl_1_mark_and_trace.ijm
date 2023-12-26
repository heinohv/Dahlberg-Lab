
counter = 0;

dir = "C:/Users/Heino/Desktop/thesis_data/neuronshape/"
output = "C:/Users/Heino/Desktop/SHOL_OUTPUT/"

//initialize a table
Table.create("cilia");
table_index = 0;

processDirectory(dir);
function processDirectory(directory) {
    list = getFileList(directory);
    for (i = 0; i < list.length; i++) {
        item = directory + list[i];
        if (File.isDirectory(item)) {
            processDirectory(item + "/");
        } else {
            if (endsWith(list[i], ".tif") || endsWith(list[i], ".jpg") || endsWith(list[i], ".png")) {
                image_path = item;
                open(item);
                //split the image up and mask it
				split_and_mask();
				
				//Mark center as ROI and save to file name
				ROI_to_title();
				traced_name = getTitle();
				//trace the cilia
				draw_red();
				
				//save it
				saveAs("Tiff", output+traced_name);
				close("*");

		}
	}
}
}

function split_and_mask() { 
	run("Split Channels");
	window_names = newArray();
	for (q = 1; q < nImages+1; q++) {
		selectImage(q);
		title = getTitle();
		channel = substring(title, 0, 2);
		Array.concat(window_names,title);
		if (channel == "C1") {
			photon_image = title;
		}
		if (channel == "C2") {
			cuticle_mask = title;
		}
		if (channel == "C3") {
			run("Invert", "stack");
			neuron_mask = title;
		}
		if (channel == "C4") {
			close();
		}
	
	}

	//subtract cuticle mask from the raw image
	imageCalculator("Subtract create stack", photon_image, neuron_mask);
	calc_image = getTitle();
	run("Z Project...", "projection=[Max Intensity]");
	no_cuticle = getTitle();
	run("Enhance Contrast", "saturated=3.5");
	run("Maximize");
	setLocation(1000, 0);
	run("RGB Color");

	selectWindow(photon_image);
	run("Z Project...", "projection=[Max Intensity]");
	run("Enhance Contrast", "saturated=3.5");
	run("Maximize");
	setLocation(0, 0);
	run("RGB Color");

	//close windows that aren't helpful for tracing
	close(cuticle_mask);
	close(neuron_mask);
	close(photon_image);
	close(calc_image);
	
	    
	}



function ROI_to_title() { 
	// Set a point for the ROI, and save it into the file name
	setTool("point");
	waitForUser("Place a point on the center");
	title = getTitle();
	getSelectionCoordinates(xpoints, ypoints);
	X_CORD = xpoints[0];
	Y_CORD = ypoints[0];
	//set these to be strings 3 digits long (10 -> 010)
	X_CORD = make_3_digits(X_CORD);
	Y_CORD = make_3_digits(Y_CORD);
	
	//save the file name
	rename(title+"_XROI_" + X_CORD+"_YROI_"+Y_CORD);

}

function make_3_digits(numbers_input) { 
	//convert numbers to a string and check the length of it
	numbers_input = ""+numbers_input;
	len = lengthOf(numbers_input);
	if (len==1) {
		numbers_input = "00" + numbers_input;
	}
	if (len=="2") {
		numbers_input = "0" + numbers_input;
	}
	return numbers_input;
}


function draw_red() { 
// function description

height = getHeight();
width = getWidth();
title = getTitle();

run("8-bit");
run("RGB Color");
setTool("Paintbrush Tool");
setForegroundColor(255, 0, 0);
waitForUser("trace the cilia for the 1st neuron");
}



