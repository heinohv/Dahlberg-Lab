//This script will save all open images to your selected directory
output_dir = getDirectory("Choose the folder to save your images to");

for (i = 1; i < nImages+1; i++) {
	selectImage(i);
	Property.set("CompositeProjection", "null");
	Stack.setDisplayMode("grayscale");
	title=getTitle();
	saveAs("Tiff", output_dir+title);
}

close("*");