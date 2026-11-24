# ============================================================
# Configuração do pipeline
# ============================================================

library(targets)
library(tarchetypes)

tar_option_set(
  packages = c(
    "dplyr",
    "purrr",
    "readr",
    "tibble",
    "tidyr"
  )
)

# ============================================================
# Carregamento das funções
# ============================================================

source("R/leitura.R")
source("R/transformar.R")
source("R/resumos.R")

# ============================================================
# Definição dos alvos do pipeline
# ============================================================

list(
  # ----------------------------------------------------------
  # 1. Arquivos originais
  # ----------------------------------------------------------
  tar_target(
    arquivo_cadastro,
    "dados/cadastro.csv",
    format = "file"
  ),
  tar_target(
    arquivo_2023,
    "dados/mel_2023.csv",
    format = "file"
  ),
  tar_target(
    arquivo_2024,
    "dados/mel_2024.csv",
    format = "file"
  ),
  tar_target(
    arquivo_2025,
    "dados/mel_2025.csv",
    format = "file"
  ),

  # ----------------------------------------------------------
  # 2. Leitura do cadastro
  # ----------------------------------------------------------

  tar_target(
    cadastro,
    ler_cadastro(arquivo_cadastro)
  ),

  # ----------------------------------------------------------
  # 3. Leitura, transformação e empilhamento dos anos
  # ----------------------------------------------------------

  tar_target(
    dados_todos,
    empilhar_anos(c(
      arquivo_2023,
      arquivo_2024,
      arquivo_2025
    ))
  ),

  # ----------------------------------------------------------
  # 5. Integração com o cadastro
  # ----------------------------------------------------------

  tar_target(
    mel_integrado,
    juntar_cadastro(
      dados_todos,
      cadastro
    )
  ),

  # ----------------------------------------------------------
  # 6. Conferência da produção
  # ----------------------------------------------------------

  tar_target(
    conferencia,
    conferir_producao(dados_todos)
  ),

  # ----------------------------------------------------------
  # 7. Resumos da produção
  # ----------------------------------------------------------

  tar_target(
    resumo_unidade,
    resumir_unidade(mel_integrado)
  ),
  tar_target(
    resumo_categoria,
    resumir_categoria(mel_integrado)
  ),
  tar_target(
    resumo_categoria_ano,
    resumir_categoria_ano(mel_integrado)
  ),

  # ----------------------------------------------------------
  # 8. Sazonalidade
  # ----------------------------------------------------------

  tar_target(
    dados_sazonalidade,
    resumir_sazonalidade(mel_integrado)
  ),
  tar_target(
    extremos_sazonalidade,
    resumir_extremos_sazonalidade(dados_sazonalidade)
  ),

  # ----------------------------------------------------------
  # 9. Variação anual
  # ----------------------------------------------------------

  tar_target(
    media_categoria,
    resumir_media_categoria(mel_integrado)
  ),

  # ----------------------------------------------------------
  # 11. Relatório final
  # ----------------------------------------------------------

  tar_quarto(
    relatorio,
    "relatorio.qmd"
  )
)
