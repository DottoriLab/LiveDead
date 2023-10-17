# LiveDead

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.


Use in ImageJ (FIJI) using the .ijm language
- This macro counts live cells, dead cells and nuclei from fluorescence microscopy (usually has been stained with Calcein-AM, Propidium Iodide and hoechst 33342).
- It was applied to 3D Bioprints of sensory neurons. Hence, analysis of each z-stack was required.
- The macro is partitioned into three sections, optimizing the analysis workflow. This segmentation is designed to accommodate researchers working with extensive image datasets, offering breaks between processing stages for enhanced efficiency.
- Created by Marnie L. Maddock; 
- University of Wollongong, Australia;
- School of Medical, Indigenous and Health Sciences
- Stem Cells and Neural Modelling Lab (Dottori Group)
- mlm715@uowmail.edu.au; mmaddock@uow.edu.au; mdottori@uow.edu.au
- 10.5.2023

Instructions:
1. Drag and drop appropriate macro into FIJI
2. Click Run
3. Select Folder where your .TIF files are stored. NOTE, if you have .lif files, these will need to be saved as individual tifs. Follow instructions on: 
4. Open one image and note down which channel corresponds to nuclei, live cells, dead cells etc.
5. For these macros, it is set up for:
- Channel 1 = Nuclei stain
- Channel 2 = Live stain
- Channel 3 = Dead stain
6. If your images are in a different order, for example, your dead stain is channel 1 not 3
- Change code: 
`selectWindow("C3-" + title);`
To
`selectWindow("C1-" + title);`
7. Press Run
8. Select the folder where your TIF images are saved
9. A new folder called dead/nuclei/live_results will be created inside the input directory. Select this as your destination directory.
10. A duplicate of the original photo is present to help idenfity the threshold accuracy in segmenting cells. If the threshold is not adequate, for example the image is out of focus, you may delete slices that hinder accuracte results.
11. Press Apply 
12. Press OK
13. Counts will be saved to the selcted folder
14. Repeat for the other macros.
