# ============================================================
# Funções de resumo dos dados
# ============================================================


# ============================================================
# 1. Resumo da produção por unidade produtora
# ============================================================

resumir_unidade <- function(dados) {
  resumo <- dados %>%
    dplyr::group_by(codigo, nome, florada) %>%
    dplyr::summarise(
      producao_total = sum(mel, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    dplyr::mutate(
      producao_relativa = producao_total / sum(producao_total)
    )

  resumo
}


# ============================================================
# 2. Resumo da produção por categoria
# ============================================================

resumir_categoria <- function(dados) {
  resumo <- dados %>%
    dplyr::group_by(florada) %>%
    dplyr::summarise(
      producao_total = sum(mel, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    dplyr::mutate(
      producao_relativa = producao_total / sum(producao_total)
    )

  resumo
}


# ============================================================
# 3. Resumo da produção por categoria e ano
# ============================================================

resumir_categoria_ano <- function(dados) {
  resumo <- dados %>%
    dplyr::group_by(ano, florada) %>%
    dplyr::summarise(
      producao_total = sum(mel, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    dplyr::group_by(ano) %>%
    dplyr::mutate(
      producao_relativa = producao_total / sum(producao_total)
    ) %>%
    dplyr::ungroup()

  resumo
}


# ============================================================
# 4. Conferência da produção anual
# ============================================================

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


# ============================================================
# 5. Resumo da sazonalidade da produção
# ============================================================

resumir_sazonalidade <- function(dados) {
  dados %>%
    dplyr::filter(!is.na(mel_relativo)) %>%
    dplyr::group_by(ano, mes) %>%
    dplyr::summarise(
      media_relativa = mean(mel_relativo),
      .groups = "drop"
    ) %>%
    dplyr::arrange(ano, mes)
}


# ============================================================
# 6. Identificação dos meses de maior e menor média
# ============================================================

resumir_extremos_sazonalidade <- function(dados) {
  dados %>%
    dplyr::group_by(ano) %>%
    dplyr::filter(
      media_relativa == min(media_relativa) |
        media_relativa == max(media_relativa)
    ) %>%
    dplyr::mutate(
      classificacao = dplyr::if_else(
        media_relativa == min(media_relativa),
        "Menor média",
        "Maior média"
      )
    ) %>%
    dplyr::ungroup()
}


# ============================================================
# 7. Resumo da média da produção relativa por ano
# ============================================================

resumir_media_anual <- function(dados) {
  dados %>%
    dplyr::filter(!is.na(mel_relativo)) %>%
    dplyr::group_by(ano) %>%
    dplyr::summarise(
      media_relativa = mean(mel_relativo),
      .groups = "drop"
    ) %>%
    dplyr::arrange(ano)
}


# ============================================================
# 8. Cálculo da variação percentual entre 2023 e 2025
# ============================================================

calcular_variacao_anual <- function(dados) {
  media_2023 <- dados %>%
    dplyr::filter(ano == 2023) %>%
    dplyr::pull(media_relativa)

  media_2025 <- dados %>%
    dplyr::filter(ano == 2025) %>%
    dplyr::pull(media_relativa)

  if (
    length(media_2023) != 1 ||
      length(media_2025) != 1 ||
      is.na(media_2023) ||
      is.na(media_2025) ||
      media_2023 == 0
  ) {
    stop("Não foi possível calcular a variação entre 2023 e 2025.")
  }

  tibble::tibble(
    media_2023 = media_2023,
    media_2025 = media_2025,
    variacao_percentual = (
      media_2025 / media_2023 - 1
    ) * 100
  )
}


# ============================================================
# 9. Resumo da média da produção relativa por categoria
# ============================================================

resumir_media_categoria <- function(dados) {
  dados %>%
    dplyr::filter(!is.na(mel_relativo)) %>%
    dplyr::group_by(florada) %>%
    dplyr::summarise(
      media_relativa = mean(mel_relativo),
      .groups = "drop"
    ) %>%
    dplyr::arrange(dplyr::desc(media_relativa))
}
