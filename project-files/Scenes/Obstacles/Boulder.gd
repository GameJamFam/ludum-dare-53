extends Node2D
@export var trackColors: Array[Color]

@onready var speed = global_position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	position.x -= delta * speed
	if position.x < -1000:
		cleanup()

func cleanup():
	queue_free()
	
func _on_area_2d_area_entered(area):
	if area.name != 'PlayerArea':
		return
	area.get_parent().hurt(10)
	cleanup()
