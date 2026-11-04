
# ============================================================
# Funções de transformação dos dados
# ============================================================

#' Transforma a produção mensal para o formato longo
#'
#' @param dados Tabela de produção anual no formato largo.
#' @return Tabela com uma linha por unidade e mês.

arrumar_producao <- function(dados) {
  
  meses <- c(
    "jan", "fev", "mar", "abr", "mai", "jun",
    "jul", "ago", "set", "out", "nov", "dez"
  )
  
  dados %>%
    tidyr::pivot_longer(
      cols = dplyr::all_of(meses),
      names_to = "mes",
      values_to = "mel"
    ) %>%
    dplyr::mutate(
      mes = factor(mes, levels = meses)
    )
  
}



#' Empilha os arquivos anuais de produção
#'
#' @param caminhos Vetor com os caminhos dos arquivos anuais.
#' @return Tabela com a produção de todos os anos.

empilhar_anos <- function(caminhos) {
  
  dados_anos <- purrr::map2(
    caminhos,
    purrr::map_int(
      caminhos,
      ~ readr::parse_number(basename(.x))
    ),
    ~ ler_producao(.x) %>%
      dplyr::mutate(ano = .y)
  )
  
  dados_todos <- dplyr::bind_rows(dados_anos)
  
  arrumar_producao(dados_todos)
  
}



#' Junta a produção ao cadastro e calcula a produção relativa
#'
#' @param producao Tabela de produção no formato longo.
#' @param cadastro Tabela de informações cadastrais.
#' @return Tabela integrada com produção relativa.

juntar_cadastro <- function(producao, cadastro) {
  
  producao %>%
    dplyr::left_join(
      cadastro,
      by = "codigo"
    ) %>%
    dplyr::mutate(
      mel_relativo = mel / colmeias
    )
  
}





#' Confere a produção anual
#'
#' @param dados Tabela de produção no formato longo.
#' @return Resumo anual com linhas, unidades,
#' meses sem registro e soma da produção.

conferir_producao <- function(dados) {
  
  dados %>%
    dplyr::group_by(ano) %>%
    dplyr::summarise(
      linhas = dplyr::n(),
      unidades = dplyr::n_distinct(codigo),
      meses_sem_registro = sum(is.na(mel)),
      soma_valores_registrados = sum(mel, na.rm = TRUE),
      .groups = "drop"
    )
  
}
