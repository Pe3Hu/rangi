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
		var time = 0.1
		tween = create_tween()
		#tween.tween_property(self, "rotation", PI * 0.5, time)
		#tween.tween_property(self, "rotation", -PI * 0.5, time)
		tween.tween_property(self, "skew", PI, time * 0.5)
		tween.tween_property(self, "skew", 0, time * 0.5)
		tween.tween_callback(decide_in_combat_mode)


func decide_in_combat_mode() -> void:
	parent.choose_tactic()
	
	match parent.word.tactic.current:
		"attack":
			parent.choose_skill()
			begin_preparing_skill()


func begin_preparing_skill() -> void:
	var time = Global.dict.skill.title[parent.word.skill.current].preparation * 0.1
	tween = create_tween()
	tween.tween_property(self, "rotation", PI * 0.5, time)
	tween.tween_property(self, "rotation", -PI * 0.5, time)
	#tween.tween_property(self, "skew", PI, time * 0.5)
	#tween.tween_property(self, "skew", 0, time * 0.5)
	tween.tween_callback(finish_preparing_skill)


func finish_preparing_skill() -> void:
	if parent.obj.target != null and parent.flag.alive:
		parent.obj.chain.expend_resources()
		parent.activate_skill()
		start_action_in_combat_mode()


