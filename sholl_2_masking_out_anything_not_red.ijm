counter = 0;

dir = "C:/Users/Heino/Desktop/shol_traced/"
output = "C:/Users/heino/Desktop/neuron_only/"
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
				only_red();
				masked_name = getTitle();
				saveAs("Tiff", output+masked_name);
				close("*");

			}
		}
	}
}


function only_red() { 
// if a pixel is not red, make it black (0 signal)
height = getHeight();
width = getWidth();
title = getTitle();

for (x = 0; x < width; x++) {
	for (y = 0; y < height; y++) {
		pixel_value = getPixel(x, y);
		if (pixel_value != -65536) {	
			setPixel(x, y, -1);
		}
	}
}
run("Convert to Mask");
}
