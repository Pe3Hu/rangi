extends Node


#Корпорация corporation
class Corporation:
	var arr = {}
	var obj = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.cosmos = input_.cosmos


#Филиал branch
class Branch:
	var arr = {}
	var num = {}
	var obj = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.index = Global.num.index.branch
		Global.num.index.branch += 1
		obj.corporation = input_.corporation
		obj.outpost = input_.outpost
		init_badge()
		init_director()
		init_factory()
		init_storage()


	func init_badge() -> void:
		var input = {}
		input.branch = self
		obj.badge = Classes_4.Badge.new(input)


	func init_director() -> void:
		var input = {}
		input.branch = self
		obj.director = Classes_1.Director.new(input)


	func init_factory() -> void:
		var input = {}
		input.corporation = self
		obj.factory = Classes_2.Factory.new(input)


	func init_storage() -> void:
		var input = {}
		input.corporation = self
		obj.storage = Classes_4.Storage.new(input)


#Директор director
class Director:
	var arr = {}
	var obj = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.branch = input_.branch
		obj.bureau = obj.branch.obj.outpost.obj.planet.obj.bureau
		init_scene()
		init_priorities()
		init_base_design()
		init_album()
		put_starter_schematic_above_on_archive()


	func init_scene() -> void:
		scene.myself = Global.scene.director.instantiate()
		scene.myself.set_parent(self)
		obj.branch.obj.outpost.scene.myself.get_node("VBox/Director").add_child(scene.myself)


	func init_priorities() -> void:
		var undistributed = int(Global.dict.priority.total)
		dict.priority = {}
		
		for priority in Global.dict.priority.title:
			dict.priority[priority] = int(Global.dict.priority.min)
			undistributed -= dict.priority[priority]
		
		while undistributed > 0:
			var priority = Global.dict.priority.title.pick_random()
			dict.priority[priority] += 1
			undistributed -= 1


	func init_base_design() -> void:
		arr.design = []
		var datas = []
		var data = {}
		data.target = "storage"
		data.category = "drone"
		data.specialty = "arm"
		data.value = 1
		data.count = 9
		datas.append(data)
		data = {}
		data.target = "storage"
		data.category = "drone"
		data.specialty = "brain"
		data.value = 1
		data.count = 6
		datas.append(data)
		data = {}
		data.target = "storage"
		data.category = "drone"
		data.specialty = "heart"
		data.value = 1
		data.count = 3
		#datas.append(data)
		data = {}
		data.category = "schematic"
		data.target = "outpost"
		data.title = "10"#Global.dict.schematic.title.keys().pick_random()167 114 46 42 10
		data.count = 2
		datas.append(data)
		
		for data_ in datas:
			for _i in data_.count:
				var input = {}
				input.bureau = null
				input.branch = obj.branch
				input.tools = []
				
				for _j in 1:
					var tool = Classes_3.Tool.new(data_)
					input.tools.append(tool)
				
				var design = Classes_3.Design.new(input)
				arr.design.append(design)


	func init_storage() -> void:
		var input = {}
		input.director = self
		obj.storage = Classes_4.Storage.new(input)


	func init_album() -> void:
		var input = {}
		input.director = self
		obj.album = Classes_5.Album.new(input)


	func put_starter_schematic_above_on_archive() -> void:
		for spielkarte in obj.album.arr.spielkarte.archive:
			var starter = false
			
			for tool in spielkarte.obj.design.arr.tool:
				if tool.word.category == "schematic":
					starter = true
					break
			
			if starter:
				obj.album.put_above_on_archive(spielkarte)


	func promote_starter_schematics() -> void:
		for stamps in obj.factory.arr.stamp:
			for stamp in stamps:
				for tool in stamp.obj.design.arr.tool:
					if tool.word.category == "schematic":
						stamp.press()
						break
		
		obj.album.apply_dream()
		obj.album.fill_thought()


	func prioritize() -> void:
		var priority = Global.get_random_key(dict.priority)
		priority = "pursuit of incentive"
		print(priority)
		
		match priority:
			"finish construction":
				pass
			"pursuit of incentive":
				evaluate_bureau()
			"take on hardest":
				pass


	func evaluate_bureau() -> void:
		var incentive_titles = {}
		var incentives = obj.branch.obj.outpost.obj.conveyor.dict.incentive
		
		for breath in incentives:
			for incentive in incentives[breath]:
				#var center = incentive.obj.cluster.obj.center
				#var index =  Global.num.size.continent.col * center.vec.grid.y + center.vec.grid.x
				
				for title in incentive.arr.title:
					if !incentive_titles.has(title):
						incentive_titles[title] = []
					
					incentive_titles[title].append(incentive)
				
				#print([breath, index], incentive.arr.title)
		var relevant_bids = {}
		
		for bid in obj.bureau.arr.bid.showcase:
			for tool in bid.obj.design.arr.tool:
				match tool.word.category:
					"drone":
						pass
					"schematic":
						var title = tool.obj.schematic.word.title
						var description = Global.dict.schematic.title[title]
						var rotates = Global.dict.schematic.rotate[title]
						
						for rotated_title in rotates:
							if incentive_titles.has(rotated_title):
								
								for incentive in incentive_titles[rotated_title]:
									if !relevant_bids.has(bid):
										relevant_bids[bid] = []
									
									relevant_bids[bid].append(incentive)
		
		
		for bid in relevant_bids:
			for incentive in relevant_bids[bid]:
				var center = incentive.obj.cluster.obj.center
				var index =  Global.num.size.continent.col * center.vec.grid.y + center.vec.grid.x
				var schematic = bid.obj.design.arr.tool.front().obj.schematic
				
				var description = Global.dict.schematic.title[schematic.word.title]
				print([index, description])

