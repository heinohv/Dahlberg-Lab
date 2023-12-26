counter = 0;
dir = getDirectory("Choose a Directory");
processDirectory(dir);
function processDirectory(directory) {
    list = getFileList(directory);
    for (i = 0; i < list.length; i++) {
        item = directory + list[i];
        if (File.isDirectory(item)) {
            processDirectory(item + "/");
        } else {
            if (endsWith(list[i], ".tif") || endsWith(list[i], ".jpg") || endsWith(list[i], ".png")) {
                open(item);
				split_and_mask();
				counter++;
            }
        }
    }
}

function split_and_mask() { 
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
			close();
		}
		if (channel == "C3") {
			close();
		}
		if (channel == "C4") {
			close();
		}
	
	}
	
	selectWindow(photon_image);
	setLocation(1300,0);
	run("Enhance Contrast", "saturated=0.35");
	run("Z Project...", "projection=[Max Intensity]");
	run("Enhance Contrast", "saturated=0.5");
	setLocation(0, 0);

	selectWindow(photon_image);
	run("Animation Options...", "speed=4");
	doCommand("Start Animation [\\]");
	
	//have the user characterize ODR-10::GFP loaction
	odr_10_GFP_location = newArray("cillia and cell body","cilia only", "none", "cell body only");
	
	Dialog.create("ODR-10::GFP location");
	Dialog.addChoice("Threshold method", odr_10_GFP_location, odr_10_GFP_location[0]);
	Dialog.show();
	
	odr_10_gfp_location_to_record = Dialog.getChoice();

	//recording the location
	Table.set("file_name", counter, photon_image);
	Table.set("path", counter, directory + item);
	Table.set("location", counter, odr_10_gfp_location_to_record);
	close("*");
}



