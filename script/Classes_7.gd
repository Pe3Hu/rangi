extends Node


#Аванпост outpost 
class Outpost:
	var arr = {}
	var obj = {}


	func _init(input_: Dictionary):
		obj.corporation = input_.corporation
		obj.planet = null
		arr.edifice = []
		#place_core()


	func place_core() -> void:
		var input = {}
		input.tool = null
		input.title = "170"
		input.types = []
		input.core = true
		
		for _i in 4:
			input.types.append("wall")
			input.types.append("adaptive compartment")
		
		var schematic = Classes_7.Schematic.new(input)
		input = {}
		input.schematic = schematic
		var grid_center = Vector2(Global.num.size.continent.col/2, Global.num.size.continent.row/2)
		input.cluster = obj.continent.arr.sector[grid_center.y][grid_center.x].obj.cluster
		var edifice = Classes_7.Edifice.new(input)
		arr.edifice.append(edifice)


	func erect_edifice(schematic_: Schematic, cluster_: Classes_6.Cluster) -> void:
		var input = {}
		input.schematic = schematic_
		input.cluster = cluster_
		var edifice = Classes_7.Edifice.new(input)


#сооружение edifice 
class Edifice:
	var obj = {}


	func _init(input_: Dictionary):
		obj.schematic = input_.schematic
		obj.cluster = input_.cluster
		obj.continent = obj.cluster.obj.continent
		erect_compartment()


	func erect_compartment() -> void:
		for compartment in obj.schematic.arr.compartment:
			var grid_sector = obj.cluster.obj.center.vec.grid + compartment.vec.direction
			var sector = obj.continent.arr.sector[grid_sector.y][grid_sector.x]
			sector.obj.compartment = compartment
			compartment.obj.sector = sector
			compartment.obj.edifice = self
			sector.scene.myself.recolor_based_on_compartment()


#Схема сооружения schematic 
class Schematic:
	var arr = {}
	var obj = {}
	var dict = {}
	var flag = {}
	var word = {}


	func _init(input_: Dictionary):
		arr.type = input_.types
		obj.tool = input_.tool
		word.title = input_.title
		flag.core = input_.core
		init_compartments()


	func init_compartments() -> void:
		arr.compartment = []
		var index = 0
		
		if arr.type.size() == 0:
			get_random_types()
		
		for _i in Global.num.size.cluster.n:
			for _j in Global.num.size.cluster.n:
				var input = {}
				input.grid = Vector2(_j, _i)
				input.schematic = self
				input.direction = Vector2.ZERO
				
				if input.grid != Vector2.ONE:
					input.direction = Vector2.ONE - input.grid
					var windrose = Global.arr.windrose_shifted[index]
					var index_ = Global.arr.windrose.find(windrose)
					input.type = arr.type[index_]
					index += 1
				else:
					if flag.core:
						input.type = "core"
					else:
						input.type = "gateway"
				
				var compartment = Classes_7.Compartment.new(input)
				arr.compartment.append(compartment)


	func get_random_types() -> void:
		var options = []
		options.append_array(Global.dict.compartment.active)
		var schematic = Global.dict.schematic.title[word.title]
		var n = pow(Global.num.size.cluster.n, 2) - 1
		
		for _i in n:
			arr.type.append("wall")
		
		for association in schematic.associations:
			var type = options.pick_random()
			
			for _i in association:
				arr.type[_i] = type


#Отсек compartment  
class Compartment:
	var obj = {}
	var vec = {}
	var dict = {}
	var word = {}
	var color = {}
	var scene = {}


	func _init(input_: Dictionary):
		obj.schematic = input_.schematic
		obj.edifice = null
		obj.sector = null
		vec.grid = input_.grid
		vec.direction = input_.direction
		word.type = input_.type
		color.bg = null
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.compartment.instantiate()
		scene.myself.set_parent(self)
