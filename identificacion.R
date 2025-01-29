dt %>% 
  filter(EJECUTORA_NOMBRE == "GOB. REG. MOQUEGUA - HOSPITAL REGIONAL DE MOQUEGUA" |
           EJECUTORA_NOMBRE == "REGION MOQUEGUA-SALUD" |
           EJECUTORA_NOMBRE == "REGION MOQUEGUA-SEDE CENTRAL") |>
  group_by(EJECUTORA_NOMBRE, TIPO_ACT_PROY_NOMBRE) %>% 
  summarise(gasto = sum(as.numeric(MONTO_DEVENGADO_2024)))

#78234253/59935772 = 1.3 ratio gasto corriente Hosp/DIRESA + EESS 1er nivel

dt <- dt |>
  mutate(PROYECTO3N = case_when(
    EJECUTORA_NOMBRE == "REGION MOQUEGUA-SEDE CENTRAL" &
      TIPO_ACT_PROY_NOMBRE == "PROYECTO" &
      FUNCION_NOMBRE == "SALUD" &
      (stringr::str_detect(META_NOMBRE,"HOSPITAL")) ~ 1,
    TRUE ~ 0
  ))

dt <- dt |>
  mutate(PROYECTO3N = case_when(
    # TIPO_ACT_PROY_NOMBRE == "PROYECTO" &
          (stringr::str_detect(META_NOMBRE,"HOSPITAL")) ~ 1,
    TRUE ~ 0
  ))
table(dt$PROYECTO3N)

dt |>
  filter(PROYECTO3N == 1) |>
  select(EJECUTORA_NOMBRE, TIPO_ACT_PROY_NOMBRE, META_NOMBRE, CATEGORIA_GASTO_NOMBRE, GENERICA, ESPECIFICA_DET_NOMBRE) |>
  # select(META_NOMBRE) |>
  View()


