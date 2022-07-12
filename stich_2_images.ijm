//enter the directory/path for a folder you want to use under bellow

dir = "C:/Users/heino/Desktop/stitch/"

waitForUser("Select the first image");
title1 = getTitle();
saveAs("Tiff", dir+"1.tif");
close();

waitForUser("Select the second image");
title2 = getTitle();
saveAs("Tiff", dir+"2.tif");
close();

run("Grid/Collection stitching", "type=[Unknown position] order=[All files in directory] directory="+dir+" confirm_files output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display] 1.tif 2.tif");
Property.set("CompositeProjection", "null");
Stack.setDisplayMode("grayscale");
saveAs("Tiff", dir+title1+title2+"fused.tif");
