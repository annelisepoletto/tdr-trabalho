

# Projeto Reprodutível — Análise da Produção de Mel

## 1. Sobre o projeto

Este projeto foi desenvolvido como parte do Trabalho Intermediário da disciplina de Trabalho Reprodutível.

O objetivo é realizar uma análise exploratória da produção de mel de unidades produtoras, considerando os dados mensais dos anos de 2023, 2024 e 2025.

São analisadas a evolução da produção ao longo dos anos, a sazonalidade mensal, a produção relativa por colmeia e as diferenças entre as categorias de florada.

## 2. Dados

Os dados utilizados estão armazenados na pasta `dados/`:

- `cadastro.csv`: informações cadastrais das unidades produtoras.
- `mel_2023.csv`: produção mensal de 2023.
- `mel_2024.csv`: produção mensal de 2024.
- `mel_2025.csv`: produção mensal de 2025.
- `LEIA-ME.txt`: informações e orientações sobre os dados.

O conjunto possui nove unidades cadastradas, das quais oito apresentam registros de produção.

Os registros ausentes são mantidos como valores `NA`, sem substituição por zero ou imputação.

Além da produção total em quilogramas, utiliza-se a produção relativa, calculada pela divisão da quantidade de mel pelo número de colmeias da unidade produtora.

## 3. Organização do projeto

```text
tdr-trabalho/
├── .github/
│   └── workflows/
│       └── relatorio.yaml
├── dados/
│   ├── cadastro.csv
│   ├── LEIA-ME.txt
│   ├── mel_2023.csv
│   ├── mel_2024.csv
│   └── mel_2025.csv
├── R/
│   ├── leitura.R
│   ├── transformar.R
│   └── resumos.R
├── renv/
├── .gitignore
├── .lintr
├── _dependencies.R
├── _targets.R
├── analise.qmd
├── relatorio.qmd
├── renv.lock
└── README.md
```

## 4. Requisitos

Para reproduzir a análise, são necessários:

- R versão 4.4.2;
- RStudio;
- Quarto;
- Git.

As dependências do projeto são gerenciadas pelo pacote `renv` e estão registradas no arquivo `renv.lock`.

## 5. Como reproduzir o projeto

Clone o repositório:

```bash
git clone --branch trabalho https://github.com/annelisepoletto/tdr-trabalho.git
```

Abra o arquivo `tdr-trabalho.Rproj` no RStudio.

Instale o `renv`, caso ainda não esteja disponível:

```r
install.packages("renv")
```

Restaure as dependências:

```r
renv::restore()
```

Execute o pipeline de análise:

```r
targets::tar_make(callr_function = NULL)
```

Gere o relatório:

```r
quarto::quarto_render("relatorio.qmd")
```

Verifique o padrão de estilo do código:

```r
lintr::lint_dir()
```

O relatório final é gerado no arquivo `relatorio.html`.

## 6. Pipeline e integração contínua

O projeto utiliza o pacote `targets` para organizar as etapas de leitura, transformação, integração e resumo dos dados, permitindo executar novamente a análise de maneira estruturada.

A integração contínua é realizada pelo GitHub Actions, por meio do arquivo `.github/workflows/relatorio.yaml`.

O workflow é acionado em eventos de `push` e `pull_request` direcionados à branch `trabalho`. Durante a execução, são restauradas as dependências, verificado o estilo do código, executado o pipeline e renderizado o relatório.

Ao final, o arquivo HTML e seus recursos são disponibilizados como artefato para download na página da execução do GitHub Actions.

## 7. Declaração de uso de inteligência artificial

Foi utilizada a ferramenta ChatGPT, da OpenAI, como apoio ao desenvolvimento do projeto, principalmente na elaboração e revisão de trechos de código em R, organização do pipeline com `targets`, configuração do ambiente reproduzível com `renv`, resolução de problemas técnicos e configuração da integração contínua com GitHub Actions.

A ferramenta também foi utilizada como apoio à organização e revisão da documentação.

As sugestões foram avaliadas pela autora, e os códigos, resultados das análises, tabelas, figuras e relatório foram conferidos durante a execução do projeto.

