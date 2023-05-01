extends AudioStreamPlayer

var time_begin
var time_delay

var gameplay_track_details = {}
var gameplay_events = []

func load_track(res_path, gameplay):
	stream = load(res_path)
	var file = FileAccess.open(gameplay, FileAccess.READ)
	var txt = file.get_as_text()
	file.close()
	gameplay_track_details = JSON.parse_string(txt)
	gameplay_events = gameplay_track_details['game_elements']

func start():
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	play()
	
func pause():
	pass

@onready var parent = get_parent()
func _process(delta):
	var time = (Time.get_ticks_usec() - time_begin) / 1_000_000.0
	time -= time_delay
	time = max(0, time)
	while gameplay_events.size() > 0 and time > gameplay_events[0]['time']:
		print("Time is: ", time)
		var dt = gameplay_events.pop_front()
		parent.spawn_data(dt)

