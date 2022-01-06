extends Area2D

export(bool) var show_hit = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(area):
	if show_hit:
		var effect = HitEffect.instance()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position # - Vector2(0, 8) # offset
	# We can't use get_parent here because the parent is goin
	# to be freeing itselt in this case
	# We can use the parents parent but that starts to get
	# really messy (not recommended)
