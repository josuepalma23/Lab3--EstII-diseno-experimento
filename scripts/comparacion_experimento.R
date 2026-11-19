library(stats)

# Ruta al CSV (ajústala según tu proyecto; si usas RStudio con un proyecto, funciona con here::here())
ruta <- file.path("plantillas", "registro_experimento.csv")

df <- read.csv(ruta)

print(head(df))
# Registros por ubicacion
invisible(tapply(df$ventas_producto, df$ubicacion, mean))
print("")
# Contar los registros de cada ubicacion
print(table(df$ubicacion))

# Simulacion de la cantidad de tiendas que vamos a tener asociadas a nuestra franquicia

tiendas <- c("Quito_Norte", "Quito_Sur", "Guayaquil_Centro", "Guayaquil_Norte",
             "Cuenca_Norte", "Cuenca_Sur", "Ambato_Centro", "Loja", "Machala")
semanas <- c(1, 2, 3, 4)

# sorteo de la condicion inicial
set.seed(1234597)
primera <- sample(c("pasillo_principal", "habitual"), size = length(tiendas), replace = TRUE)
print(primera)

filas <- list()

for (i in seq_along(tiendas)) {
  tienda <- tiendas[i]
  cond <- primera[i]
  otra <- if (cond == "pasillo_principal") "habitual" else "pasillo_principal"
  for (s in semanas) {
    filas[[length(filas) + 1]] <- data.frame(
      tienda = tienda,
      semana = s,
      ubicacion = if (s %% 2 == 1) cond else otra
    )
  }
}

diseno <- do.call(rbind, filas)
# print(filas)

# simulacion ejecucion
set.seed(1234598)
efecto_tienda <- setNames(rnorm(length(tiendas), mean = 1100, sd = 120), tiendas)
efecto_semana <- c("1" = 0, "2" = 30, "3" = 60, "4" = 90)
# print(efecto_tienda)

diseno$ventas_producto <- round(
  efecto_tienda[diseno$tienda] +
    efecto_semana[as.character(diseno$semana)] +
    (diseno$ubicacion == "pasillo_principal") * 220 +
    rnorm(nrow(diseno), mean = 0, sd = 90)
)
diseno$ventas_producto <- as.integer(diseno$ventas_producto)

# print(diseno)

diseno$promocion_simultanea <- "no"

# Se selecciona con una condicion las filas, y despues de la coma la columna a modificar
filtro <- diseno$tienda == "Guayaquil_Centro" & diseno$semana == 1
diseno[filtro, "promocion_simultanea"] <- "si"
diseno[diseno$promocion_simultanea == "si", "ventas_producto"] <-
  diseno[diseno$promocion_simultanea == "si", "ventas_producto"] + 180L

# print(diseno)

# Analisis pareado: una fila por tienda con sus condiciones
piv <- as.data.frame(
  tapply(diseno$ventas_producto,
         list(diseno$tienda, diseno$ubicacion),
         mean)
)
piv$diferencia <- piv$pasillo_principal - piv$habitual

media <- round(mean(piv$diferencia), 2)
dev <- round(sd(piv$diferencia), 2)   # sd() ya usa n - 1 (ddof = 1)
print(media)
print(dev)
# print(piv)
n <- nrow(piv)
t_crict <- qt(0.975, df = n - 1)
ic_inf <- media - (t_crict * dev / sqrt(n))
ic_sup <- media + (t_crict * dev / sqrt(n))
# print(round(ic_sup, 2))
# print(round(t_crict, 2))

# El experimento podemos decir que con un 95% de certeza el valor promedio de la diferencia
# de ventas del producto entre el pasillo principal y el habitual va a caer en el rango
cat(sprintf("%.5f - %.5f\n", ic_inf, ic_sup))

## prueba p-value
prueba <- t.test(piv$pasillo_principal, piv$habitual, paired = TRUE)

cat(sprintf(" Prueba P-value:  %.10f\n", prueba$p.value))