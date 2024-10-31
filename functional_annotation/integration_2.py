if (!requireNamespace("pacman", quietly = TRUE)) {
  install.packages("pacman")
}

pacman::p_load(tidyverse, magrittr, readr)

# setting
path_genelist <- "/home/yuki_ito/work2/Tasks/blast/Jamaican/gene_list.txt"
path_blast_files <- list(
  sp1 = "/home/yuki_ito/work2/Tasks/blast/Jamaican/blastp_out_Drosophila_melanogaster.BDGP6.32.pep.all.txt",
  sp2 = "/home/yuki_ito/work2/Tasks/blast/Jamaican/blastp_out_Caenorhabditis_elegans.WBcel235.pep.all.txt",
  sp3 = "/home/yuki_ito/work2/Tasks/blast/Jamaican/blastp_out_Mus_musculus.GRCm39.pep.all.txt",
  sp4 = "/home/yuki_ito/work2/Tasks/blast/Jamaican/blastp_out_Homo_sapiens.GRCh38.pep.all.txt",
  uni_sprot = "/home/yuki_ito/work2/Tasks/blast/Jamaican/blastp_out_uniprot_sprot.txt",
  emapper = "/home/yuki_ito/work2/Tasks/blast/Jamaican/MM__fzxc6qh.emapper.annotations.tsv"  # Comments removed
)
path_output <- "/home/yuki_ito/work2/Tasks/integrate_annotation/J_trial.tsv"


gene_list <- read_tsv(path_genelist, show_col_types = FALSE, col_names = FALSE) %>%
  dplyr::select(X1) %>%
  dplyr::rename(gene = X1)

combine_cols <- function(dfs) {
  result <- Reduce(function(x, y) {
    left_join(x, y, by = "gene")
  }, dfs)
  return(result)
}


process_file <- function(file.type, file.path, gene_list) {
  print(paste("Reading file:", file.path))  # For debag
  df <- read_tsv(file.path, show_col_types = FALSE, col_names = FALSE)
  
  # デバッグ情報
  print(paste("Columns in", file.type, ":", colnames(df)))
  
  if (file.type == "emapper") {
    emapper_columns <- c("gene", "seed_ortholog", "evalue", "score", "eggNOG_OGs", "max_annot_lvl", 
                         "COG_category", "Description", "Preferred_name", "GOs", "EC", "KEGG_ko", 
                         "KEGG_Pathway", "KEGG_Module", "KEGG_Reaction", "KEGG_rclass", "BRITE", 
                         "KEGG_TC", "CAZy", "BiGG_Reaction", "PFAMs")
    colnames(df) <- emapper_columns
  } else {
    df <- df %>%
      dplyr::rename(gene = X1, !!file.type := X2) %>%
      dplyr::select(gene, !!sym(file.type))
  }
  
  result <- gene_list %>% left_join(df %>% distinct(gene, .keep_all = TRUE), by = "gene")
  

  print(paste("Number of rows in", file.type, "after join:", nrow(result)))
  
  return(result)
}


dfs <- names(path_blast_files) %>%
  lapply(function(file.type) {
    process_file(file.type, path_blast_files[[file.type]], gene_list)
  }) %>%
  setNames(names(path_blast_files))

final_df <- combine_cols(dfs)
#write_tsv(final_df, path_output)



Dmelanogaster_genelist <- read_tsv("/work2/kataoka/fanflow_db/Drosophila_melanogaster.BDGP6.32.pep.all.fa.gene_name_list", col_names = c("id", "gene", "function"), show_col_types = FALSE)
Celegans_genelist <- read_tsv("/work2/kataoka/fanflow_db/Caenorhabditis_elegans.WBcel235.pep.all.fa.gene_name_list", col_names = c("id", "gene", "function"), show_col_types = FALSE)
Mmusculus_genelist <- read_tsv("/work2/kataoka/fanflow_db/Mus_musculus.GRCm39.pep.all.fa.gene_name_list", col_names = c("id", "gene", "function"), show_col_types = FALSE)
Hsapiens_genelist <- read_tsv("/work2/kataoka/fanflow_db/Homo_sapiens.GRCh38.pep.all.fa.gene_name_list", col_names = c("id", "gene", "function"), show_col_types = FALSE)


#functional_annotation <- read_tsv(path_output, show_col_types = FALSE)
functional_annotation <- final_df


species <- list(
  sp1 = Dmelanogaster_genelist,
  sp2 = Celegans_genelist,
  sp3 = Mmusculus_genelist,
  sp4 = Hsapiens_genelist
)


result_dfs <- names(species) %>%
  lapply(function(target_sp) {
    functional_annotation %>%
      dplyr::select(gene, all_of(target_sp)) %>%
      left_join(
        species[[target_sp]] %>%
          rename(
            !!sym(target_sp) := "id",
            !!sym(paste0(target_sp, "_gene")) := "gene",
            !!sym(paste0(target_sp, "_function")) := "function"
          ),
        by = target_sp
      )
  }) %>%
  reduce(left_join, by = "gene")

functional_annotation <- functional_annotation %>% select(-sp1, -sp2, -sp3, -sp4)

final_result <- result_dfs %>% 
  left_join(functional_annotation, by = "gene")

colnames(final_result) <- c(
  "Genes", "Dmel", "Dmel_gene", "Dmel_function",
  "Cele", "Cele_gene", "Cele_function",
  "Mmus", "Mmus_gene", "Mmus_function",
  "Hsap", "Hsap_gene", "Hsap_function",
  colnames(functional_annotation)[-1]
)

#write_csv(final_result, path_output)
write_tsv(final_result, path_output)
