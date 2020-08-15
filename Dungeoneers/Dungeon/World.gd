extends Node2D

const Enemy = preload("res://Enemies/Enemy.tscn")

var borders = Rect2(1, 1, 38, 21)

onready var tileMap = $Dungeon
onready var player_camera = $Player_Camera
onready var world_camera = $World_Camera

func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(200)
	walker.queue_free()
	var enemy_counter = 0
	for location in map:
		tileMap.set_cellv(location, -1)
		if enemy_counter == 100:
			var enemy = Enemy.instance()
			get_parent().call_deferred("add_child", enemy)
			enemy.global_position = location * 32 + Vector2(16, 16)
			enemy_counter = 0
		enemy_counter = enemy_counter + 1
	tileMap.update_bitmask_region(borders.position, borders.end)
	tileMap.update()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var _current_scene = get_tree().reload_current_scene()
	
	if event.is_action_pressed("ui_select"):
		if world_camera.current:
			world_camera.clear_current()
			player_camera.make_current()
		else:
			player_camera.clear_current()
			world_camera.make_current()
