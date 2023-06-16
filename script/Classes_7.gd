extends Node


#Аванпост outpost 
class Outpost:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.corporation = input_.corporations
		obj.planet = input_.planet
		arr.edifice = []
		arr.worksite  = []
		arr.module = []
		init_scene()
		init_continent()
		init_branchs()
		init_conveyor()
		init_scoreboard()


	func init_scene() -> void:
		scene.myself = Global.scene.outpost.instantiate()
		scene.myself.set_parent(self)
		obj.planet.scene.myself.get_node("VBox/Outpost").add_child(scene.myself)


	func init_continent() -> void:
		var input = {}
		input.outpost = self
		obj.continent = Classes_0.Continent.new(input)


	func init_branchs() -> void:
		arr.branch = []
		
		for corporation in arr.corporation:
			var input = {}
			input.outpost = self
			input.corporation = corporation
			var branch = Classes_1.Branch.new(input)
			arr.branch.append(branch)


	func init_conveyor() -> void:
		var input = {}
		input.outpost = self
		obj.conveyor = Classes_7.Conveyor.new(input)


	func init_scoreboard() -> void:
		var input = {}
		input.outpost = self
		obj.scoreboard = Classes_7.Scoreboard.new(input)


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
		
		print(arr.module.size())


	func erect_edifice(schematic_: Schematic, cluster_: Classes_6.Cluster) -> void:
		var input = {}
		input.outpost = self
		input.schematic = schematic_
		input.cluster = cluster_
		var edifice = Classes_7.Edifice.new(input)
		arr.edifice.append(edifice)
		update_worksite(edifice)
		obj.conveyor.num.worksite.shift = 0
		
		if obj.conveyor.arr.schematic.has(schematic_):
			obj.conveyor.arr.schematic.erase(schematic_)
			obj.conveyor.scene.myself.remove_schematic(schematic_.obj.tool)


	func update_worksite(edifice_: Edifice) -> void:
		arr.worksite.erase(edifice_.obj.cluster)
		
		for cluster in edifice_.obj.cluster.dict.neighbor:
			if cluster.obj.edifice == null and !arr.worksite.has(cluster):
				arr.worksite.append(cluster)
				cluster.paint_black()


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


	func erect_on_best_worksite() -> void:
		var worksite = find_best_worksite()
		
		if worksite != null:
			var schematic = arr.schematic.front()
			obj.outpost.erect_edifice(schematic, worksite)


#Табло scoreboard 
class Scoreboard:
	var num = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.outpost = input_.outpost
		init_scene()
		init_indicators()


	func init_scene() -> void:
		scene.myself = Global.scene.scoreboard.instantiate()
		scene.myself.set_parent(self)
		obj.outpost.scene.myself.get_node("VBox").add_child(scene.myself)
		obj.outpost.scene.myself.get_node("VBox").move_child(scene.myself, 2)


	func init_indicators() -> void:
		num.indicator = {}
		
		for indicator in Global.dict.indicator:
			num.indicator[indicator] = 0


#сооружение edifice 
class Edifice:
	var obj = {}


	func _init(input_: Dictionary) -> void:
		obj.outpost = input_.outpost
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
			sector.scene.myself.recolor_based_on_compartment(compartment)
			
			if Global.dict.compartment.active.has(compartment.word.type.current):
				add_module(compartment)


	func add_module(compartment_: Compartment) -> void:
		var module = get_module(compartment_)
		
		if module == null:
			var input = {}
			input.outpost = obj.outpost
			input.compartment = compartment_
			module = Classes_7.Module.new(input)
			obj.outpost.arr.module.append(module)
		else:
			module.add_compartment(compartment_)
		
		print(obj.outpost.arr.module.size())


	func get_module(compartment_: Compartment) -> Variant:
		var sector = compartment_.obj.sector
		
		for neighbor in sector.dict.neighbor:
			if neighbor.obj.cluster != sector.obj.cluster and sector.dict.neighbor[neighbor].length() == 1:
				if neighbor.obj.compartment != null:
					return neighbor.obj.compartment.obj.module
		
		return null


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
		word.type.next = str(compartment_.word.type.current)


	func swap() -> void:
		if word.type.next != null:
			word.type.current = str(word.type.next)
			word.type.next = null
		
		scene.myself.update_color_based_on_type()


#Модуль module  
class Module:
	var arr = {}
	var obj = {}
	var dict = {}
	var flag = {}
	var word = {}
 

	func _init(input_: Dictionary) -> void:
		arr.compartment = []
		obj.outpost = input_.outpost
		dict.indicator = {}
		flag.complete = false
		word.type = null
		add_compartment(input_.compartment)
		set_type()
		update_indicators()


	func set_type() -> void:
		for compartment in arr.compartment:
			if Global.dict.compartment.active.has(compartment.word.type.current):
				word.type = str(compartment.word.type.current)
		
		if word.type != null:
			for indicator in Global.dict.indicator:
				if Global.dict.indicator[indicator].has(word.type):
					dict.indicator[indicator] = 0


	func update_indicators() -> void:
		for indicator in dict.indicator:
			obj.outpost.obj.scoreboard.num.indicator[indicator] -= dict.indicator[indicator]
			set_indicator_value(indicator)
			obj.outpost.obj.scoreboard.num.indicator[indicator] += dict.indicator[indicator]
		
		obj.outpost.obj.scoreboard.scene.myself.update_labels()


	func set_indicator_value(indicator_: String) -> void:
		var value = 1
		
		match indicator_:
			"energy":
				value *= arr.compartment.size() * 3
			"knowledge":
				value *= arr.compartment.size() * 1
			"shield":
				value *= arr.compartment.size() * 1
		
		if flag.complete:
			value *= 2
		
		dict.indicator[indicator_] = value


	func add_compartment(compartment_: Compartment) -> void:
		arr.compartment.append(compartment_)
		compartment_.obj.module = self
		
		if word.type == null:
			set_type()
		
		check_complete()
		update_indicators()


	func check_complete() -> void:
		flag.complete = true
		var clusters = []
		
		for compartment in arr.compartment:
			var sector = compartment.obj.sector
			
			for neighbor in sector.dict.neighbor:
				if neighbor.obj.cluster != sector.obj.cluster:
					if neighbor.obj.compartment == null:
						flag.complete = false
						update_indicators()
						print(word.type, flag.complete)
						return
		
		print(word.type, flag.complete)
		update_indicators()
