extends Node


#Конвейер conveyor 
class Conveyor:
	var arr = {}
	var num = {}
	var obj = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.outpost = input_.outpost
		num.worksite = {}
		num.worksite.shift = 0
		arr.schematic = []
		dict.incentive = {}
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.conveyor.instantiate()
		scene.myself.set_parent(self)
		obj.outpost.scene.myself.get_node("VBox").add_child(scene.myself)
		obj.outpost.scene.myself.get_node("VBox").move_child(scene.myself, 1)


	func apply_tool(tool_: Classes_3.Tool) -> void:
		arr.schematic.append(tool_.obj.schematic)
		scene.myself.add_tool(tool_)


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
			
			if sector.obj.cluster.obj.center != sector:
				var windrose_compartment = sector.obj.cluster.obj.center.dict.neighbor[sector]
				
				for side in sector.arr.side:
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
			preset_worksite()


	func next_worksite() -> void:
		num.worksite.shift += 1
		preset_worksite()


	func preset_worksite() -> Variant:
		if arr.schematic.size() > 0:
			var schematic = arr.schematic.front()
			var worksites = get_relevant_worksites(schematic)
			
			if worksites.size() > 0:
				var index = num.worksite.shift % worksites.size()
				var worksite = worksites[index]
				worksite.paint_schematic(schematic)
				return worksite
		
		return null


	func decide_which_worksite_to_build_on() -> void:
		if arr.schematic.size() > 0:
			var datas = evaluate_worksites()
			
			if datas.size() > 0:
				var weights = {}
				
				for data in datas:
					var weight = int(round(data.weight))
					weights[data] = weight
				
				var data = Global.get_random_key(weights)
				
				for _i in data.turn:
					data.schematic.rotate(true)
				
				obj.outpost.erect_edifice(data.schematic, data.worksite)
			else:
				if arr.schematic.size() > 1:
					var schematic = arr.schematic.pop_front()
					arr.schematic.append(schematic)
					scene.myself.remove_tool(schematic.obj.tool)
					scene.myself.add_tool(schematic.obj.tool)


	func evaluate_worksites() -> Variant:
		if arr.schematic.size() > 0:
			var schematic = arr.schematic.front()
			var datas = []
			
			for turn in Global.num.conveyor.turn:
				var worksites = get_relevant_worksites(schematic)
				
				for worksite in worksites:
					var data = {}
					data.turn = turn
					data.schematic = schematic
					data.worksite = worksite
					data.surcharge = pow(Global.num.conveyor.surcharge, worksite.num.ring - 1)
					var center = worksite.obj.center
					data.index = Global.num.size.continent.col * center.vec.grid.y + center.vec.grid.x
					get_involved_modules(data)
					evaluate_involved_modules(data)
					datas.append(data)
				
				schematic.rotate(true)
			
			preset_worksite()
			return datas
		
		return []


	func erect_on_best_worksite() -> void:
		var worksite = preset_worksite()
		
		if worksite != null:
			var schematic = arr.schematic.front()
			obj.outpost.erect_edifice(schematic, worksite)
			evaluate_worksites()


	func get_involved_modules(data_: Dictionary) -> void:
		data_.modules = []
		
		for module in obj.outpost.arr.module:
			for compartment in module.arr.compartment:
				if !data_.modules.has(module):
					var sector = compartment.obj.sector
					
					for boundary in sector.dict.boundary:
						if boundary.obj.cluster == data_.worksite:
							data_.modules.append(module)
							break
				else:
					break


	func evaluate_involved_modules(data_: Dictionary) -> void:
		data_.weight = 0
		
		for module in data_.modules:
			var factor = {}
			factor.size = module.arr.compartment.size()
			
			if module.num.breath == 1:
				factor.breath = 4
			else:
				factor.breath = 1
			
			if module.word.type == null:
				factor.versatility = 1
			else:
				factor.versatility = 3
			
			var weight = 1
			
			for key in factor:
				weight *= factor[key]
			
			data_.weight += float(weight)
		
		data_.weight /= data_.surcharge


	func add_incentive(cluster_: Classes_6.Cluster) -> void:
		if cluster_.num.breath < 3:
			if dict.incentive.has(cluster_.num.breath + 1):
				for incentive in dict.incentive[cluster_.num.breath + 1]:
					if incentive.obj.cluster == cluster_:
						incentive.rebreath()
						return
			
			var input = {}
			input.conveyor = self
			input.cluster = cluster_
			var incentive = Classes_8.Incentive.new(input)
			
			if !dict.incentive.has(cluster_.num.breath):
				dict.incentive[cluster_.num.breath] = []
			
			dict.incentive[cluster_.num.breath].append(incentive)


	func erect_starter_schematics() -> void:
		for _i in arr.schematic.size():
			decide_which_worksite_to_build_on()



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
			
			for windrose in association:
				var index = Global.arr.windrose.find(windrose)
				types[index] = type
		
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
			if compartment.word.windrose != null:
				compartment.swap()
		
		update_title()


	func get_compartment(windrose_: Variant) -> Variant:
		for compartment in dict.compartment:
			if compartment.word.windrose == windrose_:
				return compartment
		
		return null


	func update_title() -> void:
		var description_schematic = Global.dict.schematic.title[word.title]
		var indexs = []
		
		for compartment in dict.compartment:
			if compartment.word.windrose !=  null:
				indexs.append(0)
		
		for compartment in dict.compartment:
			if compartment.word.windrose !=  null:
				if compartment.word.type.current != "wall":
					var index = Global.arr.windrose.find(compartment.word.windrose)
					indexs[index] = 1
					
		
		word.title = Global.dict.schematic.indexs[indexs]


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
			
			if compartment_.obj.module != null and word.type.current == "adaptive compartment":
				if compartment_.obj.module.num.breath == 1 and compartment_.obj.module.word.type == null:
					compatibility = false
		
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


