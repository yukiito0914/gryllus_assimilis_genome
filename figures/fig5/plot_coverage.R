library(dplyr)
library(ggplot2)

# Load the data
Gass_cov <- read.csv("/home/yuki_ito/work2/Tasks/mosdepth/Jamaican_v1.1/Gass_cov.regions.bed", header = FALSE, sep = "\t")

# Create a vector of scaffold names
scaffolds <- paste0("Super-Scaffold_", 1:15)  # Original scaffold names
new_labels <- c("chrX", "chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", 
                "chr9", "chr10", "chr11", "chr12", "chr13", "chr14")  # New scaffold labels
new_order <- c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", 
               "chr10", "chr11", "chr12", "chr13", "chr14", "chrX")  # Desired order of labels

# Filter rows corresponding to specific scaffolds
Gass_cov_filtered <- filter(Gass_cov, V1 %in% scaffolds)

# Update the V1 column with new labels and set the order
Gass_cov_filtered$V1 <- factor(Gass_cov_filtered$V1, 
                               levels = scaffolds,  # Original scaffold order
                               labels = new_labels)  # Replace with new labels
Gass_cov_filtered$V1 <- factor(Gass_cov_filtered$V1, levels = new_order)  # Set the desired order

# Remove outliers using the interquartile range (IQR)
Gass_cov_filtered <- Gass_cov_filtered %>%
  group_by(V1) %>%
  mutate(
    Q1 = quantile(V4, 0.25),  # First quartile
    Q3 = quantile(V4, 0.75),  # Third quartile
    IQR = Q3 - Q1  # Interquartile range
  ) %>%
  filter(V4 >= (Q1 - 1.5 * IQR) & V4 <= (Q3 + 1.5 * IQR)) %>%  # Keep values within the IQR range
  ungroup() %>%
  select(-Q1, -Q3, -IQR)  # Remove temporary columns for quartiles and IQR

# Get the maximum value after filtering outliers
max_value <- max(Gass_cov_filtered$V4)

# Create a boxplot
plot <- ggplot(Gass_cov_filtered, aes(x = V1, y = V4)) +
  geom_boxplot(width = 0.7, lwd = 0.5, color = "black", fill = NA, outlier.shape = NA) +  # Customize boxplot appearance
  ylim(0, max_value) +  # Set Y-axis range from 0 to the maximum value
  labs(x = "Chromosomes", y = "Coverage") +  # Add axis labels
  theme(
    text = element_text(family = "Helvetica", size = 20),  # Set font and size
    axis.text = element_text(size = 20, face = "bold", colour = "black"),  # Customize axis text
    axis.title = element_text(size = 20, face = "bold", colour = "black"),  # Customize axis titles
    axis.line = element_line(linewidth = 1.2, colour = "black"),  # Customize axis lines
    panel.background = element_blank(),  # Remove background
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate X-axis labels
    legend.position = "none"  # Hide legend
  )

# Save the plot in SVG format
ggsave("/home/yuki_ito/work2/Tasks/mosdepth/Jamaican_v1.1/scaffold_cov_boxplot_v2.svg", plot = plot, device = "svg")

# Save the plot in PNG format
ggsave("/home/yuki_ito/work2/Tasks/mosdepth/Jamaican_v1.1/scaffold_cov_boxplot_v2.png", plot = plot, device = "png")

# Save the plot in PDF format
ggsave("/home/yuki_ito/work2/Tasks/mosdepth/Jamaican_v1.1/scaffold_cov_boxplot_v2.pdf", plot = plot, device = "pdf")
