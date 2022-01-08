extends AudioStreamPlayer

var err

func _ready():
	err = connect("finished", self, "queue_free")
