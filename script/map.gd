
extends Navigation2D

var begin = Vector2()
var end = Vector2()
var path = []
var player = Object()

func _process(delta):
	if (path.size() > 1):
		var to_walk = delta * player.MOVE_SPEED
		while(to_walk > 0 and path.size() >= 2):
			var pfrom = path[path.size() - 1]
			var pto = path[path.size() - 2]
			var d = pfrom.distance_to(pto)
			if (d <= to_walk):
				path.remove(path.size() - 1)
				to_walk -= d
			else:
				path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk/d)
				to_walk = 0
		
		var atpos = path[path.size() - 1]
		player.go_to(atpos)
		
		if (player.is_colliding()):
			path = []
			set_process(false)
			player.play_direction_anim(false)
		
		if (path.size() < 2):
			path = []
			set_process(false)
			player.play_direction_anim(false)
	else:
		set_process(false)
		player.play_direction_anim(false)

func _update_path():
	var p = get_simple_path(begin, end, true)
	path = Array(p)
	path.invert()
	set_process(true)

func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed and event.button_index == 1):
		begin = player.get_pos()
		end = get_global_mouse_pos()
		player.set_direction(end)
		player.play_direction_anim(true)
		_update_path()

func _ready():
	player = get_parent().get_node("player")
	set_process_input(true)