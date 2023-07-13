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
	#print("start_chewing_bush")
	if parent.num.hunger > 0:
		parent.num.hunger = 0
		parent.num.migration -= 1
	
	var time = Global.num.time.chewing
	tween = create_tween()
	tween.tween_property(self, "rotation", PI * 0.5, time)
	tween.tween_property(self, "rotation", -PI * 0.5, time)
	tween.tween_callback(finish_chewing_bush)


func finish_chewing_bush() -> void:
	var plant = parent.obj.spot.obj.plant
	
	if plant != null and parent.obj.spot.word.content == "bush":
		var throughput = {}
		throughput.standard = Global.dict.prey.title[parent.word.subclass].throughput * 10
		
		#print("Before ", plant.num.area)
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
		#print("After ", plant.num.area)
		if plant.num.area > 0:
			#print("self start_chewing_bush")
			start_chewing_bush()
		else:
			#print("not self finish_chewing_bush")
			plant.fade()
			start_grazing()


func start_grazing() -> void:
	if parent.num.migration < Global.num.time.migration:
		#print("start_grazing set_grazing_spot")
		parent.set_grazing_spot()
	else:
		#print("start migrate")
		parent.set_spot_to_migrate()
	
	start_moving()
	#print("start_moving")


func start_moving() -> void:
	var distance = parent.obj.spot.num.boundary
	
	if parent.obj.migrate.location == null:
		distance *= 2
	
	if parent.obj.migrate.habitat == null:
		distance *= 4
	
	var time = distance / parent.num.speed 
	tween = create_tween()
	tween.tween_property(self, "rotation", -PI * 0.5, time)
	tween.tween_property(self, "rotation", PI * 0.5, time)
	tween.tween_callback(finish_moving)


func finish_moving() -> void:
	#print("finish_moving")
	if parent.obj.migrate.habitat != null:
		#print("step_into_habitat")
		parent.step_into_habitat()
		return
	
	#print("parent.obj.moving", parent.obj.moving)
	if parent.obj.moving != null:
		#print("finish_moving")
		if parent.obj.migrate.location == null:
			#print("step_on_spot")
			parent.step_on_spot(parent.obj.moving)
		else:
			#print("step_into_location")
			parent.step_into_location(parent.obj.migrate.location)
		
		if parent.obj.migrate.spot == parent.obj.moving:
			#print("set_spot_to_migrate")
			parent.set_spot_to_migrate()
			start_moving()
			return
		
		#print("parent.grazing")
		parent.grazing()
	else:
		pass
		#print("error parent.obj.moving != null")
