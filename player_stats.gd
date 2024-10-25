extends Control

@export var speed_label : Label
@export var cadency_label : Label
@export var bullet_speed_label : Label
@export var player : CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed_label.text = "Spd: %s" % player.speed
	cadency_label.text = "BSp: %s" % player.patterns[0].projectile_speed
	bullet_speed_label.text = "Lat: %s" % player.patterns[0].latency
