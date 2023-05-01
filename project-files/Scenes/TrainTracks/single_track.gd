extends Node2D
@export var HEIGHT:int
@export var HEIGHT_OFFSET:int
@onready var playing = false
func cleanup(_anim):
	queue_free()

func _process(_delta):
	if !playing:
		return
	print($TrackPieces.global_position, global_position)
	
func remove_self():
	$AnimationPlayer.play("traintrack_flyout")
	playing = true
	$AnimationPlayer.connect("animation_finished", cleanup)

func add_self():
	$AnimationPlayer.play("traintrack_flyin")
