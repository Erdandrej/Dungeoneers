extends Node2D

onready var particle = $Particles2D
onready var timer = $Timer

func _ready():
	particle.emitting = true
	timer.start(1)

func _on_Timer_timeout():
	queue_free()
