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
		obj.conveyor = Classes_8.Conveyor.new(input)


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
		
		var schematic = Classes_8.Schematic.new(input)
		var grid_center = Vector2(Global.num.size.continent.col/2, Global.num.size.continent.row/2)
		var cluster = obj.continent.arr.sector[grid_center.y][grid_center.x].obj.cluster
		erect_edifice(schematic, cluster)


	func erect_edifice(schematic_: Classes_8.Schematic, cluster_: Classes_6.Cluster) -> void:
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
		
		print(arr.module.size())


	func update_worksite(edifice_: Edifice) -> void:
		arr.worksite.erase(edifice_.obj.cluster)
		
		for cluster in edifice_.obj.cluster.dict.neighbor:
			if cluster.obj.edifice == null and !arr.worksite.has(cluster):
				arr.worksite.append(cluster)
				cluster.paint_black()


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
		num.consumption = 0
		
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


	func add_module(compartment_: Classes_8.Compartment) -> void:
		var module = get_module(compartment_)
		
		if module == null:
			var input = {}
			input.outpost = obj.outpost
			input.compartment = compartment_
			module = Classes_7.Module.new(input)
			obj.outpost.arr.module.append(module)
		else:
			module.add_compartment(compartment_)


	func get_module(compartment_: Classes_8.Compartment) -> Variant:
		var sector = compartment_.obj.sector
		
		for neighbor in sector.dict.neighbor:
			if neighbor.obj.cluster != sector.obj.cluster and sector.dict.neighbor[neighbor].length() == 1:
				if neighbor.obj.compartment != null:
					return neighbor.obj.compartment.obj.module
		
		return null


#Модуль module  
class Module:
	var num = {}
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


	func add_compartment(compartment_: Classes_8.Compartment) -> void:
		arr.compartment.append(compartment_)
		#num.size = compartment_.num.size
		compartment_.obj.module = self
		var consumption = Global.dict.compartment.consumption[compartment_.word.type.current]
		obj.outpost.obj.scoreboard.num.consumption += consumption
		
		if word.type == null or compartment_.word.type.current == "adaptive compartment":
			set_type()
		
		check_complete()


	func set_type() -> void:
		if word.type == null:
			for compartment in arr.compartment:
				if compartment.word.type.current != "adaptive compartment":
					word.type = str(compartment.word.type.current)
					break
		
		if word.type != null:
			for compartment in arr.compartment:
				if compartment.word.type.current == "adaptive compartment":
					print(word.type,"@",compartment.word.type.current)
					compartment.word.type.next = word.type
					compartment.swap()
					var consumption = Global.dict.compartment.consumption[ word.type]
					obj.outpost.obj.scoreboard.num.consumption += consumption
			
			for indicator in Global.dict.indicator:
				if Global.dict.indicator[indicator].has(word.type):
					dict.indicator[indicator] = 0


	func check_complete() -> void:
		if arr.compartment.size() > 1:
			flag.complete = true
			var clusters = []
			
			for compartment in arr.compartment:
				var sector = compartment.obj.sector
				#var index_ = Global.num.size.continent.col * sector.vec.grid.y + sector.vec.grid.x
				#print("sector: ", index_)
				
				for neighbor in sector.dict.neighbor:
					if neighbor.obj.cluster != sector.obj.cluster and sector.dict.neighbor[neighbor].length() == 1:
						if neighbor.obj.compartment == null:
							flag.complete = false
							update_indicators()
							#var index = Global.num.size.continent.col * neighbor.vec.grid.y + neighbor.vec.grid.x
							#print(index, word.type, flag.complete)
							return
			
			#print(word.type, flag.complete)
			update_indicators()


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
		
		#print(indicator_, ": ",value)
		dict.indicator[indicator_] = value
