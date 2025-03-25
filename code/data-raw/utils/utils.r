require(jsonlite) # For get_source_json_sidecar function
require(stringr)  # For str_pad function
require(readr)    # For read_csv function   


#' Zero-pads a numeric value to ensure it has a specified total width.
#'
#' @param number A numeric value that will be zero-padded. 
#' @param width An integer specifying the total width of the output string, including
#'   leading zeros. Default is 2. If the width is less than the number of digits in the
#'   input number, the function will return the number without additional padding.
#'
#' @return A character string representing the zero-padded number.
#' @examples
#' zero_pad_number(5, width = 3)
#' # [1] "005"
#' zero_pad_number(123, width = 5)
#' # [1] "00123"
#'
#' @import stringr
zero_pad_number <- function(number, width = 2) {
    padded_number <- str_pad(number, width = width, pad = "0")
    return(padded_number)
}


#' Extracts the numeric portion following 'vp_' from the given filename.
#' @param filename A string representing the filename.
#' @return A string representing the extracted numeric portion, zero-padded to a width of 3.
extract_vp_number <- function(filename) {
    # Use regular expression to capture digits following 'vp_'
    vp_number <- str_extract(filename, "(?<=^vp_)\\d+")
    
    # Ensure vp_number is zero-padded to a width of 3
    vp_number <- str_pad(vp_number, width = 3, pad = "0")
    
    return(vp_number)
}

#' Reads a CSV file and extracts the zero-padded vp number from its filename.
#' @param csvfile A string representing the path to the CSV file.
#' @return A list containing:
#'   \item{df}{A data frame read from the CSV file.}
#'   \item{vp}{A character string representing the padded "vp" number.}
read_file <- function(csvfile) {
    # Extract the base filename from the provided file path
    filename <- basename(csvfile)
    
    # Extract and format the vp number from the filename
    vp <- extract_vp_number(filename)
    
    # Read the CSV file into a data frame
    df <- read_csv(csvfile, show_col_types = FALSE)
    
    # Return a list containing the data frame and vp number
    return(list(df = df, vp = vp))
}


#' Generates a JSON Sidecar with Source File Information
#' @param sourcefile A character string representing the path or name of the source file.
#' @return A JSON-formatted string that includes the source file information.
#'
get_source_json_sidecar <- function(sourcefile) {
    sidecar_list <- list(
        Sources = sourcefile
    )
    sidecar <- toJSON(sidecar_list, pretty = TRUE)
    return(sidecar)
}

