require(glue)

readme <- glue("

# Info

This is the outcome of the reproducibility process of the results reported by [Kalbe and Schwabe (2022)](https://doi.org/10.1037/xge0001075) regarding memory recognition test.

Three outcomes from the original paper were attempted to be reproduced for each study:
- overall memory performance (hit rate per encoding phase and false alarm rate)
- two-way repeated measures ANOVA on corrected recognition score
- paired t-tests as follow-up to ANOVA.

## Directory structure

```plaintext
./
|-- CHANGES
|-- README.md
|-- dataset_description.json
|-- task-recognition_desc-cr_anova_beh.json
|-- task-recognition_desc-cr_anova_beh.rds
|-- task-recognition_desc-cr_anova_beh.tsv
|-- task-recognition_desc-cr_anova_beh.txt
|-- task-recognition_desc-cr_beh.json
|-- task-recognition_desc-cr_beh.tsv
|-- task-recognition_desc-cr_ttest_beh.json
|-- task-recognition_desc-cr_ttest_beh.rds
|-- task-recognition_desc-cr_ttest_beh.tsv
|-- task-recognition_desc-cr_ttest_beh.txt
|-- task-recognition_desc-overallperformance_beh.json
|-- task-recognition_desc-overallperformance_beh.tsv
```
### File identifiers

| **Identifier** | **Description** |
| --- | --- |
| `overallperformance` | Indicates overall memory performance based on average hit rate across all three encoding phases and false alarm rate across two categories. |
| `cr` | Indicates corrected recognition. |
| `anova` | Indicates two-way repeated measures ANOVA (condition x phase) on corrected recognition (cr) data. |
| `ttest` | Indicates paired t-tests on corrected recognition (cr) data per phase. |

### File extensions

| extension | comment |
| --- | --- |
| `.rds` | single `R` object; use `readRDS()` to load |
| `.tsv` | tabular structure (tab-separated values) |
| `.txt` | output of statistical tests |


## References

Kalbe, F., & Schwabe, L. (2022). On the search for a selective and retroactive strengthening of memory: Is there evidence for category-specific behavioral tagging? In Journal of Experimental Psychology: General (Vol. 151, Issue 1, pp. 263–284). American Psychological Association (APA). https://doi.org/10.1037/xge0001075


")