#!/usr/bin/env Rscript

# loading required libraries
library(cluster)
library(dbscan)
library(mclust)
library(ggplot2)
library(factoextra)

# input data
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]

data <- read.csv(input_file, header = TRUE, sep = ",")

# K-MEANS
if ("kmeans_cluster" %in% colnames(data)) {
  p1 <- fviz_cluster(list(data = data[, c("diversity", "abundance", "pielou")], cluster = data$kmeans_cluster))
  ggsave(filename = "kmeans_cluster.png", plot = p1, width = 7, height = 7)
}

# HIERARCHICAL (HCA)
if ("hclust_cluster" %in% colnames(data)) {
  # Gerar dendrograma baseado na coluna 'hclust_cluster'
  hclust_result <- hclust(dist(data[, c("diversity", "abundance", "pielou")], method = "euclidean"), method = "ward.D2")
  p2 <- fviz_dend(hclust_result, k = 3, rect = TRUE)
  ggsave(filename = "hclust_dendrogram.png", plot = p2, width = 7, height = 7)
}

# DBSCAN
if ("dbscan_cluster" %in% colnames(data)) {
  p3 <- fviz_cluster(list(data = data[, c("diversity", "abundance", "pielou")], cluster = data$dbscan_cluster))
  ggsave(filename = "dbscan_cluster.png", plot = p3, width = 7, height = 7)
}

# PAM (Partitioning Around Medoids)
if ("pam_cluster" %in% colnames(data)) {
  p4 <- fviz_cluster(list(data = data[, c("diversity", "abundance", "pielou")], cluster = data$pam_cluster))
  ggsave(filename = "pam_cluster.png", plot = p4, width = 7, height = 7)
}

# GMM (Gaussian Mixture Models)
if ("gmm_cluster" %in% colnames(data)) {
  p5 <- fviz_cluster(list(data = data[, c("diversity", "abundance", "pielou")], cluster = data$gmm_cluster))
  ggsave(filename = "gmm_cluster.png", plot = p5, width = 7, height = 7)
}
