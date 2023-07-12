extends Polygon2D


var parent = null
var tween = null


func set_parent(parent_) -> void:
	parent = parent_
	set_vertexs()


func set_vertexs() -> void:
	var corners = 4
	var r = Global.num.size.flock.r
	var vertexs = []
	
	for _i in corners:
		var angle = -2 * PI * _i / corners
		var vertex = Vector2(0, -1).rotated(angle) * r 
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func start_chewing_bush() -> void:
	print("start_chewing_bush")
	var time = Global.num.time.chewing
	tween = create_tween()
	tween.tween_property(self, "rotation", PI * 0.5, time)
	tween.tween_property(self, "rotation", -PI * 0.5, time)
	tween.tween_callback(finish_chewing_bush)


func finish_chewing_bush() -> void:
	print("finish_chewing_bush")
	var plant = parent.obj.spot.obj.plant
	var throughput = {}
	throughput.standard = Global.dict.prey.title[parent.word.subclass].throughput
	
	var preys = []
	preys.append_array(parent.arr.prey)
	preys.erase(parent.obj.leader)
	throughput.current = min(throughput.standard, plant.num.area)
	parent.obj.leader.chew(throughput.current)
	plant.num.area -= throughput.current
	
	while plant.num.area > 0 and preys.size() > 0:
		var prey = preys.pick_random()
		preys.erase(prey)
		throughput.current = min(throughput.standard, plant.num.area)
		prey.chew(throughput.current)
		plant.num.area -= throughput.current
	
	if plant.num.area > 0:
		start_chewing_bush()
	else:
		start_grazing()


func start_grazing() -> void:
	print("start_grazing")
	parent.set_grazing_spot()
	start_moving()


func start_moving() -> void:
	print("start_moving")
	var distance = parent.obj.spot.num.boundary
	
	if parent.obj.migrate.location == null:
		distance *= 3
	
	var time = distance / parent.num.speed 
	tween = create_tween()
	tween.tween_property(self, "rotation", -PI * 0.5, time)
	tween.tween_property(self, "rotation", PI * 0.5, time)
	tween.tween_callback(finish_moving)


func finish_moving() -> void:
	print("finish_moving")
	if parent.obj.migrate.location == null:
		parent.step_on_spot(parent.obj.moving)
	else:
		parent.step_into_location(parent.obj.migrate.location)
	
	if parent.obj.migrate.spot == parent.obj.moving:
		parent.set_spot_to_migrate()
		start_moving()
		return
	
	parent.grazing()
