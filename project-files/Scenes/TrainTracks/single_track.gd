extends Node2D
@export var HEIGHT:int
@export var HEIGHT_OFFSET:int

func cleanup(_anim):
	queue_free()
	
func remove_self():
	$AnimationPlayer.play("traintrack_flyout")
	$AnimationPlayer.connect("animation_finished", cleanup)

func add_self():
	$AnimationPlayer.play("traintrack_flyin")
