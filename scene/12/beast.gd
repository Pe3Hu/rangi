extends Polygon2D


var parent = null
var tween = null


func set_parent(parent_) -> void:
	parent = parent_
	set_vertexs()


func set_vertexs() -> void:
	var corners = 4
	var r = Global.num.size.beast.r
	var vertexs = []
	
	for _i in corners:
		var angle = -2 * PI * _i / corners
		var vertex = Vector2(0, -1).rotated(angle) * r 
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func perform_task() -> void:
	var time = 0.1
	tween = create_tween()
	tween.tween_property(self, "rotation", PI * 0.5, time)
	tween.tween_property(self, "rotation", -PI * 0.5, time)
	#tween.tween_property(self, "skew", PI, time * 0.5)
	#tween.tween_property(self, "skew", 0, time * 0.5)
	tween.tween_callback(call_follow_phase)


func call_follow_phase() -> void:
	var phase = parent.get_follow_phase()
	print(phase)
	
	if phase != null:
		var words = phase.split(" ")
		var func_name = ""
		
		for _i in words.size():
			var word = words[_i]
			func_name += word
			
			if _i != words.size()-1:
				func_name += "_"
		
		Callable(parent, func_name).call()
	else:
		parent.close_primary_task()
		
		if parent.flag.cycle and parent.arr.task.is_empty():
			parent.get_new_task()
			perform_task()


func start_action_in_combat_mode() -> void:
	if parent.obj.target != null and parent.flag.alive:
		#var time = 0.1
		#tween = create_tween()
		#tween.tween_property(self, "rotation", PI * 0.5, time)
		#tween.tween_property(self, "rotation", -PI * 0.5, time)
		#tween.tween_property(self, "skew", PI, time * 0.5)
		#tween.tween_property(self, "skew", 0, time * 0.5)
		#tween.tween_property(self, "skew", 0, time * 1)
		#tween.tween_callback(decide_in_combat_mode)
		decide_in_combat_mode()


func decide_in_combat_mode() -> void:
	parent.choose_tactic()
	
	match parent.word.tactic.current:
		"attack":
			parent.choose_skill()
			
			begin_preparing_skill()
		"respite":
			parent.choose_respite_resource()
			begin_preparing_respite()


func begin_preparing_skill() -> void:
	var description = Global.dict.skill.title[parent.word.skill.title]
	var multiplier = {}
	multiplier.aspect = Global.arr.beast.roll["modify time"]
	parent.obj.chain.obj.dice.aspect[multiplier.aspect].roll()
	multiplier.value = parent.obj.chain.obj.dice.aspect[multiplier.aspect].obj.edge.get_value()
	
	parent.num.skill.finish = Global.obj.cosmos.get_time() + (description.preparation + description.cast) * multiplier.value 
	parent.word.skill.stage = "preparing"
	parent.attempt_to_hide_threat()
	
	var time = description.preparation
	tween = create_tween()
	tween.tween_property(self, "rotation", PI * 0.5, time)
	tween.tween_property(self, "rotation", -PI * 0.5, time)
	tween.tween_callback(begin_casting_skill)


func begin_casting_skill() -> void:
	if parent.obj.target != null and parent.flag.alive:
		parent.word.skill.stage = "casting"
		parent.attempt_to_hide_threat()
		var multiplier = {}
		multiplier.aspect = Global.arr.beast.roll["modify time"]
		multiplier.value = parent.obj.chain.obj.dice.aspect[multiplier.aspect].obj.edge.get_value()
		var time = Global.dict.skill.title[parent.word.skill.title].cast * multiplier.value
		
		tween = create_tween()
		tween.tween_property(self, "rotation", -PI * 0.5, time)
		tween.tween_property(self, "rotation", PI * 0.5, time)
		tween.tween_callback(finish_casting_skill)


func finish_casting_skill() -> void:
	if parent.obj.target != null and parent.flag.alive:
		parent.obj.chain.expend_resources()
		parent.activate_skill()
		start_action_in_combat_mode()


func begin_preparing_respite() -> void:
	var multiplier = {}
	multiplier.aspect = Global.arr.beast.roll["modify time"]
	multiplier.value = parent.obj.chain.obj.dice.aspect[multiplier.aspect].obj.edge.get_value()
	var time = Global.dict.skill.title[parent.word.skill.title].preparation * multiplier.value
	
	tween = create_tween()
	tween.tween_property(self, "skew", PI, time * 0.5)
	tween.tween_property(self, "skew", 0, time * 0.5)
	tween.tween_callback(finish_preparing_respite)


func finish_preparing_respite() -> void:
	if parent.flag.alive:
		parent.obj.chain.reduce_overlimit()
		start_action_in_combat_mode()


func stop_skill() -> void:
	tween.stop()
	tween = create_tween()
	var time = 0
	tween.tween_property(self, "rotation", 0, time)


