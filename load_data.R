# to check later
# url_site <- "https://api.datosabiertos.mef.gob.pe"
# ckanr::ckanr_setup(url = url_site)
# ckanr::group_list(as = "table")
# url <- ckanr::resource_show(id ="a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca")
pacman::p_load(dplyr)

#version CKAN
# url <- ("https://api.datosabiertos.mef.gob.pe/DatosAbiertos/v1/datastore_search?resource_id=a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca&limit=5&q=jones")

#version SQL
#2022-2024
#por UE
# query <- paste("https://api.datosabiertos.mef.gob.pe/DatosAbiertos/v1/datastore_search_sql?sql=",
#                'SELECT * FROM "a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca"',
#                'WHERE "EJECUTORA_NOMBRE"',
#                "LIKE 'GOB. REG. MOQUEGUA - HOSPITAL REGIONAL DE MOQUEGUA' OR",
#                '"EJECUTORA_NOMBRE"',
#                "LIKE 'REGION MOQUEGUA-SALUD'",
#                'ORDER BY "KEY_VALUE"')
# 
# 
# url_encoded <- utils::URLencode(query)
# url <- url_encoded
# destfile <- here::here("input","input1.txt")
# curl::curl_download(url, destfile)
# dt1 <- fromJSON(destfile)$records


#por pliego
query <- paste("https://api.datosabiertos.mef.gob.pe/DatosAbiertos/v1/datastore_search_sql?sql=",
               'SELECT * FROM "a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca"',
               'WHERE "PLIEGO_NOMBRE"',
               "LIKE 'GOBIERNO REGIONAL DEL DEPARTAMENTO DE MOQUEGUA'",
               'ORDER BY "KEY_VALUE" LIMIT 32000')

url_encoded <- utils::URLencode(query)
url <- url_encoded
destfile <- here::here("input","pliegoMoqinput1.txt")
curl::curl_download(url, destfile)

query <- paste("https://api.datosabiertos.mef.gob.pe/DatosAbiertos/v1/datastore_search_sql?sql=",
               'SELECT * FROM "a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca"',
               'WHERE "PLIEGO_NOMBRE"',
               "LIKE 'GOBIERNO REGIONAL DEL DEPARTAMENTO DE MOQUEGUA'",
               'ORDER BY "KEY_VALUE" LIMIT 32000 OFFSET 32000')

url_encoded <- utils::URLencode(query)
url <- url_encoded
destfile <- here::here("input","pliegoMoqinput2.txt")
curl::curl_download(url, destfile)

#load_data
files <- dir(here::here("input"), pattern = "^pliegoMoq") # get file names
dt <- files %>%
  purrr::map(~ fromJSON(file.path("input", .))$records) %>%
  purrr::reduce(rbind)

dt %>% 
  filter(EJECUTORA_NOMBRE == "GOB. REG. MOQUEGUA - HOSPITAL REGIONAL DE MOQUEGUA" |
           EJECUTORA_NOMBRE == "REGION MOQUEGUA-SALUD") |>
  group_by(EJECUTORA_NOMBRE) %>% 
  summarise(N = n(), gasto = sum(as.numeric(MONTO_DEVENGADO_2023)))


