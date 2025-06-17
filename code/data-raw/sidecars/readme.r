require(glue)

readme <- glue("

# Dataset info

This is a minimally pre-processed dataset sourced from [OSF repository](https://osf.io/qpm3t/) and reported in the paper by [Kalbe and Schwabe (2022)](https://doi.org/10.1037/xge0001075). 

The original data were extracted, transformed, and saved in accordance with the [BIDS](https://bids-specification.readthedocs.io/en/v1.8.0/) standard. Pre-processing included renaming factor variables for better readability. For recognition task, reaction time (and confidence ratings in study 1) were filtered based on whether 'old' / 'new' response was provided. 

## Directory structure

```plaintext
./
|-README.md
|-CHANGES
|-dataset_description.json
|-study-01/
|   |-task-preconditioning_beh.json
|   |-task-conditioning_beh.json
|   |-task-postconditioning_beh.json
|   |-task-recognition_beh.json
|   |-sub-001/
|       |-sub-001_task-preconditioning_beh.tsv
|       |-sub-001_task-conditioning_beh.tsv
|       |-sub-001_task-postconditioning_beh.tsv
|       |-sub-001_task-recognition_beh.tsv
|-study-02/
|-study-03/
|-study-04/
```

### Behavioral Task Labels

The following identifiers are used for the behavioral tasks included in the dataset:

| **Identifier** | **Description** |
| --- | --- |
| `preconditioning` | Indicates the behavioral task in the first encoding phase (i.e., before the conditioning task). |
| `conditioning` | Indicates the behavioral task in the second encoding phase (i.e., during the conditioning task).|
| `postconditioning` | Indicates the behavioral task in the third encoding phase (i.e., after the conditioning task). |
| `recognition` | Indicates the surprise recognition test. |


## References

Kalbe, F., & Schwabe, L. (2022). On the search for a selective and retroactive strengthening of memory: Is there evidence for category-specific behavioral tagging? In Journal of Experimental Psychology: General (Vol. 151, Issue 1, pp. 263–284). American Psychological Association (APA). https://doi.org/10.1037/xge0001075


")