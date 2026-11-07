## To run the Script, keep the file in _table, files 


setwd("C:/Users/shail/OneDrive/Documents/Analysis/RScript/")
library(readr)  # if not installed, install first
library(readxl)
library(ggplot2)

X<- list.files(path= ".", pattern = "table$")
Y<- length(X)

cat("There are:", Y, "files\n")

labels<- basename(X)
labels<- sub("table$", "", labels)
labels<- gsub("[-_]+", " ", labels)

set.seed(42)  # same color for repetitive runs
cols <- if (Y > 0) {
  sample(grDevices::hcl.colors(Y, palette = "Dynamic"))
} else {
  character(0)
}

sets <- list()


for (i in seq_along(X)){
  Data<- read.table(X[i], skip= 1, sep= "\t", header = TRUE)
  
  sets[[i]]<- list(
    d = Data,
    lab= labels[i], 
    col= cols[i]
  )
}

#find the max time

MAX <- max(sets[[1]]$d$time)

for (i in seq_along(X)) {
  if (max(sets[[i]]$d$time) > MAX) {
    MAX <- max(sets[[i]]$d$time)    # only runs when a bigger value is found
  }
}

MAX<- MAX / 1000
paste0("Maximum timeline is: ", MAX)
print("Please change code, if you want to custimize it")

## Now lets turn into ggplot suitable data
all_bsp <- do.call(rbind, lapply(sets, function(s) {
  data.frame(dataset = s$lab, s$d)       
}))

all_bsp$dataset <- factor(all_bsp$dataset, levels = labels)  # fixes legend order
all_bsp$kya     <- all_bsp$time / 1000                       # thousand years

pal <- setNames(cols, labels)            
head(all_bsp); table(all_bsp$dataset)    # check it looks right


plot_df <- subset(all_bsp, kya <= MAX)

# lets plot now

p_plot <- ggplot(plot_df, aes(x = kya, colour = dataset, fill = dataset)) +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.15, colour = NA) +
  geom_line(aes(y = median), linewidth = 1.1) +
  scale_colour_manual(values = pal) +
  scale_fill_manual(values = pal) +
  scale_y_log10(breaks = 10^(2:7),
                labels = scales::label_math(10^.x, format = log10)) +
  coord_cartesian(xlim = c(0, MAX), ylim = c(1e2, 1e7), expand = FALSE) +
  labs(x = "Time (thousand years ago)", y = "Effective population size (Ne)",
       title = paste0(" ")) +
  theme_classic(base_size = 14) +
  theme(legend.position = "top", legend.title = element_blank())

p_plot


ggsave("BSP_plot.pdf",  p_plot, width = 8, height = 6)
ggsave("BSP_plot.tiff", p_plot, width = 8, height = 6, dpi = 600,
       compression = "lzw")
