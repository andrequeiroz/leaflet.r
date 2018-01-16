# Leaflet + R

Exemplo de mapa interativo com [Leaflet](http://leafletjs.com) e [R](https://cran.r-project.org/). A construção da visualização utiliza as bibliotecas do R:

* [leaflet](https://cran.r-project.org/web/packages/leaflet/index.html);
* [rgdal](https://cran.r-project.org/web/packages/rgdal/index.html);
* [readr](https://cran.r-project.org/web/packages/readr/index.html); e
* [htmlwidgets](https://cran.r-project.org/web/packages/htmlwidgets/index.html).

```r
library(leaflet)
library(rgdal)
library(readr)
library(htmlwidgets)
```

## Malha Digital

A malha digital utilizada está disponível no diretório [malha](./malha). O carregamento no R será feito a partir da função `readOGR()` da biblioteca `rgdal`.

```r
malha <- readOGR(dsn = "./malha", layer = "trt3")
```

## Estatística

A [base](./dados/base) de dados utilizada é fictícia. Foram gerados valores aleatórios para cada um dos municípios-sede da malha digital. O carregamento no R será feito a partir da função `read_tsv()` da biblioteca `readr`.

```r
dados <- read_tsv("./dados/base")
```

## Malha Digital + Estatística

A união dos dados à malha digital será feita a partir da função `merge()` da biblioteca `base`. A chave da união é dada pelos campos `cd_geocmu` da malha digital e `codigo_ibge` da base de dados.

```r
dados <- malha %>%
    merge(dados, by.x = "cd_geocmu", by.y = "codigo_ibge")
```

## Rótulos

Os rótulos que irão aparecer no mapa ao passar o *mouse* sobre o polígono da região será formatado em HTML a partir do encadeamento seguinte de funções:

```r
rotulos <- sprintf("<strong>%s</strong><br/>Estatística: %s", dados$nm_municip,
                   format(dados$valor, big.mark = ".", decimal.mark = ",")) %>%
    lapply(htmltools::HTML)
```

## Paleta de Cores

A paleta de cores que será utilizada é criada a partir da função `colorNumeric()` da biblioteca `leaflet`.

```r
paleta <- colorNumeric("RdYlBu", domain = dados$valor)
```

## Mapa Interativo

O mapa interativo será gerado a parir do encadeamento de funções seguinte.

```r
dados %>%
    leaflet(options = leafletOptions(zoom = 10, minZoom = 6, maxZoom = 10)) %>%
    addProviderTiles(provider = "Esri.WorldTopoMap") %>%
    addPolygons(color = "black", weight = 1, opacity = 0.6,
                fillColor = ~paleta(valor),
                fillOpacity = 0.4, label = rotulos,
                highlightOptions = highlightOptions(color = "white", weight = 2,
                                                    fillOpacity = 0.75,
                                                    bringToFront = TRUE)) %>%
    addLegend(pal = paleta, values = ~valor, title = "Estatística",
              position = "bottomright") %>%
    setMaxBounds(-54.1, -23.7, -34, -13.7) %>%
    saveWidget(file = "./mapa.html", selfcontained = FALSE)
```

<div style="text-align:center">
  <iframe seamless src="mapa.html" width="800" height="500"></iframe>
</div>
