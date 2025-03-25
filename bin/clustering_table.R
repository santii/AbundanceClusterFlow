#!/usr/bin/env Rscript

# loading required libraries
library(cluster)
library(dbscan)
library(mclust)

# input data
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]

data <- read.csv(input_file, header = TRUE, sep = ",")

# checking the required columns
if (!all(c("diversity", "abundance", "pielou") %in% colnames(data))) {
    stop("Error: The expected columns ('diversity', 'abundance', 'pielou') are not in the CSV file.")
}

# selecting the required columns
clust_data <- data[, c("diversity", "abundance", "pielou")]

# K-MEANS
kmeans_result <- kmeans(clust_data, centers = 3, nstart = 25)
data$kmeans_cluster <- kmeans_result$cluster
write.csv(data, file = "kmeans_cluster_table.csv", row.names = FALSE)

# HIERARCHICAL (HCA)
dist_matrix <- dist(clust_data, method = "euclidean")
hclust_result <- hclust(dist_matrix, method = "ward.D2")
data$hclust_cluster <- cutree(hclust_result, k = 3)
write.csv(data, file = "hclust_cluster_table.csv", row.names = FALSE)

# DBSCAN (Density Clustering)
dbscan_result <- dbscan(clust_data, eps = 0.5, minPts = 5)
data$dbscan_cluster <- dbscan_result$cluster
write.csv(data, file = "dbscan_cluster_table.csv", row.names = FALSE)

# PAM (Partitioning Around Medoids)
pam_result <- pam(clust_data, k = 3)
data$pam_cluster <- pam_result$cluster
write.csv(data, file = "pam_cluster_table.csv", row.names = FALSE)

# GMM (Gaussian Mixture Models)
gmm_result <- Mclust(clust_data, G = 3)
data$gmm_cluster <- gmm_result$classification
write.csv(data, file = "gmm_cluster_table.csv", row.names = FALSE)
