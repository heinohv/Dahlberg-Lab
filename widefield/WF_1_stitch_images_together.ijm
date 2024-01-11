//open the images you want to process before running this script
//each time you run this script you can stitch together images (for when you were unable to capture all the worms in one frame)

//selecting directory to have intermediate images saved to (allows stitching program to call them)
dir = getDirectory("Select an empty folder this script can save intermediate images to");


number_to_join = getNumber("How many images do you want to join?", 0);
files_in_string = "";
for (i = 1; i < number_to_join+1; i++) {
	waitForUser("Select image "+i+"/"+number_to_join);
	title = getTitle();
	
	//Get the microns to pixel scale, and record it so the stitched image will maintain the scale
	getPixelSize(unit, pixelWidth, pixelHeight);
	scale = (1/pixelWidth);
	saveAs("Tiff", dir+i+".tif");
	close();
	
	//making a list of file names for the stitching plugin to use for directions
	index_as_string = d2s(i, 0);
	files_in_string += " " + index_as_string + ".tif";
}

//runs the settings to stich images together
run("Grid/Collection stitching", "type=[Unknown position] order=[All files in directory] directory="+dir+" confirm_files output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]"+ files_in_string);
Property.set("CompositeProjection", "null");
Stack.setDisplayMode("grayscale");

//correcting scale
run("Set Scale...", "distance="+scale+" known=1 unit="+unit);
rename(title+"_stitched");
