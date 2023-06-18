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
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.branch = input_.branch
		init_scene()
		init_base_design()
		init_album()
		put_schematic_above_on_archive()


	func init_scene() -> void:
		scene.myself = Global.scene.director.instantiate()
		scene.myself.set_parent(self)
		obj.branch.obj.outpost.scene.myself.get_node("VBox/Director").add_child(scene.myself)


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
		datas.append(data)
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


	func put_schematic_above_on_archive() -> void:
		for spielkarte in obj.album.arr.spielkarte.archive:
			for tool in spielkarte.obj.design.arr.tool:
				if tool.word.category == "schematic":
					obj.album.put_above_on_archive(spielkarte)
					#return


	func reset_section(section_: String) -> void:
		obj.album.pull_full_section(section_)
		scene.myself.remove_spielkartes_from(section_)


	func reset_after_stadion() -> void:
		obj.album.full_reset()
		scene.myself.reset_spielkartes()
