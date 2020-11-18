tool
extends Node2D
class_name LevelGenerator
# Reglas al generar
# 1. Debe tener paredes laterales X[0:11].
# 2. Debe tener una salida de 3 casillas.
#    a) La salida mide 2 casillas de alto
#    b) Las casillas laterales tienen estructura solida
#       hasta llegar a la pared solamente en la casilla
#       superior.

signal started
signal finished
