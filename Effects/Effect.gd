extends AnimatedSprite


func _ready():
	play("grass-destroyed")


func _on_AnimatedSprite_animation_finished():
	queue_free()
