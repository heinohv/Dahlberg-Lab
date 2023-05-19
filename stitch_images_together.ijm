//Settings:
Dialog.create("Script Settings");
Dialog.addCheckbox("Sitch folder path in script", 0);
Dialog.show();
path_in_sciprt = Dialog.getCheckbox();
scale = 0

//selecting directories
//enter the directory/path for a folder you want to save your combined images in
if (path_in_sciprt == 1) {
	dir = "<ENTER PATH HERE>"
}
//or it will be manually selected with this line
if (path_in_sciprt == 0) {
	dir = getDirectory("Select an empty folder you want images saved to");
}


//saving images into a folder for the script to access
number_to_join = getNumber("How many images do you want to join?", 0);
files_in_string = "";

for (i = 1; i < number_to_join+1; i++) {
	waitForUser("Select image "+i+"/"+number_to_join);
	title = getTitle();
	
	//Get the microns to pixel scale, and records so stitched image will maintain the scale
	getPixelSize(unit, pixelWidth, pixelHeight);
	scale = (1/pixelWidth);
	saveAs("Tiff", dir+i+".tif");
	close();
	
	//making a list of file names for the stitching plugin to use for directions
	index_as_string = d2s(i, 0);
	files_in_string += " " + index_as_string + ".tif";
	

}
print(files_in_string);

//runs the settings to stich images together
run("Grid/Collection stitching", "type=[Unknown position] order=[All files in directory] directory="+dir+" confirm_files output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]"+ files_in_string);
Property.set("CompositeProjection", "null");
Stack.setDisplayMode("grayscale");
//adding the scale in
run("Set Scale...", "distance="+scale+" known=1 unit=micron");
saveAs("Tiff", dir+title+"fused.tif");
