# R1a
This Directory Contain the Script which have been generated as by product of Research paper on R1a haplogroup



##### 

# ==============================================================================
bsp_overlay.R: Reads all Tracer-exported Bayesian skyline tables (tab-separated; columns time, mean, median, upper, lower; time in years) from the working folder and plots them together in one figure (median Ne as a line, lower-upper interval as a shaded band, log10 y-axis), saved as BSP_plot.pdf and BSP_plot.tiff. Requires the ggplot2 package (install.packages("ggplot2")). 

Keep this script in the same folder as the table files, and name each file name_table (the file name must end with "table"); "name" becomes the legend label, with underscores and hyphens turned into spaces. 
The maximum plotting time is found automatically from the data; for a shorter window, set xmax_manual (in thousand years, e.g. 15) in the settings block.

Script is available as BSP_plot.R
# ==============================================================================
