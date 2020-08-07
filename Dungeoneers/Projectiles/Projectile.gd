extends Node2D

var speed = 200

onready var sprite = $Sprite

func shoot(start_pos):
	self.global_position = start_pos
	var direction = (start_pos.direction_to(get_global_mouse_position())).normalized()
	self.linear_velocity = direction * speed
	sprite.rotate(get_global_mouse_position().angle_to_point(global_position))

func _on_Hitbox_area_entered(area):
	queue_free()

func _on_Hitbox_body_entered(body):
	if body is TileMap:
		queue_free()
