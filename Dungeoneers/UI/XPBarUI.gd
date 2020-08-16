extends Control

var xp = 4 setget set_xp
var max_xp = 4 setget set_max_xp

onready var fill = $Fill

func set_xp(value):
	xp = clamp(value, 0, max_xp)
	if fill != null:
		fill.rect_size.x = 22 * xp/max_xp
	
func set_max_xp(value):
	max_xp = max(value, 1)
	self.xp = min(xp, max_xp)
	
func _ready():
	self.max_xp = PlayerStats.max_xp
	self.xp = PlayerStats.xp
# warning-ignore:return_value_discarded
	PlayerStats.connect("xp_changed", self, "set_xp")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_xp_changed", self, "set_max_xp")
