extends AudioStreamPlayer2D


func _ready():
# warning-ignore:return_value_discarded
	connect("finished", self, "queue_free")
