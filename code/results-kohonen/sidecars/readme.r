require(glue)

readme <- glue("

# Info

To find unique clusters in individual adjustments of beta weights (individual differences in memory recognition), we used unsupervised learning algorithm developed by Teuvo Kohonen -- Self-Organizing Maps (SOMs). SOMs are excellent for dimensionality reduction and visualisation. Specifically, SOMs project high-dimensional data onto a 2D (hexagonal) grid while preserving their topological structure, which then allows for visualizing them in a spatial layout.

To extract clusters of participants, we applied k-means clustering and the number of clusters was decided based on silhouette score. We applied the clustering on raw feature data and on SOM nodes. Clustering the SOM vectors respects the topological structure of the data, and clusters the regions of the SOM grid. 

## Directory structure

```plaintext
.
├── CHANGES
├── README.md
├── dataset_description.json
├── som_1HT.rds
├── som_1HT_clst_.pdf
├── som_1HT_clst_codes.pdf
├── som_1HT_clst_data.pdf
├── som_1HT_clts_list.txt
├── som_1HT_diag_changes.pdf
├── som_1HT_diag_counts.pdf
├── som_1HT_diag_list.txt
├── som_1HT_diag_mapping.pdf
├── som_1HT_diag_neighbours.pdf
├── som_1HT_diag_quality.pdf
├── som_1HT_feature01.pdf
├── som_1HT_feature02.pdf
├── som_1HT_feature03.pdf
├── som_1HT_feature04.pdf
├── som_1HT_feature05.pdf
├── som_1HT_feature06.pdf
├── som_2HT.rds
├── som_2HT_clst_.pdf
├── som_2HT_clst_codes.pdf
├── som_2HT_clst_data.pdf
├── som_2HT_clts_list.txt
├── som_2HT_diag_changes.pdf
├── som_2HT_diag_counts.pdf
├── som_2HT_diag_list.txt
├── som_2HT_diag_mapping.pdf
├── som_2HT_diag_neighbours.pdf
├── som_2HT_diag_quality.pdf
├── som_2HT_feature01.pdf
├── som_2HT_feature02.pdf
├── som_2HT_feature03.pdf
├── som_2HT_feature04.pdf
├── som_2HT_feature05.pdf
├── som_2HT_feature06.pdf
├── som_SDT.rds
├── som_SDT_clst_.pdf
├── som_SDT_clst_codes.pdf
├── som_SDT_clst_data.pdf
├── som_SDT_clts_list.txt
├── som_SDT_diag_changes.pdf
├── som_SDT_diag_counts.pdf
├── som_SDT_diag_list.txt
├── som_SDT_diag_mapping.pdf
├── som_SDT_diag_neighbours.pdf
├── som_SDT_diag_quality.pdf
├── som_SDT_feature01.pdf
├── som_SDT_feature02.pdf
├── som_SDT_feature03.pdf
├── som_SDT_feature04.pdf
├── som_SDT_feature05.pdf
└── som_SDT_feature06.pdf
```

### File identifiers

| **Identifier** | **Description** |
| --- | --- |
| som | self-organising map |
| clst | k-means clustering |
| clst_codes | k-means clustering on SOM node vectors |
| clst_data | k-means clustering on raw feature vectors |
| diag | diagnostic maps |
| feature | single feature of trained SOM |


### File extensions

| extension | comment |
| --- | --- |
| `.rds` | single `R` object; use `readRDS()` to load |
| `.txt` | text file |

## References

Kohonen, T., & Honkela, T. (2007). Kohonen network. In Scholarpedia (Vol. 2, Issue 1, p. 1568). Scholarpedia. https://doi.org/10.4249/scholarpedia.1568

Kohonen, T. (1982). Self-organized formation of topologically correct feature maps. In Biological Cybernetics (Vol. 43, Issue 1, pp. 59–69). Springer Science and Business Media LLC. https://doi.org/10.1007/bf00337288

Kohonen, T. (1988). Self-Organization and Associative Memory. In Springer Series in Information Sciences. Springer Berlin Heidelberg. https://doi.org/10.1007/978-3-662-00784-6

")