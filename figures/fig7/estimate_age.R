library(ape)
library(phytools)

InputTree <- read.tree("/work/sanno/Orthofinder/output/analysis/iqtree/partition.nexus.rooted")

nodestocallibrate <- c(
getMRCA(InputTree, tip = c("Gryllus_bimaculatus", "Locusta_migratoria")),
getMRCA(InputTree, tip = c("Schistocerca_gregaria", "Locusta_migratoria"))
)

age.min <- c(
241,
20
)

age.max <- c(
339,
45
)

my_points <- data.frame(nodestocallibrate, age.min, age.max)

my_calibration <- makeChronosCalib(InputTree, node=nodestocallibrate, my_points)

## strict clock model:
mytimetree_calibrated <- chronos(InputTree,  model = "discrete", calibration = my_calibration, control = chronos.control(nb.rate.cat =1) )

## log-Lik = -3.355145 
## PHIIC = 22.71

writeNexus(mytimetree_calibrated, file="partition.nexus.contree.rooted.nwk.ape")
