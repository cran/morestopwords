#' Combined stop words for all languages
#' 
#' A list of stop words in each of the supported languages
#' 
#' Note: All Unicode characters are escaped. To un-escape them, consider using:
#'  
#' \preformatted{
#'    library(AllStopwords)
#'    if(!requireNamespace('stringi')){
#'      install.packages('stringi')
#'    }
#'    data('stopwordsISO')
#'    stopwords_unescaped <- lapply(stopwordsISO,
#'                                  stringi::stri_unescape_unicode)
#' }
#' 
#' @source All unique stopwords in the following databases:\itemize{
#'  \item the StopwordISO \href{https://github.com/stopwords-iso/stopwords-iso}{repository};
#'  \item python's Natural Language Toolkit (\href{https://www.nltk.org/}{nltk});
#'  \item the \href{http://snowball.tartarus.org/algorithms/english/stop.txt}{Snowball} stop-word list;
#'  \item the R package \href{https://quanteda.io/}{quanteda};
#'  \item the marimo \href{https://github.com/koheiw/marimo}{repository};
#'  \item the \href{https://www.perseus.tufts.edu/hopper/stopwords}{Perseus} project; and
#'  \item Aurélien Berra's list of stop words for {Ancient Greek and Latin} (\doi{10.5281/zenodo.3860343}).
#' }
#' 
#' @author Each stop-word list's Authors
'stopwordsISO'