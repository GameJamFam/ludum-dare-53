extends Node2D
@export var trackColors: Array[Color]

# Called when the node enters the scene tree for the first time.
func set_color(track:int):
	if track > trackColors.size():
		return
	$Sprite2D.self_modulate = trackColors[track]

@onready var speed = global_position.x 
func _physics_process(delta):
	position.x -= delta * speed
	if position.x < -1000:
		cleanup()
	if player != null and Input.is_action_just_pressed("ui_accept"):
		award_points()

func cleanup():
	queue_free()

var points = 0
var old_points = 0
var player = null
func check_player(area):
	if area.name != 'PlayerArea':
		return false
	player = area.get_parent()
	return true

func award_points():
	player.add_point(points)
	cleanup()



func _on_perfect_area_area_entered(area):
	if check_player(area):
		old_points = points
		points = 3
		
func _on_perfect_area_area_exited(area):
	if check_player(area):
		points = old_points

func _on_great_area_area_entered(area):
	if check_player(area):
		old_points = points
		points = 2
func _on_great_area_area_exited(area):
	if check_player(area):
		points = old_points

func _on_good_area_area_entered(area):
	if check_player(area):
		old_points = points
		points = 1
func _on_good_area_area_exited(area):
	if check_player(area):
		points = old_points
