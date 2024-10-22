extends CharacterBody2D

enum States  {IdleHealty, IdleSick, AggroHealty, AggroSick}


# For path instanciating
@export var path_index: int = 0
@export var path_follow : PathFollow2D
@export var top_node : Node2D

var can_shoot := true
var old_progress : int = 0
var current_state : States = States.IdleHealty

# Modulable variables for difficulty
@export_category("Difficulty")
@export var life : int = 100
var max_life : int

@export var pattern_idle_1 : BulletPattern
@export var pattern_idle_2 : BulletPattern
@export var pattern_aggro_1 : BulletPattern
@export var pattern_aggro_2 : BulletPattern
var patterns : Dictionary
@export var paths : Array[PackedScene]
@export var speed = 300.0


func _ready() -> void:
	max_life = life
	patterns = {
		States.IdleHealty: pattern_idle_1,
		States.IdleSick: pattern_idle_2,
		States.AggroHealty: pattern_aggro_1,
		States.AggroSick: pattern_aggro_2
	}
	call_deferred("change_path")

func _physics_process(delta: float) -> void:
	old_progress = path_follow.progress
	path_follow.progress += speed * delta
	if old_progress > path_follow.progress:
		check_and_change_state()

func _process(delta: float) -> void:
	spawn_bullet(patterns[current_state])
	if Input.is_action_just_pressed("change_path"):
		next_path()
		change_path()
	
func spawn_bullet(pattern: BulletPattern):
	if can_shoot:
		for i in pattern.n_angles:
			for j in pattern.n_simult:
				var bullet_instance = pattern.projectile.instantiate()
				var angle = pattern.get_angle(i, j)
				bullet_instance.global_transform = global_transform 
				bullet_instance.rotation = pattern.get_angle(i, j)
				top_node.get_parent().add_child(bullet_instance)
			can_shoot = false
			await  get_tree().create_timer(pattern.latency).timeout
			can_shoot = true

func change_path():
	var old_path = path_follow.get_parent()
	var path_to_add = paths[path_index].instantiate()
	top_node.add_child(path_to_add)
	path_follow.reparent(path_to_add)
	if old_path != top_node:
		old_path.queue_free()

func got_hit(value: int):
	life -= value
	if life <= 0:
		die()

func die():
	emit_signal("on_death")
	top_node.queue_free()

func next_path():
	path_index += 1
	if path_index >= len(paths):
		path_index = 0
		
func check_and_change_state():
	if current_state == States.IdleHealty and life <= 3 * (max_life / 4):
		next_path()
		change_path()
		current_state = States.AggroHealty
	elif current_state == States.AggroHealty and life <= 2 * (max_life / 4):
		next_path()
		change_path()
		current_state = States.IdleSick
	elif current_state == States.IdleSick and life <= 1 * (max_life / 4):
		next_path()
		change_path()
		current_state = States.AggroSick

signal on_hit(life : int)
signal on_death()
