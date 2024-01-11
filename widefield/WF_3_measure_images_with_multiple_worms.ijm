//This script is to measure signal of the worms you imaged
//Check that the following settings match your image:
//DIC channel
dic_channel = 1
//fluor channel 
fluor_channel = 2


//select directory containing images you want to process (2 channels, tiff)
directory = getDirectory("Choose the folderthat contains only the images you want to process");
filelist = getFileList(directory);

//instance table and table index
Table.create("worm_widefield_data");
table_index = 0


//open and process one image at a time
for (j = 0; j < lengthOf(filelist); j++) {
	open(directory+filelist[j]);
    continue_loop = 1;
    
    //ask the user to select an area of background, and record the signal
	Stack.setChannel(fluor_channel);
	setTool("rectangle");
	waitForUser("Select an area to use as background");
	getStatistics(area, mean, min, max, std, histogram);
	background_mean_signal = mean;
	Stack.setChannel(dic_channel)
	
	//have the user outline one worm at a time
	while (continue_loop>0) {
		setTool("polygon");
		waitForUser("Draw an outline around the worm you want to measure");
		file_name = getTitle();
		
		//getting ROI coords so stuff can be rerun easier without retracing (this shouldn't need to be done but it's a backup)
		Roi.getCoordinates(xpoints, ypoints);
		xpoint_list = "";
		for (i = 0; i < xpoints.length; i++) {
			xpoint_list = xpoint_list + xpoints[i];
			xpoint_list = xpoint_list + ", ";
		}
		ypoint_list = "";
		for (i = 0; i < xpoints.length; i++) {
			ypoint_list = ypoint_list + ypoints[i];
			ypoint_list = ypoint_list + ", ";
		}
	
		//chnage channel to fluorescence and measure within polygon
		Stack.setChannel(fluor_channel)
		getStatistics(worm_area, worm_mean, min, max, std, histogram);
		worm_signal = worm_area * worm_mean;
		
		//record data into the table	
		Table.set("worm_number", table_index, table_index);
		Table.set("file_name", table_index, file_name);
		Table.set("mean",  table_index, worm_mean);
		Table.set("area",  table_index, worm_area);
		Table.set("max",  table_index, max);
		Table.set("signal (area*mean)", table_index, worm_signal);
		Table.set("ROI x cords", table_index, xpoint_list);
		Table.set("ROI y cords", table_index, ypoint_list);
		
		//recording the background value for this image and the signal of the worm minus the background
		Table.set("mean background signal", table_index, background_mean_signal);
		worm_signal_minus_background = (worm_signal)-(worm_area*background_mean_signal);
		Table.set("worm signal minus background", table_index, worm_signal_minus_background);
		table_index += 1;
		
		
		//marking worm just measured (only on the DIC channel)
		Stack.setChannel(dic_channel)
		setForegroundColor(0, 0, 0);
		run("Draw", "slice");
	
		//Return to DIC channel and ask user if they have more worms to measure
		Stack.setChannel(dic_channel)
		continue_loop = getNumber("Change value to 0 once you have measured all worms", 1);	
		if (continue_loop==0) {
			close(file_name);
			}
	}
}








