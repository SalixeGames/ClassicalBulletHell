extends Control

var opener : Control

@export_category("Volume")
@export var music_volume_label : Label
@export var music_volume_slider : HSlider
@export var sfx_volume_label : Label
@export var sfx_volume_slider : HSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_volume_label.text = "{volume}%".format({"volume": int(GlobalParameters.music_volume)})
	sfx_volume_label.text = "{volume}%".format({"volume": int(GlobalParameters.sfx_volume)})
	
	music_volume_slider.value = GlobalParameters.music_volume
	sfx_volume_slider.value = GlobalParameters.sfx_volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_music_value_changed(value_changed : bool) -> void:
	if value_changed:
		GlobalParameters.music_volume = music_volume_slider.value
		music_volume_label.text = "{volume}%".format({"volume": int(GlobalParameters.music_volume)})
		GlobalParameters.emit_signal("music_volume_changed")

func _on_sfx_value_changed(value_changed : bool) -> void:
	if value_changed:
		GlobalParameters.sfx_volume = sfx_volume_slider.value
		sfx_volume_label.text = "{volume}%".format({"volume": int(GlobalParameters.sfx_volume)})
		GlobalParameters.emit_signal("sfx_volume_changed")


func _on_confirm_button_pressed() -> void:
	emit_signal("confirm")
	
signal confirm()
