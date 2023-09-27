//This macro will have you select a folder full of images you want to measure/count the cilia in
//It will create a table with a filter column
//one filter will give you lenghts of the cilia, and the other will give you the count of the cilia
//filter example in python later: 
//cilia_count_filter = df["filter"] == "cilia_count" 
//cilia_count_df = df[cilia_count_filter]

//have the user select the folder with their max projected images of the cilia
max_dir = getDirectory("Choose the folder your uncropped max projections are");

//initialize a table
Table.create("cilia");
table_index = 0;


//loop to open each image from the folder with max projections
fileList = getFileList(max_dir);
for (file = 0; file < fileList.length; file++) {
	open(max_dir+fileList[file]);
	
	//record the real name, then hide the file name to reduce user bias
	real_title= getTitle();
	rename("hidden name");
	window_name = getTitle();
	
	//brighten the image and set it to the top left corner of the screen
	run("Enhance Contrast", "saturated=0.35");
	run("RGB Color");
	setLocation(0, 0);

	//reset cilia counter for this image
	cilia_count = 0;
	
	//start a while loop for the user to trace each cilia
	while_loop=1;
	while (while_loop==1) {
		setTool("polyline");
		waitForUser("trace a cilia\nif there are none, or you are finished\ntracing just press ok.");
		//check if there is a polyline
		is_there_a_line = selectionType();
	

		//when no cilia are outlined, close the image, record the cilia counted, and exit the while loop
		if (is_there_a_line == -1) {
			close(window_name);
			
			while_loop = 0;

			Table.set("image_name", table_index, real_title);
			Table.set("as_the_bird_flies", table_index, "none selected");
			Table.set("length", table_index, "none selected");
			Table.set("cilia_count", table_index, cilia_count);
			Table.set("filter", table_index, "cilia_count");
			table_index += 1;
		}

		//if there is a line, measure the length from start to end as the bird flies, measure the total length of all segments, then resume the while loop
		if (is_there_a_line == 6 ) {
			getSelectionCoordinates(xpoints, ypoints);
			length = 0;
			as_bird_flies = 0;
			
			//calculating the distance between the start point and end point of the cilia as the bird flies
			first_x = xpoints[0];
			last_x = xpoints[xpoints.length-1];
			first_y = ypoints[0];
			last_y = ypoints[ypoints.length-1];
				//Pythagorean theorem ((a^2+b^2)^0.5 = c))
			delta_x = Math.pow((first_x-last_x), 2);
			delta_y = Math.pow((first_y-last_y), 2);
			as_bird_flies = Math.pow((delta_x+delta_y),0.5);
			
			//calculated the length of the cilia
			for (i = 0; i < (xpoints.length-1); i++) {
				x1 = xpoints[i];
				x2 = xpoints[i+1];
				y1 = ypoints[i];
				y2 = ypoints[i+1];
				
				//Pythagorean theorem ((a^2+b^2)^0.5 = c))
				delta_x = Math.pow((x1-x2), 2);
				delta_y = Math.pow((y1-y2), 2);
				c = Math.pow((delta_x+delta_y),0.5);
				length += c;
			}
			//drawing the line on the image so there are no accidental repeats		
			setForegroundColor(225, 0, 0);
			run("Draw", "slice");
			
			//recording values in the table
			Table.set("image_name", table_index, real_title);
			Table.set("as_the_bird_flies", table_index, as_bird_flies);
			Table.set("length", table_index, length);
			Table.set("cilia_count", table_index, "not recorded here");
			Table.set("filter", table_index, "cilia_length");
			
			table_index += 1;
			cilia_count +=1;
			
			//clear selection so we don't get duplicates
			run("Select None");
		}
	}
	close(window_name);
}



