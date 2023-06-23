extends Node


func _ready() -> void:
	Global.obj.cosmos = Classes_0.Cosmos.new()
	#datas.sort_custom(func(a, b): return a.value < b.value) 
	#012
	
#	var outpost = Global.obj.cosmos.obj.planet.arr.outpost.front()
#	outpost.place_core()
#
#	for branch in outpost.arr.branch:
#		branch.obj.director.promote_starter_schematics()
#
#	outpost.obj.conveyor.establish_starter_schematics()
#	outpost.arr.branch.front().obj.director.prioritize()


func _input(event) -> void:
	var branch = Global.obj.cosmos.obj.planet.arr.outpost.front().arr.branch.front()
	
	if event is InputEventKey:
		match event.keycode:
			KEY_D:
				if event.is_pressed() && !event.is_echo():
					branch.obj.factory.shift_selected_stamp(Vector2(1, 0))
			KEY_S:
				if event.is_pressed() && !event.is_echo():
					branch.obj.factory.shift_selected_stamp(Vector2(0, 1))
			KEY_A:
				if event.is_pressed() && !event.is_echo():
					branch.obj.factory.shift_selected_stamp(Vector2(-1, 0))
			KEY_W:
				if event.is_pressed() && !event.is_echo():
					branch.obj.factory.shift_selected_stamp(Vector2(0, -1))
			KEY_Q:
				if event.is_pressed() && !event.is_echo():
					branch.obj.outpost.obj.conveyor.rotate_first_schematic(true)
			KEY_E:
				if event.is_pressed() && !event.is_echo():
					branch.obj.outpost.obj.conveyor.rotate_first_schematic(false)
			KEY_R:
				if event.is_pressed() && !event.is_echo():
					branch.obj.outpost.obj.conveyor.next_worksite()
			KEY_F:
				if event.is_pressed() && !event.is_echo():
					branch.obj.outpost.obj.conveyor.establish_on_best_worksite()
			KEY_Z:
				if event.is_pressed() && !event.is_echo():
					branch.obj.outpost.obj.conveyor.decide_which_worksite_to_build_on()
			KEY_X:
				if event.is_pressed() && !event.is_echo():
					branch.obj.director.prioritize()
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					#branch.obj.factory.press_stamps()
					Global.obj.cosmos.obj.planet.obj.sanctuary.paint_next_forest()


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())

