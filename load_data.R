# to check later
# url_site <- "https://api.datosabiertos.mef.gob.pe"
# ckanr::ckanr_setup(url = url_site)
# ckanr::group_list(as = "table")
# url <- ckanr::resource_show(id ="a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca")
# url <- ("https://api.datosabiertos.mef.gob.pe/DatosAbiertos/v1/datastore_search?resource_id=a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca&limit=5&q=jones")

pacman::p_load(dplyr)

#lista de bases
# 2012-2016 SELECT * FROM "5f3b3cbe-3955-41cc-8662-1757ebb5cf53"
# 2017-2021 SELECT * FROM "0e2469d8-5872-4bc2-a5bc-91ee01c99df8"
# 2022-2025 SELECT * FROM "a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca"

#por lugar de meta
counter <- 32000
i <- 1
while (counter >= 32000) {
  limit <- 32000
  offset <- (i-1)*32000
  query <- glue::glue("https://api.datosabiertos.mef.gob.pe/DatosAbiertos/v1/datastore_search_sql?sql=",
                      'SELECT * FROM "a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca"',
                      'WHERE "PLIEGO_NOMBRE"',
                      "LIKE 'GOBIERNO REGIONAL DEL DEPARTAMENTO DE MOQUEGUA'",
                      'ORDER BY "KEY_VALUE" LIMIT {limit} OFFSET {offset}',.sep = " ")
  
  url_encoded <- utils::URLencode(query)
  url <- url_encoded
  destfile <- here::here("input",glue::glue("metaMoqinput{i}.txt"))
  curl::curl_download(url, destfile)
  i <- i+1
  counter <- jsonlite::fromJSON(destfile)$records |> nrow()
}

#load_data
files <- dir(here::here("input"), pattern = "^metaMoq") # get file names
dt_2022_2025 <- files %>%
  purrr::map(~ jsonlite::fromJSON(file.path("input", .))$records) %>%
  purrr::reduce(rbind)

# al 27 de enero no está actualizado 2024
