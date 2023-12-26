counter = 0;

dir = getDirectory("Choose a Directory");
    
// Call the function to process the directory and its subdirectories
processDirectory(dir);
    
// Function to process a directory and its subdirectories
function processDirectory(directory) {
    list = getFileList(directory);
    for (i = 0; i < list.length; i++) {
        item = directory + list[i];
        if (File.isDirectory(item)) {
            processDirectory(item + "/");
        } else {
            if (endsWith(list[i], ".tif") || endsWith(list[i], ".jpg") || endsWith(list[i], ".png")) {
                open(item);
                print(counter);
				split_and_mask();
				counter++;
            }
        }
    }
}

function split_and_mask() { 
// split the z stack into 3 images
//one max projection of the raw image
//one stack of raw only where the neuron mask is
//one stack of raw minus the cutcile mask pixels
	run("Split Channels");
	window_names = newArray();
	for (i = 1; i < nImages+1; i++) {
		selectImage(i);
		title = getTitle();
		print(title);
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
		//get an image of just neuron, and no cuticle
	
	}
	
	selectWindow(photon_image);
	run("Z Project...", "projection=[Max Intensity]");
	run("Enhance Contrast", "saturated=0.35");
	setLocation(0, 0);

	imageCalculator("Subtract create stack", photon_image, neuron_mask);
	neuron_only = getTitle();
	setLocation(512, 0);
	
	imageCalculator("Subtract create stack", photon_image, cuticle_mask);
	no_cuticle = getTitle();
	setLocation(0, 512);
	
	close(neuron_mask);
	close(cuticle_mask);
	close(photon_image);

	//measure the neuron
	setTool("polygon");
	waitForUser("Outline the neuron");

	//recording the photon count for neuron only stack
	getSelectionCoordinates(xpoints, ypoints);
	selectWindow(neuron_only);
	makeSelection("polygon", xpoints, ypoints);
	total_photons = 0;
	for (i = 1; i <= nSlices; i++) {
	    setSlice(i);
	    getStatistics(area, mean, min, max, std, histogram);
	    total_signal = area*mean;
	    total_photons += total_signal;   
	}
	
	Table.set("file_name", counter, photon_image);
	Table.set("path", counter, directory + item);
	Table.set("neuron_only_photon_total", counter, total_photons);
	close("*");
}



