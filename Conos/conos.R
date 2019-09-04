#!/usr/bin/Rscript

# .libPaths(c("/usr/local/lib/R/site-library", "/usr/lib/R/site-library", "/usr/lib/R/library"))

library(optparse)
library(Matrix)

getPagoda <- function (cm, n.cores = 1, verbose = TRUE, n.pcs = 100, distance = "cosine",
                       trim = 5, n.od.genes = 1000, ...)
{
  r <- pagoda2::Pagoda2$new(cm, trim = trim, n.cores = n.cores, verbose = verbose, ...)
  r$adjustVariance(plot = F, do.par = F, gam.k = 10, verbose = verbose)
  r$calculatePcaReduction(nPcs = n.pcs, n.odgenes = n.od.genes, maxit = 1000, verbose = verbose)
  return(r)
}

# Parse arguments

option_list = list(
  make_option(c("-n", "--name"), type="character", default=NULL,
              help="variable name, if the rds file is a list"),
  make_option(c("-j", "--jobs"), type="integer", default=1, help="number of jobs"),
  make_option(c("-p", "--n-pcs"), type="integer", default=100, help="number of principal components"),
  make_option(c("-d", "--n-od-genes"), type="integer", default=1000, help="number of over-dispersed genes"),
  make_option(c("-k", "--k"), type="integer", default=30, help="Number of neighbors for Conos"),
  make_option(c("--k-self"), type="integer", default=5, help="Number of inter-sample neighbors for Conos"),
  make_option(c("-s", "--space"), type="character", default="PCA", help="Number of neighbors for Conos"),
  make_option(c("-e", "--embedding"), type="character", default="UMAP", help="Number of neighbors for Conos (possible values: 'largeVis', 'UMAP')"),
  make_option(c("-r", "--resolution"), type="numeric", default=1.0, help="Resolution for Leiden clusterins")
);

opt_parser = OptionParser(usage = "%prog [options] count_matrix.rds", option_list=option_list)
opt = parse_args(opt_parser, positional_arguments=c(2, Inf))

# Create pagoda objects

cms <- lapply(opt$args, readRDS)
if (!is.null(opt$options$name) && length(opt$options$name) > 0 && nchar(opt$options$name) > 0) {
  cms <- lapply(cms, `[[`, opt$options$name)
}

p2s <- lapply(cms, getPagoda, n.cores=opt$options$jobs, n.pcs=opt$options$`n-pcs`,
              n.od.genes=opt$options$`n-od-genes`)
p2s <- setNames(p2s, 1:length(cms))

# Create Conos

con <- conos::Conos$new(p2s, n.cores = opt$options$jobs)
con$buildGraph(verbose = T, var.scale = T, space = opt$options$space, k = opt$options$k, k.self = opt$options$`k-self`)
con$findCommunities(method = conos::leiden.community, resolution = opt$options$resolution)
con$embedGraph(method = opt$options$embedding, verbose = F, n.cores = opt$options$jobs)

# Save results

fig_width <- 8
fig_height <- 8

pdf("./graph.pdf", width=fig_width, height=fig_height)
con$plotGraph(raster=T, raster.width=fig_width, raster.height=fig_height)
con$plotGraph(color.by='sample', raster=T, raster.width=fig_width, raster.height=fig_height,
              mark.groups=F, show.legend=T, legend.pos=c(1, 1))
dev.off()

saveRDS(con, "./conos.rds")