#Поощрение incentive  
class Incentive:
	var arr = {}
	var num = {}
	var obj = {}


	func _init(input_: Dictionary) -> void:
		obj.conveyor = input_.conveyor
		obj.cluster = input_.cluster
		arr.title = []
		set_indexs()


	func set_indexs() -> void:
		#var center_index = Global.num.size.continent.col * obj.cluster.obj.center.vec.grid.y + obj.cluster.obj.center.vec.grid.x
		#print("___", [center_index, obj.cluster.num.breath])
		var markers = {}
		
		for windrose in Global.arr.windrose:
			markers[windrose] = null
		
		for sector in obj.cluster.obj.center.dict.neighbor:
			var windrose = obj.cluster.obj.center.dict.neighbor[sector]
			var marker = "any"
			var index_sector = Global.num.size.continent.col * sector.vec.grid.y + sector.vec.grid.x
			
			for boundary in sector.dict.boundary:
				if boundary.obj.compartment != null:
					
					var index_boundary = Global.num.size.continent.col * boundary.vec.grid.y + boundary.vec.grid.x
					
					if Global.dict.compartment.passive.has(boundary.obj.compartment.word.type.current):
						marker = "passive"
					else:
						marker = "active"
			
			markers[windrose] = marker
			#print([center_index, windrose, index_sector, marker])
		
		#print(markers)
		
#		for title in arr.title:
#			var description = Global.dict.schematic.title[title]
#			print(center_index, description)
		arr.title = Global.get_schematic_title_based_on_markers(markers)


	func rebreath() -> void:
		obj.conveyor.dict.incentive[obj.cluster.num.breath + 1].erase(self)
		
		if !obj.conveyor.dict.incentive.has(obj.cluster.num.breath):
			obj.conveyor.dict.incentive[obj.cluster.num.breath] = []
		
		obj.conveyor.dict.incentive[obj.cluster.num.breath].append(self)
		set_indexs()
