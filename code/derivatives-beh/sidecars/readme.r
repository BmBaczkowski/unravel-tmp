require(glue)

readme <- glue("

# Dataset info

This is a derivative dataset based on minimally pre-processed data located in `data-raw`.
The source data were obtained from [OSF repository](https://osf.io/qpm3t/) and reported in the paper by [Kalbe and Schwabe (2022)](https://doi.org/10.1037/xge0001075)

Dataset is in accordance with the [BIDS](https://bids-specification.readthedocs.io/en/v1.8.0/) standard. 

## Directory structure

```plaintext
./
|- CHANGES
|- README.md
|- dataset_description.json
|- study-01/
│   |- sub-001
│   │   |- sub-001_task-conditioning_desc-rl_beh.json
│   │   |- sub-001_task-conditioning_desc-rl_beh.tsv
│   │   |- sub-001_task-recognition_desc-reduced_beh.json
│   │   |- sub-001_task-recognition_desc-reduced_beh.tsv
|- study-02
|- study-03
|- study-04
|- task-conditioning_desc-rl_beh.json
|- task-recognition_desc-reduced_beh.json
```

### File identifiers

Two processing pipelines were used: (1) to transform data from the conditioning task, and (2) to transform data from recognition task. 

| **Identifier** | **Description** |
| --- | --- |
| `reduced` | Indicates data aggregated by (a) the sum of 'old' responses per condition and (b) the sum of all responses per condition. |
| `rl` | Indicates data transformed to feed reinforcement learning models. |

## References

Kalbe, F., & Schwabe, L. (2022). On the search for a selective and retroactive strengthening of memory: Is there evidence for category-specific behavioral tagging? In Journal of Experimental Psychology: General (Vol. 151, Issue 1, pp. 263–284). American Psychological Association (APA). https://doi.org/10.1037/xge0001075


")