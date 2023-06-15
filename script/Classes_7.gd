extends Node


#Аванпост outpost 
class Outpost:
	var arr = {}
	var obj = {}


	func _init(input_: Dictionary):
		obj.corporation = input_.corporation
		obj.director = obj.corporation.obj.director
		obj.director.obj.outpost = self
		obj.planet = null
		arr.edifice = []
		arr.worksite  = []
		init_conveyor()


	func init_conveyor() -> void:
		var input = {}
		input.outpost = self
		obj.conveyor = Classes_7.Conveyor.new(input)


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
		var grid_center = Vector2(Global.num.size.continent.col/2, Global.num.size.continent.row/2)
		var cluster = obj.continent.arr.sector[grid_center.y][grid_center.x].obj.cluster
		erect_edifice(schematic, cluster)


	func erect_edifice(schematic_: Schematic, cluster_: Classes_6.Cluster) -> void:
		var input = {}
		input.schematic = schematic_
		input.cluster = cluster_
		var edifice = Classes_7.Edifice.new(input)
		arr.edifice.append(edifice)
		update_worksite(edifice)


	func update_worksite(edifice_: Edifice) -> void:
		for cluster in edifice_.obj.cluster.dict.neighbor:
			if cluster.obj.edifice == null and !arr.worksite.has(cluster):
				arr.worksite.append(cluster)


#Конвейер conveyor 
class Conveyor:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary):
		obj.outpost = input_.outpost
		arr.schematic = []
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.conveyor.instantiate()
		scene.myself.set_parent(self)
		obj.outpost.obj.director.scene.myself.get_node("VBox").add_child(scene.myself)


	func apply_tool(tool_: Classes_3.Tool) -> void:
		arr.schematic.append(tool_.obj.schematic)
		scene.myself.add_tool(tool_)
		get_relevant_worksites(tool_.obj.schematic)


	func get_relevant_worksites(schematic_: Schematic) -> void:
		var clusters = []
		
		#overlay_schematic_on_cluster(schematic_, obj.outpost.arr.worksite.front())
		
		for cluster in obj.outpost.arr.worksite:
			
			overlay_schematic_on_cluster(schematic_, cluster)
			clusters.append(cluster)
			#cluster.paint_black()


	func overlay_schematic_on_cluster(schematic_: Schematic, cluster_: Classes_6.Cluster) -> bool:
		for compartment in schematic_.arr.compartment:
			var grid = cluster_.obj.center.vec.grid + compartment.vec.direction
			print("_______", grid)
			var sector = cluster_.obj.continent.arr.sector[grid.y][grid.x]
			var windrose_compartment = Global.get_windrose(compartment.vec.direction)
			sector.scene.myself.set_color(compartment.color.bg)
			
			for side in Global.dict.side.windrose:
				if Global.dict.side.windrose[side].has(windrose_compartment):
					var direction = Global.dict.side.direction[side]
					var windrose_side = Global.get_windrose(direction)
					
					for neighbor_sector in sector.dict.neighbor:
						if neighbor_sector.obj.compartment != null and sector.dict.neighbor[neighbor_sector] == windrose_side:
							print(compartment.word.type, neighbor_sector.obj.compartment.word.type)
							
							#if neighbor_sector.obj.compartment.word.type == compartment.word.type:
							#	sector.scene.myself.paint_black()
		
		return true


	func overlay_schematic_on_cluster_old(schematic_: Schematic, cluster_: Classes_6.Cluster) -> bool:
		for neighbor_cluster in cluster_.dict.neighbor:
			if neighbor_cluster.obj.edifice != null:
				var windrose_original = cluster_.dict.neighbor[neighbor_cluster]
				var a = Global.dict.windrose.reverse
				var windrose_reversed = Global.dict.windrose.reverse[windrose_original]
				
				for _i in cluster_.arr.sector.size():
					var sector = cluster_.arr.sector[_i]
					
					for neighbor_sector in sector.dict.neighbor:
						if sector.dict.neighbor[neighbor_sector] == windrose_original and neighbor_sector.obj.cluster == neighbor_cluster:
							
							var index = _i
							
							if index > 4:
								pass
							
							var type_compartment = Global.arr.windrose
							#sector.scene.myself.paint_black()
							pass
			#print(cluster_.dict.neighbor)
		
		return true



#сооружение edifice 
class Edifice:
	var obj = {}


	func _init(input_: Dictionary):
		obj.schematic = input_.schematic
		obj.cluster = input_.cluster
		obj.cluster.obj.edifice = self
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
