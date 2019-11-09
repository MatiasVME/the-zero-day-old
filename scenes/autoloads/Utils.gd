extends Node

func value2progress(value : float, _min : float, _max : float) -> float:
	return (value - _min) / (_max - _min) * 100.0

func progress2value(progress : float, _min : float, _max : float) -> float:
	return progress / 100 * (_max - _min) + _min