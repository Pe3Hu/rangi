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
	tween.tween_property(self, "skew", PI, time / 2)
	tween.tween_property(self, "skew", 0, time / 2)
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
		parent.close_current_task()
		parent.get_new_task()
		perform_task()

