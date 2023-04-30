extends Node2D
@export var Point:PackedScene
@export var SustainPtStart:PackedScene
@export var SustainPtMid:PackedScene
@export var SustainPtEnd:PackedScene

@onready var StaticObstacles = {
	boulder=preload("res://Scenes/Obstacles/boulder.tscn")
}

func create_point(pos_y, color_num:int):
	assert(!sustaining_point, "Cannot add new points while a sustain is playing")
	var pt = Point.instantiate()
	add_child(pt)
	pt.set_color(color_num)
	pt.position = Vector2(position.x, pos_y)

func create_static_obstacle(pos_y, static_name):
	var stat_ob = StaticObstacles[static_name].instantiate()
	add_child(stat_ob)
	stat_ob.position = Vector2(position.x, pos_y)


@onready var sustaining_point = false

func start_sustain_point(pos_y, color_num:int):
	pass
func change_sustain_track(pos_y):
	pass
func end_sustain_point():
	var end_pt = SustainPtEnd.instantiate()
	add_child(end_pt)
	
	
