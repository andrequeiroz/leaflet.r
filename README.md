# Leaflet + R

Exemplo de mapa interativo com [Leaflet](http://leafletjs.com) e [R](https://cran.r-project.org/).

Para renderizar, executar os comandos em `index.Rmd` para gerar o arquivo `mapa.html` e então executar:

```r
rmarkdown::render("index.Rmd")
```

Se precisar, editar `htmlwidgets/leaflet.yaml` nos arquivos da biblioteca `lefleat`:

```
- name: jquery
  version: 3.6.0
```