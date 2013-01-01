extends Node

# Devuelve un progreso de de un "value" dependiendo de un rango de "_min" a "_max",
# es un valor numerico que normalmente esta dentro de 0 a 100.0
func value2progress(_value : float, _min := 0.0, _max := 100.0) -> float:
	return (_value - _min) / (_max - _min) * 100.0

func progress2value(_progress : float, _min := 0.0, _max := 100.0) -> float:
	return _progress / 100 * (_max - _min) + _min