require(readr)    # For read_tsv function   

#' Reads a TSV file and return a dataframe.
#'
#' @param filename A string specifying the path to the TSV file to be read.
#' @return A dataframe containing the data from the TSV file with column names.
#' 
#' @examples
#' df <- read_file("data/sample.tsv")
#'
read_file <- function(filename) {
    df <- read_tsv(
        filename, 
        col_names = TRUE, 
        col_types = cols(.default = col_character()),
        show_col_types = FALSE, 
        na = "n/a")
    
    return(df)
}

#' Generates a JSON Sidecar with Source File Information
#' @param sourcefile A character string representing the path or name of the source file.
#' @return A JSON-formatted string that includes the source file information.
#'
# get_source_json_sidecar <- function(sourcefile) {
#     sidecar_list <- list(
#         Sources = sprintf("bids::%s", sourcefile)
#     )
#     sidecar <- toJSON(sidecar_list, pretty = TRUE)
#     return(sidecar)
# }

#' Generate a JSON Sidecar for Source Files
#'
#' This function generates a JSON sidecar that includes a list of source files in the
#' BIDS format. It supports handling both a single source file name or a list of source
#' file names.
#'
#' @param sourcefile A character vector or list of character vectors. If it is a list,
#'   each element is treated as a separate source file name. If it is a single character
#'   string, it is treated as a single source file name.
#'
#' @return A JSON string representing the sidecar. The JSON includes a "Sources" field
#'   which contains a list of the source files formatted as "bids::sourcefile".
#'
get_source_json_sidecar <- function(sourcefile) {
    # Check if sourcefile is a list
    if (is.list(sourcefile)) {
        # Construct the Sources list dynamically based on the input list
        sources <- lapply(sourcefile, function(file) unbox(sprintf("bids::%s", file)))
        
        # Create the sidecar list with the Sources element
        sidecar_list <- list(
            Sources = sources
        )
    } else {
        # Handle the case where sourcefile is not a list (for example, a single string)
        sidecar_list <- list(
            Sources = sprintf("bids::%s", sourcefile)
        )
    }
    
    # Convert the list to a pretty-formatted JSON
    sidecar <- toJSON(sidecar_list, pretty = TRUE)
    
    return(sidecar)
}