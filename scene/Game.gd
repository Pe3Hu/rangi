extends Node


func _ready() -> void:
	Global.obj.cosmos = Classes_0.Cosmos.new()
	#datas.sort_custom(func(a, b): return a.value < b.value) 
	#012
	
	var corporation = Global.obj.cosmos.arr.corporation.front()
	corporation.obj.outpost.place_core()
	corporation.obj.factory.press_stamps()

func _input(event) -> void:
	var corporation = Global.obj.cosmos.arr.corporation.front()
	
	if event is InputEventKey:
		match event.keycode:
			KEY_D:
				if event.is_pressed() && !event.is_echo():
					corporation.obj.factory.shift_selected_stamp(Vector2(1, 0))
			KEY_S:
				if event.is_pressed() && !event.is_echo():
					corporation.obj.factory.shift_selected_stamp(Vector2(0, 1))
			KEY_A:
				if event.is_pressed() && !event.is_echo():
					corporation.obj.factory.shift_selected_stamp(Vector2(-1, 0))
			KEY_W:
				if event.is_pressed() && !event.is_echo():
					corporation.obj.factory.shift_selected_stamp(Vector2(0, -1))
			KEY_Q:
				if event.is_pressed() && !event.is_echo():
					corporation.obj.outpost.obj.conveyor.rotate_first_schematic(true)
			KEY_E:
				if event.is_pressed() && !event.is_echo():
					corporation.obj.outpost.obj.conveyor.rotate_first_schematic(false)
			KEY_R:
				if event.is_pressed() && !event.is_echo():
					corporation.obj.outpost.obj.conveyor.next_worksite()
			KEY_F:
				if event.is_pressed() && !event.is_echo():
					corporation.obj.outpost.obj.conveyor.find_best_worksite()
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					corporation.obj.factory.press_stamps()
					
					
					


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())

