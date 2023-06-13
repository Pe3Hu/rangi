extends Node


func _ready() -> void:
	Global.obj.cosmos = Classes_0.Cosmos.new()
	#datas.sort_custom(func(a, b): return a.value < b.value) 
	#012

func _input(event) -> void:
	var factory = Global.obj.cosmos.arr.corporation.front().obj.factory
	
	if event is InputEventKey:
		match event.keycode:
			KEY_D:
				if event.is_pressed() && !event.is_echo():
					factory.shift_selected_stamp(Vector2(1, 0))
			KEY_S:
				if event.is_pressed() && !event.is_echo():
					factory.shift_selected_stamp(Vector2(0, 1))
			KEY_A:
				if event.is_pressed() && !event.is_echo():
					factory.shift_selected_stamp(Vector2(-1, 0))
			KEY_W:
				if event.is_pressed() && !event.is_echo():
					factory.shift_selected_stamp(Vector2(0, -1))
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					factory.press_stamps()


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())

