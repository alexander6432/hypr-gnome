#!/bin/bash

# Ciudad por defecto si no se pasa ninguna
ciudad="${1:-Tuxtla+Gutierrez}"

# Obtener clima: icono + temperatura
curl -s "https://wttr.in/${ciudad}?format=%l:+%c\n%C+%t\nSensación+Térmica:+%f\nHumedad:+%h&lang=es"

# | Código | Traducción al español                       |
# | ------ | ------------------------------------------- |
# | c      | Condición del clima                         |
# | C      | Nombre textual de la condición del clima    |
# | x      | Condición del clima, símbolo en texto plano |
# | h      | Humedad                                     |
# | t      | Temperatura actual                          |
# | f      | Sensación térmica                           |
# | w      | Viento                                      |
# | l      | Ubicación                                   |
# | m      | Fase de la luna  🌑🌒🌓🌔🌕🌖🌗🌘           |
# | M      | Día lunar                                   |
# | p      | Precipitación (mm cada 3 horas)             |
# | P      | Presión atmosférica (hPa)                   |
# | u      | Índice UV (1-12)                            |
# | D      | Amanecer\*                                  |
# | S      | Salida del sol\*                            |
# | z      | Cenit\*                                     |
# | s      | Puesta del sol\*                            |
# | d      | Anochecer\*                                 |
# | T      | Hora actual\*                               |
# | Z      | Zona horaria local                          |
