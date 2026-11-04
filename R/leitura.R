
# ============================================================
# Funções de leitura dos dados
# ============================================================

#' Lê o arquivo de cadastro das unidades produtoras
#'
#' @param caminho Caminho do arquivo cadastro.csv.
#'
#' @return Tabela com as informações cadastrais.
ler_cadastro <- function(caminho) {
  
  readr::read_delim(
    caminho,
    delim = ";",
    locale = readr::locale(
      encoding = "ISO-8859-1"
    ),
    col_types = readr::cols(
      codigo = readr::col_character(),
      nome = readr::col_character(),
      florada = readr::col_character(),
      colmeias = readr::col_integer()
    )
  )
  
}


#' Lê um arquivo anual de produção de mel
#'
#' @param caminho Caminho do arquivo anual de produção.
#'
#' @return Tabela com a produção mensal das unidades.
ler_producao <- function(caminho) {
  
  readr::read_delim(
    caminho,
    delim = ";",
    na = "-",
    locale = readr::locale(
      encoding = "ISO-8859-1",
      decimal_mark = ","
    ),
    col_types = readr::cols(
      codigo = readr::col_character(),
      jan = readr::col_double(),
      fev = readr::col_double(),
      mar = readr::col_double(),
      abr = readr::col_double(),
      mai = readr::col_double(),
      jun = readr::col_double(),
      jul = readr::col_double(),
      ago = readr::col_double(),
      set = readr::col_double(),
      out = readr::col_double(),
      nov = readr::col_double(),
      dez = readr::col_double()
    )
  )
  
}
