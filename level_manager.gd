extends Node2D

@export var bosses : Array[PackedScene]
var current_boss
var current_id := 0

@export_file("*.tscn") var main_menu : String
@export var pause_menu : VBoxContainer
var is_paused : bool = false

@export var player : CharacterBody2D
@export var shop_menu : VBoxContainer
@export var shop_buttons : Array[Button]
enum ACTIONS {Speed, Cadency, BulletSpeed, Life}
var modif_dict : Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instantiate_boss()
	modif_dict = {
		ACTIONS.Speed: ModifItem.new("Speed", player.update_speed, 500, 500),
		ACTIONS.Cadency: ModifItem.new("Cadency", player.update_cadency, -15, -15),
		ACTIONS.BulletSpeed: ModifItem.new("Bullet Speed", player.update_bullet_speed, 750, 750),
		ACTIONS.Life: ModifItem.new("Life", player.update_life, 1, 2)
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not is_paused:
			is_paused = true
			pause_menu.show()
			grab_first_button(pause_menu)
		else:
			resume()

func on_boss_death():
	current_boss.queue_free()
	current_id += 1
	if current_id < len(bosses):
		get_tree().paused = true
		instantiate_boss()
		open_shop_menu()
	else:
		get_tree().paused = false
		to_main_menu()

func on_player_death():
	to_main_menu()

func instantiate_boss():
	current_boss = bosses[current_id].instantiate()
	current_boss.global_transform = Transform2D(0, Vector2(0, -840))
	add_child(current_boss)
	current_boss.get_child(0).get_child(0).get_child(0).connect("on_death", on_boss_death)  # Cringe (:

func to_main_menu():
	get_tree().change_scene_to_file(main_menu)

func exit_game():
	get_tree().quit()

func resume():
	is_paused = false
	pause_menu.hide()

func on_shop_button_pressed(button_id : int):
	var modif_item : ModifItem = modif_dict[button_id]
	modif_item.function.call(modif_item.modif)
	modif_item.use_item()
	close_shop_menu()

func open_shop_menu():
	for i in len(shop_buttons):
		var modif_item : ModifItem = modif_dict[i]
		var btn_text : String = "{name}: {value}"
		modif_item.change_modif()
		shop_buttons[i].text = btn_text.format({"name": modif_item.name, "value": modif_item.modif})
		if modif_item.used:
			shop_buttons[i].disabled = true
	shop_menu.show()
	grab_first_button(shop_menu)

func grab_first_button(menu : VBoxContainer):
	menu.get_children()[0].grab_focus()

func close_shop_menu():
	if get_tree().paused:
		shop_menu.hide()
		get_tree().paused = false

class ModifItem:
	var name: String
	var function : Callable
	var from : int
	var to : int
	var modif : int
	var used : bool = false
	
	func _init(p_name, p_function, p_from, p_to) -> void:
		name = p_name
		function = p_function
		from = p_from
		to = p_to
	
	func change_modif():
		modif = randi_range(from, to)
	
	func use_item():
		if name != "Life":
			used = true


func _on_upgrade_bullet_speed_pressed() -> void:
	pass # Replace with function body.
