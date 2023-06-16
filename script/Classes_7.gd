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
		var n = 2
		var diagonals = []
		var linears = []
		
		for _i in n:
			diagonals.append("wall")
			diagonals.append("wall")
			linears.append("adaptive compartment")
			linears.append("power generator")
		
		linears.shuffle()
		
		for _i in diagonals.size():
			input.types.append(diagonals[_i])
			input.types.append(linears[_i])
		
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
		for cluster in obj.outpost.arr.worksite:
			cluster.paint_cluster()
		
		var clusters = []
		
		for cluster in obj.outpost.arr.worksite:
			if overlay_schematic_on_cluster(schematic_, cluster):
				clusters.append(cluster)
				cluster.paint_black()
				#sector.scene.myself.set_color(compartment.color.bg)


	func overlay_schematic_on_cluster(schematic_: Schematic, cluster_: Classes_6.Cluster) -> bool:
		var relevant = true
		
		for compartment in schematic_.dict.compartment:
			var grid = cluster_.obj.center.vec.grid + compartment.vec.direction
			var sector = cluster_.obj.continent.arr.sector[grid.y][grid.x]
			var windrose_compartment = Global.get_windrose(compartment.vec.direction)
			
			for side in Global.dict.side.windrose:
				if Global.dict.side.windrose[side].has(windrose_compartment):
					var direction = Global.dict.side.direction[side]
					var windrose_side = Global.get_windrose(direction)
					
					for neighbor_sector in sector.dict.neighbor:
						if neighbor_sector.obj.compartment != null and sector.dict.neighbor[neighbor_sector] == windrose_side:
							relevant = relevant and compartment.compatibility_check(neighbor_sector.obj.compartment)
		
		return relevant


	func rotate_first_schematic(clockwise_: bool) -> void:
		var schematic = arr.schematic.front()
		schematic.rotate(clockwise_)
		schematic.redraw_icon()
		get_relevant_worksites(schematic)


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
		for compartment in obj.schematic.dict.compartment:
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
		obj.tool = input_.tool
		word.title = input_.title
		flag.core = input_.core
		init_compartments(input_.types)


	func init_compartments(types_: Array) -> void:
		dict.compartment = {}
		var index = 0
		
		if types_.size() == 0:
			types_.append_array(get_random_types())
		
		for _i in Global.num.size.cluster.n:
			for _j in Global.num.size.cluster.n:
				var input = {}
				input.grid = Vector2(_j, _i)
				input.schematic = self
				input.direction = Vector2.ZERO
				
				if input.grid != Vector2.ONE:
					input.direction =  input.grid - Vector2.ONE
					var windrose = Global.arr.windrose_shifted[index]
					var index_ = Global.arr.windrose.find(windrose)
					input.type = types_[index_]
					index += 1
				else:
					if flag.core:
						input.type = "core"
					else:
						input.type = "gateway"
				
				var compartment = Classes_7.Compartment.new(input)
				dict.compartment[compartment] = input.direction


	func get_random_types() -> Array:
		var types = []
		var options = []
		options.append_array(Global.dict.compartment.active)
		var schematic = Global.dict.schematic.title[word.title]
		var n = pow(Global.num.size.cluster.n, 2) - 1
		
		for _i in n:
			types.append("wall")
		
		for association in schematic.associations:
			var type = options.pick_random()
			
			for _i in association:
				types[_i] = type
		
		return types


	func rotate(clockwise_: bool) -> void:
		var rotated = []
		var windroses = null
		
		if clockwise_:
			windroses = Global.dict.windrose.next
		else:
			windroses = Global.dict.windrose.previous
		
		for current_compartment in dict.compartment:
			if current_compartment.word.windrose != null:
				var next_windrose = windroses[current_compartment.word.windrose] 
				var next_compartment = get_compartment(next_windrose)
				current_compartment.swap_reparation_with(next_compartment)
		
		for compartment in dict.compartment:
			compartment.swap()


	func get_compartment(windrose_: String) -> Variant:
		for compartment in dict.compartment:
			if compartment.word.windrose == windrose_:
				return compartment
		
		return null


	func redraw_icon() -> void:
		obj.tool.obj.icon.scene.myself.clean()
		obj.tool.obj.icon.scene.myself.fill_based_on_tool()


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
		word.type = {}
		word.type.current = input_.type
		word.type.next = null
		word.windrose = Global.get_windrose(vec.direction)
		color.bg = null
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.compartment.instantiate()
		scene.myself.set_parent(self)


	func compatibility_check(compartment_: Compartment) -> bool:
		var compatibility = false
		var types = []
		types.append(word.type.current)
		types.append(compartment_.word.type.current)
		
		if types.front() == types.back():
			compatibility = true
		
		if types.has("adaptive compartment"):
			if !types.has("wall"):
				compatibility = true
		
		return compatibility


	func swap_reparation_with(compartment_: Compartment) -> void:
		word.type.next = str(compartment_.word.type.current)


	func swap() -> void:
		if word.type.next != null:
			word.type.current = str(word.type.next)
			word.type.next = null
		
		scene.myself.update_color_based_on_type()

