#' Matches a string with the ISO 639-1 code available in this library
#'
#' See \url{https://en.wikipedia.org/wiki/ISO_639-1} for details of the language code.
#' 
#' @param lang Either an ISO 639-2/3 or a language name from which to derive a ISO 639-2 code. For language names performs string matching.
#' 
#' @returns A character vector containing the two-letter ISO 639-1 code associated to the requested language.
#'
#' @keywords internal

match.lang <- function(lang){
  df <- languages()
  df$name <- tolower(df$name)
  lang <- tolower(lang)
  
  pos <- ifelse(test = nchar(lang)==2,
                # Possible 2-letter code
                yes = which(df$`ISO639-1`==lang),
                no = ifelse(test = nchar(lang)>3,
                            # Possible language name
                            yes = which(df$name==match.arg(lang, df$name)),
                            # Possible 3-letter code
                            no = ifelse(test = any(lang%in%df$`ISO639-2`),
                                        # Is it a IS O639-2 code?
                                        yes = which(df$`ISO639-2`==lang),
                                        # Otherwise, try as a ISO 639-3 code
                                        no = which(df$`ISO639-3`==lang))))
  
  if(is.na(pos)){
    # No match
    stop('Not a valid language (code): ', lang)
  } else {
    # Return match
    df$`ISO639-1`[pos]
  }
}

#' Removes stop words for a string the language of which is known
#'
#' @param str The string which to delete the stop words from
#' @param lang Either an ISO 639-2/3 or a language name from which to derive a ISO 639-2 code. For language names performs string matching.
#' 
#' @returns A character vector corresponding to the string \code{str} without stopwords for the language \code{lang}
#'
#' @keywords internal

del.stopwords <- function(str, lang){
  
  # Find stop words
  stpwrds <- stopwords(lang = lang)
  
  # Remove stop words
  y <- str
  
  for(w in stpwrds){
    y <- gsub(paste0('\\b', w,'\\b'), '', y)
  }
  
  while(any(grepl('  ', y))){
    y <- gsub('  ', ' ', y, fixed = TRUE)
  }
  
  trimws(y)
}