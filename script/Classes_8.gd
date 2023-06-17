extends Node


#Конвейер conveyor 
class Conveyor:
	var arr = {}
	var num = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.outpost = input_.outpost
		num.worksite = {}
		num.worksite.shift = 0
		arr.schematic = []
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.conveyor.instantiate()
		scene.myself.set_parent(self)
		obj.outpost.scene.myself.get_node("VBox").add_child(scene.myself)
		obj.outpost.scene.myself.get_node("VBox").move_child(scene.myself, 1)


	func apply_tool(tool_: Classes_3.Tool) -> void:
		arr.schematic.append(tool_.obj.schematic)
		scene.myself.add_tool(tool_)
		find_best_worksite()


	func get_relevant_worksites(schematic_: Schematic) -> Array:
		for cluster in obj.outpost.arr.worksite:
			cluster.paint_black()
			#cluster.paint_cluster()
		
		var clusters = []
		
		for cluster in obj.outpost.arr.worksite:
			if overlay_schematic_on_cluster(schematic_, cluster):
				clusters.append(cluster)
		
		return clusters


	func overlay_schematic_on_cluster(schematic_: Schematic, cluster_: Classes_6.Cluster) -> bool:
		var relevant = true
		var wall = true
		
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
							wall = wall and compartment.word.type.current == "wall"
		
		return relevant and !wall


	func rotate_first_schematic(clockwise_: bool) -> void:
		if arr.schematic.size() > 0:
			var schematic = arr.schematic.front()
			schematic.rotate(clockwise_)
			schematic.redraw_icon()
			find_best_worksite()


	func next_worksite() -> void:
		num.worksite.shift += 1
		find_best_worksite()


	func find_best_worksite() -> Variant:
		if arr.schematic.size() > 0:
			var schematic = arr.schematic.front()
			var worksites = get_relevant_worksites(schematic)
			
			if worksites.size() > 0:
				var index = num.worksite.shift % worksites.size()
				var worksite = worksites[index]
				worksite.paint_schematic(schematic)
				return worksite
			
		return null


	func evaluate_worksites() -> Variant:
		var weights = {}
		
		if arr.schematic.size() > 0:
			var schematic = arr.schematic.front()
			var worksites = get_relevant_worksites(schematic)
		
		return weights


	func erect_on_best_worksite() -> void:
		var worksite = find_best_worksite()
		
		if worksite != null:
			var schematic = arr.schematic.front()
			obj.outpost.erect_edifice(schematic, worksite)


#Схема сооружения schematic 
class Schematic:
	var arr = {}
	var obj = {}
	var dict = {}
	var flag = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
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
				
				var compartment = Classes_8.Compartment.new(input)
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
				
				#if next_windrose.length() == 2:
				#print(current_compartment.word.windrose, current_compartment.word.type, next_windrose)
		
		for compartment in dict.compartment:
			if compartment.word.windrose != null:
				compartment.swap()


	func get_compartment(windrose_: Variant) -> Variant:
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


	func _init(input_: Dictionary) -> void:
		obj.schematic = input_.schematic
		obj.edifice = null
		obj.sector = null
		obj.module = null
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
		if word.type.next == null:
			word.type.next = str(compartment_.word.type.current)


	func swap() -> void:
		if word.type.next != null:
			word.type.current = str(word.type.next)
			word.type.next = null
		
		scene.myself.update_color_based_on_type()
		
		if obj.sector != null:
			obj.sector.scene.myself.recolor_based_on_compartment(self)
