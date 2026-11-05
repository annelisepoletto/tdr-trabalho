# ============================================================
# Configuração do pipeline
# ============================================================

library(targets)

tar_option_set(
  packages = c("tidyverse")
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
  # 2. Leitura dos dados
  # ----------------------------------------------------------

  tar_target(
    cadastro,
    ler_cadastro(arquivo_cadastro)
  ),
  tar_target(
    producao_2023,
    ler_producao(arquivo_2023)
  ),
  tar_target(
    producao_2024,
    ler_producao(arquivo_2024)
  ),
  tar_target(
    producao_2025,
    ler_producao(arquivo_2025)
  ),

  # ----------------------------------------------------------
  # 3. Transformação dos dados
  # ----------------------------------------------------------

  tar_target(
    dados_2023,
    arrumar_producao(
      producao_2023 %>%
        dplyr::mutate(ano = 2023)
    )
  ),
  tar_target(
    dados_2024,
    arrumar_producao(
      producao_2024 %>%
        dplyr::mutate(ano = 2024)
    )
  ),
  tar_target(
    dados_2025,
    arrumar_producao(
      producao_2025 %>%
        dplyr::mutate(ano = 2025)
    )
  ),

  # ----------------------------------------------------------
  # 4. Empilhamento dos anos
  # ----------------------------------------------------------

  tar_target(
    dados_todos,
    dplyr::bind_rows(
      dados_2023,
      dados_2024,
      dados_2025
    )
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
    media_anual,
    resumir_media_anual(mel_integrado)
  ),
  tar_target(
    variacao_anual,
    calcular_variacao_anual(media_anual)
  ),

  # ----------------------------------------------------------
  # 10. Médias por categoria
  # ----------------------------------------------------------

  tar_target(
    media_categoria,
    resumir_media_categoria(mel_integrado)
  )
)
