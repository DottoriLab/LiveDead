//********
//This work is licensed under a Creative Commons Attribution 4.0 International License.
// Use in ImageJ (FIJI) using the .ijm language
// This macro counts dead cells from fluorescence microscopy. This macro assumes that channel 3 is the dead cells channel. Please change this if it is in a different channel.
// Created by Marnie L. Maddock; 
// University of Wollongong, Australia;
// School of Medical, Indigenous and Health Sciences
// Stem Cells and Neural Modelling Lab (Dottori Group)
// mlm715@uowmail.edu.au; mmaddock@uow.edu.au; mdottori@uow.edu.au
// LinkedIn: Marnie Maddock; Twitter @marniemaddock
// 10.5.2023
//********

// Choose source directory where .tif files are present. A results directory is made in the chosen directory, choose this for saving your results.
// If you have files that are .lif, that have multiple series within them, please use the macro below FIRST:
// Lif_to_tif.ijm
// Found at:
// https://github.com/MarnieMaddock/Lif_to_Tif
// To open all series in the .lif file, and save them individually to a folder as .TIFF.
// This macro will not work on .lif files that have mutliple images inside the one file.


dir1 = getDirectory("Choose Source Directory ");
resultsDir = dir1+"Dead_results/";
File.makeDirectory(resultsDir);
dir2 = getDirectory("Choose Destination Directory ");

// Get a list of files in the source directory and process each file
list = getFileList(dir1);
processFolder(dir1);
function processFolder(dir1){
	// Recursively process subdirectories and individual files
	list = getFileList(dir1);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(dir1 + File.separator + list[i]))
			processFolder(dir1 + File.separator + list[i]);
		if(endsWith(list[i], ".tif"))
			processFile(dir1, dir2, list[i]);
	}
}	 

function processFile(dir1, dir2, file){
			// Open the current TIFF file
			open(dir1 + File.separator + file);
			
			
		// Split channels and rename
		// Check that it is labelling the correct channels	
		// Here it is assuming channel 2 stained live cells .g. Calcein-AM, channel 3 is dead cells, channel 1 is nuclei
		// Change "C2-" to which ever channel is appropriate etc  
		title = getTitle();
		run("Split Channels");
		// Rename channel 2 as live
		selectWindow("C2-" + title);
		rename("live");
		// Rename channel 3 as dead
		selectWindow("C3-" + title);
		rename("dead");
		//Rename channel 1 as nuclei
		selectWindow("C1-" + title);
		rename("nuclei");
		
		//Apply pre-processing filters and threshold live cells
		selectWindow("dead");
		run("Duplicate...", "duplicate");
		rename("duplicate");
		selectWindow("dead");
		//Guassian blur
		run("Gaussian Blur...", "sigma=2 stack");
		//Set your threshold
		run("Threshold...");
		waitForUser("Adjust threshold, press apply, and set the method. Press ok on this pop-up when the threshold has been set. Delete any unwanted slices here using Image > Stacks > Delete Slice ");
		selectWindow("dead");
		run("Make Binary", "method=Default background=Dark calculate black");
		//run("Auto Local Threshold", "method=Phansalkar radius=8 parameter_1=0 parameter_2=0 white stack");
		run("Fill Holes", "stack");
		run("Watershed", "stack");
		run("Stack to Images"); //Makes z-slices individual images
		
		
		// Run analyze particles to count cells. Change size = 0.5-Infinity if your cells are larger/smaller.
		for(z = nImages; z > 0; z--){
			if(is("binary")){
		      // Analyze particles
		     	name = getTitle();
					rename(name + "_" + title);
					run("Analyze Particles...", "size=0.50-Infinity show=[Overlay Masks] display clear summarize overlay add");
					selectWindow("Summary");
					saveAs("Results", dir2 + "Dead_Summary_" + z + "_" + title + ".csv");
					close("Dead_Summary_" + z + "_" + title + ".csv");
					selectWindow("Results");
					saveAs("Results", dir2  + name +"_" + z + "_" + title + ".csv"); 
		    }
		    close();
		}
		print("Processing: " + dir1 + File.separator + file);
			print("Saving to: " + dir2);
			run("Close");
}
run("Close All");
close("Summary");
close("Results");
print("Done");
exit("Done");

// Happy Counting!