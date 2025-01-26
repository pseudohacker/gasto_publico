# to check later
# url_site <- "https://api.datosabiertos.mef.gob.pe"
# ckanr::ckanr_setup(url = url_site)
# ckanr::group_list(as = "table")
# url <- ckanr::resource_show(id ="a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca")
pacman::p_load(dplyr)

#version CKAN
# url <- ("https://api.datosabiertos.mef.gob.pe/DatosAbiertos/v1/datastore_search?resource_id=a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca&limit=5&q=jones")

#version SQL
query <- paste("https://api.datosabiertos.mef.gob.pe/DatosAbiertos/v1/datastore_search_sql?sql=",
               'SELECT * FROM "a9f4cffc-7d0e-4c7c-ab51-1ff115c5beca"',
               ' WHERE "SECTOR_NOMBRE" ',
               "LIKE 'GOBIERNOS REGIONALES' LIMIT 10")
url_encoded <- utils::URLencode(query)
url <- url_encoded

destfile <- here::here("input","input.txt")
curl::curl_download(url, destfile)
dt_json <- fromJSON(destfile)
dt <- dt_json$records


