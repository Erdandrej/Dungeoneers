extends Control

var health = 4 setget set_health
var max_health = 4 setget set_max_health

onready var fill = $Fill

func set_health(value):
	health = clamp(value, 0, max_health)
	if fill != null:
		fill.rect_size.x = 38 * health/max_health
	
func set_max_health(value):
	max_health = max(value, 1)
	self.health = min(health, max_health)
	if fill != null:
		fill.rect_size.x = 38 * health/max_health
	
func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_health")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_health")
