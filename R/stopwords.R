#' Collection of stopwords in multiple languages
#'
#' This function returns stop words contained in the \href{https://github.com/stopwords-iso/stopwords-iso}{StopwordsISO} repository.
#' 
#' @param lang Language for which to retrieve the stop word among those supported. This parameters supports: \itemize{
#'  \item three-letter ISO 639-2/3 codes (e.g., \code{'eng'});
#'  \item two-letter ISO639-1 codes (\code{'en'});
#'  \item names based ISO 639-2 codes (\code{'English'} or \code{'english'}) and their unambiguous substrings (\code{'engl'}, \code{'engli'}, etc.).
#' }
#' 
#' @return A character vector containing the stop words from the selected language as listed in the \href{https://github.com/stopwords-iso/stopwords-iso}{StopwordISO} repository.
#' 
#' @export
#' 
#' @examples
#' # They all return the correct list of stop words!
#' 
#' stopwords('German')
#' stopwords('germ')
#' stopwords('de')
#' stopwords('deu')

stopwords <- function(lang = 'en') {
  
  lang <- match.lang(lang = lang)
  
  if (lang %in% names(stopwordsISO)){
    stopwordsISO[[lang]]
  } else {
    stop(paste0(lang, ' is not supported by `StopwordsISO`!'))
  }
  
}

#' Returns ISO codes and names for all language or only those available in this package
#'
#' See the relevant \href{https://en.wikipedia.org/wiki/ISO_639-1}{Wikipedia article} for details on the language codes.
#' 
#' Note that: \itemize{
#'  \item the ISO 639-1 code for mainland Chinese was changed to \code{zh-cn}.
#'  \item A list of stop words in the variety of Chinese spoken in the island of Taiwan is accessible using the ISO 639-1 \code{zh-tw} or the name \code{'Chinese Taiwan'}.
#'  \item Ancient Greek has been assigned an artifact ISO 639-1 code (\code{gr}) because it had none. Its ISO 639-2 and 639-3 codes are both \code{grc}.
#' }
#' 
#' @param available \emph{logical}, whether to return only the languages supported in this package.
#' 
#' @returns A data frame with a row for each languages (only those supported if \code{available} is \code{TRUE}) and columns for the several ISO codes (639-2, 639-3, 639-1) and the name.
#' 
#' @export
#' 
#' @examples
#' # Return all languages in the ISO 639-2/3 standard
#' languages()

languages <- function(available = TRUE) {
  
  # Extract language codes
  code <- names(stopwordsISO)
  
  # Prepare the table
  if(available){
    code <- ISOcodes[match(code, ISOcodes$`ISO639-1`),]
    rownames(code) <- NULL
  }
  
  code
}

#' Removes stop words for a string the language of which is known
#'
#' @param str A string or a vector of strings which to delete the stop words from
#' @param lang Either: \itemize{
#'  \item \code{'auto'} in which case \code{cld2} is used to perform language detection; or
#'  \item A string (or a vector of strings, depending on \code{str}) representing an ISO 639-2/3 or a language name from which to derive a ISO 639-2 code (for language names, string matching is performed)
#' }
#' @param fallback Fallback language in case \code{cld2} fails to detect the language of the manually-specified string does not match a supported language. Default to \code{'English'}.
#' 
#' @returns A strings (or a vector, depending on \code{str}) corresponding to the string/s \code{str} without stop words for the language/s \code{lang}.
#'
#' @export
#' 
#' @examples
#' # Multiple strings in different languages
#' remove.stopwords(str = c(Gibberish = 'dadas',
#'                          Catalan = 'Adeu amic meu',
#'                          Irish = 'Slan a chara',
#'                          French = 'Je suis en Allemagne',
#'                          German = 'Eich liebe Deutschland'),
#'                  # Various ways of indicating the language
#'                  lang = c(NA, 'cata', 'Iris', 'fr', 'deu'),
#'                  # Yet another way
#'                  fallback = 'english'
#'                  )
#' 
remove.stopwords <- function(str, lang = 'auto', fallback = 'English'){
  # Code of the fallback language
  fallback <- match.lang(fallback)
  
  # Language detection
  if(length(lang) == 1 && lang == 'auto'){
    # Whether it is possible to use `cld2`
    has_cld2 <- requireNamespace('cld2', quietly = TRUE)
    
    if(has_cld2){ # Possible
      # Detect language
      lang <- cld2::detect_language(str, lang_code = TRUE)
      
      # If unknown
      # Works both when `str` is a string and when it is a vector of strings
      if(any(is.na(lang))){
        lang[is.na(lang)] <- fallback
      }
    } else { # Impossible
      # Use fallback language
      fallback_name <- ISOcodes$name[which(ISOcodes$`ISO639-1`==fallback)]
      lang <- fallback
      # Warn the user
      warning(paste('Language detection requires the package `cld2`\n',
                    'Reverting to fallback language:', fallback_name))
      
    }
  } else {
    # If unknown
    # Works both when `str` is a string and when it is a vector of strings
    if(any(is.na(lang))){
      lang[is.na(lang)] <- fallback
    }
    
    # Code language/s
    lang <- if(length(lang>1)){
      lapply(lang, match.lang)|> unlist()
    } else {
      match.lang(lang)
    }
    
  }
  
  out <- if(length(str)>1){
    lapply(seq_along(str), function(w){
      del.stopwords(str = str[[w]], lang = lang[w])
    })
  } else {
    del.stopwords(str = str, lang = lang)
  }
  
  out
}
