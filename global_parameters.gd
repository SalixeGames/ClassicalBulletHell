extends Node

var volume : float = 100

func get_volume():
	return ((volume / 100) * (24 + 80)) - 80

signal volume_changed()
