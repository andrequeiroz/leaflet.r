library(leaflet)
library(rgdal)
library(htmlwidgets)

## malha
malha <- readOGR(dsn = "./malha", layer = "trt3")

## dados
dados <- readr::read_tsv("./dados/base")

## juntar dados com malha
dados <- malha %>%
    merge(dados, by.x = "cd_geocmu", by.y = "codigo_ibge")

## rótulos
rotulos <- sprintf("<strong>%s</strong><br/>Estatística: %s", dados$nm_municip,
                   format(dados$valor, big.mark = ".", decimal.mark = ",")) %>%
    lapply(htmltools::HTML)

## paleta de cores
paleta <- colorNumeric("RdYlBu", domain = dados$valor)

## mapa interativo
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
