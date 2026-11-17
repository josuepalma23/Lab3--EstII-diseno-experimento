library(dplyr)

df <- read.csv("plantillas/registro_experimento.csv")

print(head(df))
#Registros por ubicacion
tapply(df$ventas_producto, df$ubicacion, mean)
print("")
#Contar los registros de cada ubicacion
print(sort(table(df$ubicacion), decreasing = TRUE))

#Simulacion de la cantidad de tiendas que vamos a tener asociadas a nuestra franquicia 

tiendas <- c("Quito_Norte", "Quito_Sur", "Guayaquil_Centro", "Guayaquil_Norte", "Cuenca_Norte", "Cuenca_Sur", "Ambato_Centro", "Loja", "Machala")
semanas <- c(1, 2, 3, 4)

#sorteo de la condicion inicial
set.seed(1234597)
primera <- sample(c("pasillo_principal", "habitual"), size = length(tiendas), replace = TRUE)
print(primera)
filas <- list()

for (i in seq_along(tiendas)) {
  tienda <- tiendas[i]
  cond <- primera[i]
  otra <- if (cond == "pasillo_principal") "habitual" else "pasillo"
  for (s in semanas) {
    filas[[length(filas) + 1]] <- data.frame(tienda = tienda, semana = s,
                                             ubicacion = if (s %% 2 == 1) cond else otra)
  }
}

diseno <- do.call(rbind, filas)
#print(filas)

#simulacion ejecucion 
set.seed(1234598)
efecto_tienda <- setNames(rnorm(length(tiendas), 1100, 120), tiendas)
efecto_semana <- c("1" = 0, "2" = 30, "3" = 60, "4" = 90)
#print(efecto_tienda)
diseno$ventas_producto <- as.integer(round(unname(efecto_tienda[diseno$tienda]) + unname(efecto_semana[as.character(diseno$semana)])
                                           + (diseno$ubicacion == "pasillo_principal") * 220
                                           + rnorm(nrow(diseno), 0, 90)
                                           , 0))

#print(diseno) 

diseno$promocion_simultanea <- "no"

#El loc lo que hace es que se cumpla una cierta condicion, despues de la coma es la columna en la que se va a poner 
diseno[(diseno$tienda == "Guayaquil Centro") & (diseno$semana == 1), "promocion_simultanea"] <- "si"
diseno[diseno$promocion_simultanea == "si", "ventas_producto"] <- diseno[diseno$promocion_simultanea == "si", "ventas_producto"] + 180

#print(diseno)

#Analisis pareado: una fila por tienda con sus condiciones
piv <- tapply(diseno$ventas_producto, list(diseno$tienda, diseno$ubicacion), mean)
piv <- as.data.frame(piv)
piv$diferencia <- piv$pasillo_principal - piv$habitual

media <- round(mean(piv$diferencia, na.rm = TRUE), 2)
dev <- round(sd(piv$diferencia, na.rm = TRUE), 2)
print(media)
print(dev)
#print(piv)
n <- nrow(piv)
t_crict <- qt(0.975, df = 9)
ic_inf <- media - (t_crict * dev / n^0.5)
ic_sup <- media + (t_crict * dev / n^0.5)
#print(round(ic_sup,2))
#print(round(t_crict, 2))

#El experimento podemos decir que con un 95% de certeza es el valor promedio de la diferencia de ventas del producto
#Se entra el pasillo principal y el habitual va a caer en el rango 
print(paste0(ic_inf, " - ", ic_sup))

## prueba p-value
prueba <- t.test(piv$pasillo_principal, piv$habitual, paired = TRUE)
print(sprintf(" %.10f", prueba$p.value))