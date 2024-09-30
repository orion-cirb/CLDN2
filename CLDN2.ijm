/////////////////////////////////////////////////////////////////
//      Authors Thomas Caille & Héloïse Monnet @ ORION-CIRB    //
//	            https://github.com/orion-cirb/CLDN2            //
/////////////////////////////////////////////////////////////////

// Hide images during macro execution
setBatchMode(true);

// Ask for input directory
inputDir = getDirectory("Please select a directory containing images to analyze");

// Create output directory
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
outDir = inputDir+"Results_"+year+"-"+month+"-"+(dayOfMonth+1)+"_"+hour+"-"+minute+"-"+second+File.separator();
if (!File.isDirectory(outDir)) {
	File.makeDirectory(outDir);
}

// Get all files in the input directory
list = getFileList(inputDir);

// Create a results file and write headers in it
fileResults = File.open(outDir + "results.csv");
print(fileResults,"Image name, Background noise, ROI ID, Area (µm2), Background-corrected mean intensity\n");

// Loop through all files with .TIF extension 
for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".nd")) {
    	// Open image
    	run("Bio-Formats Importer", "open=["+inputDir + list[i]+"] autoscale color_mode=Default specify_range split_channels view=Hyperstack stack_order=XYCZT c_begin=2 c_end=2 c_step=1");
    	rename("rawImage");
    	
    	// Compute image background noise as the median intensity of the stack min projection
    	run("Z Project...", "projection=[Min Intensity]");
    	rename("minIntensity");
    	run("Set Measurements...", "median redirect=None decimal=3");
    	List.setMeasurements();
    	bgNoise = List.getValue("Median");
    	List.clear();
    	
    	// Remove background noise from the stack average projection to normalize intensity measurements
    	selectImage("rawImage");
		run("Z Project...", "projection=[Average Intensity]");
    	rename("avgIntensity");
    	run("Subtract...", "value="+bgNoise);
    	
    	// Segment object of interest
    	// Stack sum projection to enhance object signal
    	selectImage("rawImage");
    	run("Z Project...", "projection=[Sum Slices]");
    	rename("sumIntensity");
    	// Background subtraction to get rid of unwanted signal around object
    	run("Subtract Background...", "rolling=50 sliding");
    	// Median filter to smooth image
    	run("Median...", "radius=20");
    	// Triangle automatic thresholding to segment object
		setAutoThreshold("Triangle dark no-reset");
		setOption("BlackBackground", true);
		run("Convert to Mask");
		// Fill holes and median filter to improve segmentation result
		run("Fill Holes");
		run("Median...", "radius=2");

		// Measure and save parameters for each segmented object in results file
		run("Set Measurements...", "area mean redirect=avgIntensity decimal=3");
		run("Analyze Particles...", "size=3000-35000 circularity=0.00-0.25 display clear add");
		for (r = 0; r < roiManager("count"); r++) {
			area = getResult("Area", r);
			mean = getResult("Mean", r);
			print(fileResults, list[i]+","+bgNoise+","+(r+1)+","+area+","+mean+"\n");
		}
		
		// Save stack sum projection with segmented objects overlays
		selectImage("avgIntensity");
		run("From ROI Manager");
		saveAs("tif", outDir + list[i]);
	
		// Close all windows
		close("*");
		close("Results");
    }
}

setBatchMode(false);
