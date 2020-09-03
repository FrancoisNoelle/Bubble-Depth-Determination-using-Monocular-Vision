# Bubble-Depth-Determination-using-Monocular-Vision
Intructions For Bubble Depth Application:

1. Copy images of bubbles as well as a image of the calibration rod into the application folder, which you should set as your workspace.
2. Make sure the calibration rod is named "pole" in the folder.
3. The secondary calibration image required is assigned to the variable "knowndepth" in code. Assign the name of a image of a bubble/bubbles of known depth to this variable.     
   In the image folder images of various bubbles at known depth can be found. Ten images at each depth are contained in this folder. The images are named "H#.0#", where the first number denotes the hole (depth) bubbles were released from
   and the second denotes the sample number at that depth. H1 is 1.5 cm deep in the BCR, H2 is 2.5 cm deep in the BCR, H3 i 3.5 cm deep in the BCR. Therefore in increments of 1 cm from the first hole. 
4. When choosing a bubble calibration image, it is better to choose a image of bubbles that at deeper depth, since this is where the method is most accurate. 
5. The final image name then needs to be assigned in the section "Analyse Bubbles", which is the name of the image in which you want to determine the bubble depth. Any of the bubble images in the image folder 
   can be used. 
6. Once the chosen image names are assined to the variables the code can be run. 
7. Output "Depth" displays the depth in cm of the various analysed bubbles in the image. "NrBubs" displays the number of bubbles that were analysed. 
