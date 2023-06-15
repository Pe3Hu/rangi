extends Node


#Скопление cluster
class Cluster:
	var arr = {}
	var num = {}
	var obj = {}
	var vec = {}
	var dict = {}


	func _init(input_: Dictionary):
		num.index = Global.num.index.cluster
		Global.num.index.cluster += 1
		obj.continent = input_.continent
		obj.edifice = null
		vec.grid = input_.grid
		dict.neighbor = {}
		set_sectors()


	func set_sectors() -> void:
		arr.sector = []
		var grid_center = vec.grid * Global.num.size.cluster.n + Vector2.ONE
		obj.center = obj.continent.arr.sector[grid_center.y][grid_center.x]
		arr.sector.append(obj.center)
		
		for sector in obj.center.dict.neighbor:
			arr.sector.append(sector)
		
		for sector in arr.sector:
			sector.obj.cluster = self
			sector.scene.myself.update_color_by_cluster()


	func paint_black() -> void:
		for sector in arr.sector:
			sector.scene.myself.paint_black()


#Область sector
class Sector:
	var num = {}
	var obj = {}
	var vec = {}
	var dict = {}
	var flag = {}
	var scene = {}


	func _init(input_):
		obj.continent = input_.continent
		obj.cluster = null
		obj.compartment = null
		vec.grid = input_.grid
		num.index = Global.num.index.sector
		Global.num.index.sector += 1
		dict.neighbor = {}
		flag.onscreen = true
		set_piliers()
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.sector.instantiate()
		obj.continent.scene.myself.get_node("Sector").add_child(scene.myself)
		scene.myself.set_parent(self)


	func set_piliers() -> void:
		dict.pilier = {}
		
		for _i in Global.dict.neighbor.zero.size():
			var direction = Global.dict.neighbor.zero[_i]
			var grid = direction + vec.grid
			var pilier = obj.continent.arr.pilier[grid.y][grid.x]
			var index_windrose = _i * 2
			var windrose = Global.arr.windrose[index_windrose]
			dict.pilier[pilier] = windrose


#Граница frontière
class Frontière:
	var arr = {}
	var obj = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary):
		obj.continent = input_.continent
		arr.pilier = input_.piliers
		arr.terres = []
		word.terrain = null
		set_pilier_as_neighbors()
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.frontière.instantiate()
		obj.continent.scene.myself.get_node("Frontière").add_child(scene.myself)
		scene.myself.set_parent(self)


	func set_pilier_as_neighbors() -> void:
		var directions = []
		var direction = arr.pilier.front().vec.grid - arr.pilier.back().vec.grid
		directions.append(direction)
		direction = arr.pilier.back().vec.grid - arr.pilier.front().vec.grid
		directions.append(direction)
		arr.pilier.front().dict.neighbor[arr.pilier.back()] = directions.front()
		arr.pilier.back().dict.neighbor[arr.pilier.front()] = directions.front()


	func set_terrain() -> void:
		if word.terrain == null:
			for terres in arr.terres:
				if terres.word.terrain != null:
					word.terrain = terres.word.terrain
					scene.myself.update_color_by_terrain()


#Столб pilier 
class Pilier:
	var obj = {}
	var vec = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary):
		vec.grid = input_.grid
		obj.continent = input_.continent
		dict.neighbor = {}
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.pilier.instantiate()
		obj.continent.scene.myself.get_node("Pilier").add_child(scene.myself)
		scene.myself.set_parent(self)


	func set_terrain() -> void:
		pass



