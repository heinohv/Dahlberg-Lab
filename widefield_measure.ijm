//waitForUser("Prior to this, run 'stitch_2_images script to combine any images as needed.");
//this program assumes channel 2 is fluorescent channel (that we want to measure)
Table.create("worm_widefield_data");

//directory where images with the measurement outline can be saved 
dir = "C:/Users/heino/Desktop/outline/" 

worms_left = 1
worm_number = 0
while (worms_left>0) {
	setTool("polygon");
	waitForUser("Draw an outline around the worm you want to measure");
	file_name = getTitle();
	
	//chnage channel to fluorescence to measure it
	Stack.setChannel(2)
	
	//take information from within the polygon, and record it in a table
	getStatistics(area, mean, min, max, std, histogram);
	getSelectionCoordinates(x_cords, y_cords);
	signal = area * mean;
	area = area;
	mean = mean;
	max = max;
	Table.set("worm_number", worm_number, worm_number);
	Table.set("File_name", worm_number, file_name);
	Table.set("Total signal", worm_number, signal);
	Table.set("mean",  worm_number, mean);
	Table.set("area",  worm_number, area);
	Table.set("max",  worm_number, max);
	//Table.set("selection x_cords",  worm_number, x_cords);
	//Table.set("selection y_cords",  worm_number, y_cords);
	worm_number += 1;
	worms_left = getNumber("Change value to 0 once you have measured all worms", 1);	
	
	// this block of code will save an image with the outline of the area you selected to measure
	setForegroundColor(0, 255, 255);
	run("Draw", "slice");
	saveAs("Tiff", dir+file_name+"_outline_worm_" + worm_number+".tif");
	
	//change channel back to DIC
	Stack.setChannel(1)
}
