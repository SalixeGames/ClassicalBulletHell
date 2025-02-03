extends Node

var music_volume : float = 66
var sfx_volume : float = 66

func get_music_volume():
	return ((music_volume / 100) * (24 + 80)) - 80

func get_sfx_volume():
	return ((sfx_volume / 100) * (24 + 80)) - 80

signal music_volume_changed()
signal sfx_volume_changed()
