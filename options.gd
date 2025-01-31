extends Control

var opener : Control

@export_category("Volume")
@export var volume_label : Label
@export var volume_slider : HSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_label.text = "{volume}%".format({"volume": int(GlobalParameters.volume)})
	volume_slider.value = GlobalParameters.volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_h_slider_value_changed(value: float) -> void:
	GlobalParameters.volume = value
	volume_label.text = "{volume}%".format({"volume": int(GlobalParameters.volume)})
	GlobalParameters.emit_signal("volume_changed")


func _on_confirm_button_pressed() -> void:
	emit_signal("confirm")
	
signal confirm()
