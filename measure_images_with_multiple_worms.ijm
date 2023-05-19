//Prior to this, run 'stitch_2_images script to combine any images as needed

//settings to change:
//fluor channel 
fluor_channel = 2
//DIC channel
dic_channel = 1

//instance table, variable to keep loop going, and table index
Table.create("worm_widefield_data");
continue_loop = 1
table_index = 0
while (continue_loop>0) {
	setTool("polygon");
	waitForUser("Draw an outline around the worm you want to measure");
	file_name = getTitle();
	
	//getting ROI coords so stuff can be rerun easier without retracing
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
	
	Table.set("worm_number", table_index, table_index);
	Table.set("file_name", table_index, file_name);
	Table.set("mean",  table_index, worm_mean);
	Table.set("area",  table_index, worm_area);
	Table.set("max",  table_index, max);
	Table.set("signal (area*mean)", table_index, worm_signal);
	Table.set("ROI x cords", table_index, xpoint_list);
	Table.set("ROI y cords", table_index, ypoint_list);
	
	//marking worm just measured (only on the DIC channel)
	Stack.setChannel(dic_channel)
	setForegroundColor(0, 0, 0);
	run("Draw", "slice");

	Stack.setChannel(fluor_channel);
	//measure the background near a worm, and record a normalized worm signal value
	setTool("rectangle");
	waitForUser("Select an area to use as background");
	getStatistics(area, mean, min, max, std, histogram);
	background_mean_signal = mean;
	Table.set("mean background signal", table_index, background_mean_signal);
	norm_worm_signal = (worm_signal)-(worm_area*background_mean_signal);
	Table.set("norm worm signal", table_index, norm_worm_signal);
	
	table_index += 1;
	Stack.setChannel(dic_channel)
	continue_loop = getNumber("Change value to 0 once you have measured all images", 1);	

	
}
