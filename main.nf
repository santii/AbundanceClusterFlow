#!/usr/bin/env nextflow

params.outdir = "output"

process clustering {
    //container "community.wave.seqera.io/library/r-base_r-cluster_r-dbscan_r-factoextra_r-ggplot2:ddced3a187d9f68a"
    container "community.wave.seqera.io/library/r-base_r-cluster_r-dbscan_r-factoextra_pruned:e5533d7135fbd7e8"

    input:
    path abundance_table

    output:
    path "*.csv"
    
    publishDir "$params.outdir/cluster_tables/", mode: 'copy'

    script:
    """
    clustering_table.R $abundance_table
    """
}

process plot_clusters {
    //container "community.wave.seqera.io/library/r-base_r-cluster_r-dbscan_r-factoextra_r-ggplot2:ddced3a187d9f68a"
    container "community.wave.seqera.io/library/r-base_r-cluster_r-dbscan_r-factoextra_pruned:e5533d7135fbd7e8"

    input:
    path cluster_table

    output:
    path "*.png"
    
    publishDir "$params.outdir/cluster_plots/", mode: 'copy'

    script:
    """
    clustering_plot.R $cluster_table
    """
}

workflow {
    params.input_file = "$projectDir/input/abundance_table.csv"
    
    // Gerar as tabelas de clusterização
    cluster_table = clustering(params.input_file)

    // Gerar os gráficos com as tabelas de clusterização
    plot_clusters = plot_clusters(cluster_table.flatten())
}
