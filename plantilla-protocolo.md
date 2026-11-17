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

*Escribe `scripts/comparacion_experimento.py` (o `.R`): debe cargar `plantillas/registro_experimento.csv` y calcular el promedio de `ventas_producto` por `ubicacion`. Incluye la salida y responde:*

- ¿Qué grupo muestra mayor venta promedio en la plantilla?
El pasillo muestra 1335 USD en venta frente a 1040 USD en habitual

- ¿Por qué con 4 filas no se puede concluir nada sobre el efecto de la ubicación?
No se puede concluir porque no hay ninguna asignación real aleatoria, son muy pocos datos (4), no existe un control de temporada, ni promociones en el grupo pasillo y no hay medida de variabilidad.

- Si el experimento se ejecutara con tu protocolo, ¿qué le faltaría a este análisis para ser justo?
´´´
import pandas as pd
import numpy as np

tiendas = ["Quito Norte", "Quito Sur", "Guayaquil Centro", "Guayaquil Norte",
            "Cuenca Centro", "Cuenca Sur", "Ambato Centro", "Manta", "Loja", "Machala"]

semanas = [1, 2, 3, 4]

#Sorteo de la condicion inicial
rng = np.random.default_rng(1234597) ##permite generar rangos aleatorios bajo condiciones
primera = rng.choice(["pasillo_principal", "habitual"], size=len(tiendas))
filas = []

for tienda, cond in zip(tiendas, primera):
    otra = "habitual" if cond == "pasillo_principal" else "pasillo_principal"
    for s in semanas:
        filas.append({"tienda": tienda, "semana": s,
                     "ubicacion": cond, if s&2 == 1 else otra})
´´´