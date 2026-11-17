# Plantilla de protocolo — Experimento de ubicación de producto

**Nombre:** Josue Palma Zambrano · **Fecha:** 17/11/2026

Completa cada sección. Usa commits por sección; la historia del repositorio se revisa.

## 1. Pregunta e hipótesis

**Pregunta:** ¿El producto vende más cuando se ubica en el pasillo principal que en su ubicación habitual?

**Hipótesis:** El producto en el pasillo principal vende más en promedioque su ubicación habitual en ventas semanales durante 4 semanas.

- **H₀:** La diferencia promedio de ventas semanales es 0, es decir, media_pasillo_principal - media_pasillo_habitual = 0.
- **H₁:** La diferencia promedio es mayor a 0.

## 2. Unidad experimental

Semana-Tienda: Número de tiendas por cada número de semanas asociadas al experimento. (**# de tiendas x # de semanas**)

- 9 tiendas x 4 semanas = 36 unidades experimentales.
- Tiendas: Quito_Norte, Quito_Sur, Guayaquil_Centro, Guayaquil_Norte, Cuenca_Norte, Cuenca_Sur, Ambato_Centro, Loja y Machala.

## 3. Factor, niveles y tratamiento

- **Factor** (variable manipulada): Ubicación del producto principal.
- **Niveles** (valores del factor): Ubicación en el pasillo principal (variable **pasillo_principal**) y ubicación habitual (variable **habitual**).
- **Tratamiento** (combinación asignada): Ubicación en el pasillo durante una semana y ubicación habitual durante la siguiente, alternando durante las 4 semanas. Un sorteo decide en qué ubicación comienza cada tienda (condición inicial).

## 4. Grupo de control

La misma tienda pero con el producto dispuesto en la ubicación habitual (en las semanas en las que no recibe el tratamiento), de esta manera, cada tienda sirve como su propio grupo de control.

## 5. Aleatorización

Sorteo con semilla de la ubicación con la que comienza cada una de las 9 tienedas, después las ubicaciones se alternan semana a semana, cada tienda tiene 2 semanas en cada nivel.

- **Asignación en Python:**

```python
rng = np.random.default_rng(1)
primera = rng.choice(["pasillo_principal", "habitual"], size=len(tiendas))
```

- **Resultado de una corrida (semilla 1):**

```
['pasillo_principal' 'habitual' 'habitual' 'habitual' 'pasillo_principal'
 'pasillo_principal' 'habitual' 'habitual' 'pasillo_principal']
```

| Tienda | Semana 1 | Semana 2 | Semana 3 | Semana 4 |
|---|---|---|---|---|
| Quito_Norte | pasillo_principal | habitual | pasillo_principal | habitual |
| Quito_Sur | habitual | pasillo_principal | habitual | pasillo_principal |
| Guayaquil_Centro | habitual | pasillo_principal | habitual | pasillo_principal |
| Guayaquil_Norte | habitual | pasillo_principal | habitual | pasillo_principal |
| Cuenca_Norte | pasillo_principal | habitual | pasillo_principal | habitual |
| Cuenca_Sur | pasillo_principal | habitual | pasillo_principal | habitual |
| Ambato_Centro | habitual | pasillo_principal | habitual | pasillo_principal |
| Loja | habitual | pasillo_principal | habitual | pasillo_principal |
| Machala | pasillo_principal | habitual | pasillo_principal | habitual |

**¿Por qué el sorteo reparte los factores desconocidos?:** Al decidir al azar qué tienda comienza en qué ubicación, ningún rasgo desconocido de la tienda o de la semana (factores incontrolables como el tamaño de la clientela, tendencia de ventas, etc.) queda ligado a un nivel del factor. Los factores se reparten por azar entre dos condiciones, dado que cada tienda se compara consigo misma, los rasgos de la propia tienda se cancelan en la diferencias.

Finalmente, el balance entre condiciones se mantiene, a pesar de que 3 empiezan en pasillo_principal y 6 en habitual.

## 6. Respuesta y medición

- Variable respuesta: Ventas semanales en USD (variable **ventas_producto**).
- Período de medición: 4 semanas.
- Quién registra y cómo (¿ciego?): Mediante el POS, el experimento es ciego en el sentido de que quien analiza los datos en el equipo de RetailAndina y el personal en caja no conocen la hipótesis ni ningún orden asignado.

## 7. Factores a controlar (mínimo 4)

| Factor a controlar | Cómo se controla o registra |
|---|---|
| 1. Clima | Se registra la condición climática de cada semana según su ubicación, de manera que al alternar las ubicaciones del producto dentro de cada tienda, el clima afecta a ambas condiciones. |
| 2. Evento local | Se anotan feriados, eventos cercanos a las tiendas en la columna **notas**, se excluyen o marcan las semanas afectados. |
| 3. Surtido / Stock | Se verifica que el producto tenga siempre stock completo y el mismo surtido en ambas ubicaciones, se registran cambios o falta de disponibilidad en stock. |
| 4. Cambios en el personal | Se registra cualquier rotación o cambio de vendedores durante el experimento, se es constante con el personal presente siempre que sea posible. |
| 5. Promociones simultáneas | Se registra en la columna **promocion_simultanea** y se utiliza para excluir o ajustar las observaciones. |
| 6. Semana / temporada | Se alterna la ubicación semana a semana y se sortea el orden de la condicion inicial, de manera que la tendencia entre semanas no favorezca ningún nivel. |


## 8. Limitaciones del diseño

- Pérdida de potencia por promociones: Una promoción simultánea eleva ventas y confunde el efecto de la ubicación.
- Canibalización de las tiendas: Mover el producto al pasillo principal puede quitar ventas a otros productos de la misma tienda.
- Tamaño de muestra pequeño: Solo se están analizando 9 tiendas, por lo tanto, la precisión del intervalo depende de un número de ubicaciones limitadas.
- Posible efecto de arrastre entre semanas: La ubicación de una semana puede influir en la siguiente, causando una tendencia creciente cada semana.
- Los datos analizados surgen de una simulación, no datos reales.

## 9. Comparación en código (Python/R)

El script **scripts/comparacion_experimento.py** carga el archivo **plantillas/registro_experimento.csv**, calcula el promedio de ventas_producto por ubicacion.

```python
import pandas as pd
 
df = pd.read_csv("plantillas/registro_experimento.csv")
print(df.groupby("ubicacion")["ventas_producto"].mean())
print(df["ubicacion"].value_counts())
```
 
Salida:
 
```
ubicacion
habitual             1040.0
pasillo_principal    1335.0
Name: ventas_producto, dtype: float64
 
ubicacion
pasillo_principal    2
habitual             2
Name: count, dtype: int64
```

- **¿Qué grupo muestra mayor venta promedio en la plantilla?**
  
El pasillo principal muestra 1335 USD en venta frente a 1040 USD en la ubicación habitual.

- **¿Por qué con 4 filas no se puede concluir nada sobre el efecto de la ubicación?**

No se puede concluir nada porque no existe una asignación aleatoria real dado que son muy pocos datos, cada ubicación corresponde a tiendas distintas, no existe un control de temporada y no hay una medida de variabilidad (desviación, intervalo de confianza, valor p).

- **Si el experimento se ejecutara con tu protocolo, ¿Qué le faltaria a este análisis para ser justo?**

Haría falta comparar cada tienda consigo misma (análisis pareado), tener varias tiendas y semanas con el orden sorteado, controlar o excluir las semanas con promociones y otros factores incontrolables, reportar la variabilidad con valores de desviación estándar de las diferencias, intervalo de confianza del 95% y valor p de una prueba t pareada.

**Análisis con la simulación (resultado_simulacion.csv)**
El diseño del protocolo (con la semilla 1) se simuló y guardó en resultado_simulación.csv. En la simulación, el efecto por semana va de 0 a 99 USD y el ruido tiene una desviación de 90 USD.

**Implementación en código:**

```python
import pandas as pd
from scipy import stats
 
d = pd.read_csv("resultado_simulacion.csv")
print(d.groupby("ubicacion")["ventas_producto"].mean())
 
# Análisis pareado: una fila por tienda con sus condiciones
piv = d.groupby(["tienda", "ubicacion"])["ventas_producto"].mean().unstack()
piv["diferencia"] = piv["pasillo_principal"] - piv["habitual"]
 
n = len(piv)
media = piv["diferencia"].mean()
dev = piv["diferencia"].std(ddof=1)
t_crit = stats.t.ppf(0.975, df=n - 1)
ic_inf = media - t_crit * dev / n**0.5
ic_sup = media + t_crit * dev / n**0.5
print(round(media, 2), round(dev, 2))
print(f"{ic_inf:.2f} - {ic_sup:.2f}")
 
prueba = stats.ttest_rel(piv["pasillo_principal"], piv["habitual"])
print(f"{prueba.pvalue:.10f}")
```
**Resultados obtenidos:**

| Medida | Valor |
|---|---|
| Promedio semanal en `habitual` | 1105.94 USD |
| Promedio semanal en `pasillo_principal` | 1338.17 USD |
| Diferencia promedio (n = 9 tiendas) | 232.22 USD |
| Desviación estándar de las diferencias | 74.77 USD |
| IC 95 % de la diferencia (t, 8 g.l.) | 174.75 – 289.70 USD |
| Estadístico t | 9.32 |
| Valor p (prueba t pareada) | 0.0000143571 |

**Conclusión y análisis finales:**

Con un 95% de confianza, podemos afirmar que el pasillo principal vende entre 174.75 USD y 289.70 USD más por semana que en la ubicación habitual (promedio de 232.22 USD). El intervalo no incluye el 0 y el valor p = 0.000014 es menor que 0.05, por lo que se rechaza H₀, hay evidencia de que la ubicación en el pasillo aumenta las ventas semanales.