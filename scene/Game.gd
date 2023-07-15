extends Node


func _ready() -> void:
	#Global.node.spots_stock = Global.scene.packed_spots_stock.instantiate()
	#Global.node.game.get_node("Layer0").add_child(Global.node.spots_stock)
	#Global.obj.cosmos = Classes_0.Cosmos.new()
	
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
	
	#Global.obj.cosmos.obj.planet.obj.sanctuary.init_clashes()
	#Global.pack_scene(Global.obj.cosmos.scene.myself, "cosmos")
	
	#Global.set_spots_map()
	
	
	for _i in 1000:
		var a = Global.scene.packed_spots.instantiate(0)
		Global.node.game.get_node("Layer0").add_child(a)
	pass


#func _input(event) -> void:
#	var branch = Global.obj.cosmos.obj.planet.arr.outpost.front().arr.branch.front()
#	var beast = Global.obj.cosmos.obj.planet.obj.sanctuary.obj.zoo.arr.beast.front()
#
#	if event is InputEventKey:
#		match event.keycode:
#			KEY_D:
#				if event.is_pressed() && !event.is_echo():
#					#branch.obj.factory.shift_selected_stamp(Vector2(1, 0))
#					#beast.obj.chain.expend_resource("overheat", 10)
#					Global.obj.cosmos.obj.planet.obj.sanctuary.select_next_habitat(1)
#			KEY_S:
#				if event.is_pressed() && !event.is_echo():
#					branch.obj.factory.shift_selected_stamp(Vector2(0, 1))
#			KEY_A:
#				if event.is_pressed() && !event.is_echo():
#					#branch.obj.factory.shift_selected_stamp(Vector2(-1, 0))
#					#beast.obj.chain.expend_resource("overheat", -10)
#					Global.obj.cosmos.obj.planet.obj.sanctuary.select_next_habitat(-1)#paint_next_forest()
#			KEY_W:
#				if event.is_pressed() && !event.is_echo():
#					branch.obj.factory.shift_selected_stamp(Vector2(0, -1))
#			KEY_Q:
#				if event.is_pressed() && !event.is_echo():
#					branch.obj.outpost.obj.conveyor.rotate_first_schematic(true)
#			KEY_E:
#				if event.is_pressed() && !event.is_echo():
#					branch.obj.outpost.obj.conveyor.rotate_first_schematic(false)
#			KEY_R:
#				if event.is_pressed() && !event.is_echo():
#					branch.obj.outpost.obj.conveyor.next_worksite()
#			KEY_F:
#				if event.is_pressed() && !event.is_echo():
#					branch.obj.outpost.obj.conveyor.establish_on_best_worksite()
#			KEY_Z:
#				if event.is_pressed() && !event.is_echo():
#					branch.obj.outpost.obj.conveyor.decide_which_worksite_to_build_on()
#			KEY_X:
#				if event.is_pressed() && !event.is_echo():
#					branch.obj.director.prioritize()
#			KEY_SPACE:
#				if event.is_pressed() && !event.is_echo():
#					#branch.obj.factory.press_stamps()
#					Global.obj.cosmos.obj.planet.obj.sanctuary.select_next_habitat()#paint_next_forest()
#

func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())

