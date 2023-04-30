extends Node2D

@onready var TRACK_BOUND_UPPER = 307
@onready var TRACK_BOUND_LOWER = 711 # yeah yeah, magic numbers

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		remove_bottom_track()


# Deletable
func add_test_boulder():
	spawn_data({
		track=randi_range(0,4), 
		type="obstacle_static", 
		obst_type="boulder"})
func add_test_point():
	spawn_data({track=randi_range(0,4), type="point"})

func end_song_failure():
	print("you are dead")

# Deque implementation
@export var TrainTrack: PackedScene
@onready var max_tracks = 7
@onready var min_tracks = 1
@onready var tracks = $TrainTracks
@onready var lowest_track_pos = tracks.get_children().map(func(e): return e.position.y).max()
@onready var highest_track_pos = tracks.get_children().map(func(e): return e.position.y).min()
func add_track(to_top:bool, flip_y:bool):
	assert(tracks.get_child_count() + 1 <= max_tracks, "Too many train tracks!")
	var tt = TrainTrack.instantiate()
	if to_top:
		tt.position.y = highest_track_pos - tt.HEIGHT - tt.HEIGHT_OFFSET
		tracks.add_child(tt)
		highest_track_pos = tt.position.y
	else:
		tt.position.y = lowest_track_pos + tt.HEIGHT + tt.HEIGHT_OFFSET
		tracks.add_child(tt)
		lowest_track_pos = tt.position.y
	tt.scale.y = -1 if flip_y else 1
	tt.add_self()
	
func remove_track(from_top:bool):
	assert(tracks.get_child_count() - 1 >= min_tracks, "Too few train tracks!")
	var tt = null
	if from_top:
		tt = tracks.get_child(tracks.get_child_count() - 1)
	else:
		tt = tracks.get_child(0)
	tt.remove_self()

# ---- Commands ----
## Track Commands
func add_top_track_inaccessible():
	add_track(true, false)
func add_top_track():
	add_track(true, true)
	TRACK_BOUND_UPPER -= tracks.get_child(0).HEIGHT
func add_bottom_track():
	add_track(false, false)
	TRACK_BOUND_LOWER += tracks.get_child(0).HEIGHT
func remove_top_track():
	remove_track(true)
	var mov = tracks.get_child(0).HEIGHT
	TRACK_BOUND_UPPER += mov
	if $Player.position.y < TRACK_BOUND_UPPER:
		$Player.position.y += mov
func remove_bottom_track():
	remove_track(false)
	var mov = tracks.get_child(0).HEIGHT
	TRACK_BOUND_LOWER -= tracks.get_child(0).HEIGHT
	if $Player.position.y > TRACK_BOUND_LOWER:
		$Player.position.y -= mov

## Spawner
func spawn_data(data):
	match(data['type']):
		'point':
			spawn_point(data)
		'obstacle_static':
			spawn_obstacle(data)
		'obstacle_blocking':
			spawn_blocking_obstacle(data)
		_:
			pass
func spawn_point(data):
	$DataSpawner.create_point(
		tracks.get_child(
			data['track']).position.y, 
			data['track'])
func spawn_obstacle(data):
	$DataSpawner.create_static_obstacle(
		tracks.get_child(data['track']).position.y,
		data['obst_type'])
func spawn_blocking_obstacle(data):
	pass

## Mode Switching
func switch_mode(mode_to):
	pass
func switch_to_simonsays():
	pass
func switch_to_regular():
	pass
