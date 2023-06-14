extends Node


#Корпорация corporation
class Corporation:
	var arr = {}
	var obj = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.cosmos = input_.cosmos
		obj.planet = null
		init_director()
		init_factory()
		init_storage()


	func init_director() -> void:
		var input = {}
		input.corporation = self
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
		obj.corporation = input_.corporation
		init_scene()
		init_base_design()
		init_album()
		put_schematic_above_on_archive()


	func init_scene() -> void:
		scene.myself = Global.scene.director.instantiate()
		scene.myself.set_parent(self)


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
		data.title = "1"
		data.count = 1
		datas.append(data)
		
		for data_ in datas:
			for _i in data_.count:
				var input = {}
				input.bureau = null
				input.corporation = obj.corporation
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
					return


	func reset_section(section_: String) -> void:
		obj.album.pull_full_section(section_)
		scene.myself.remove_spielkartes_from(section_)


	func reset_after_stadion() -> void:
		obj.album.full_reset()
		scene.myself.reset_spielkartes()
