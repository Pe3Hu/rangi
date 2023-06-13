extends Node


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


	func init_scene() -> void:
		scene.myself = Global.scene.director.instantiate()
		scene.myself.set_parent(self)


	func init_base_design() -> void:
		arr.design = []
		var data = {}
		data["arm"] = 9
		data["brain"] = 6
		data["heart"] = 3
		
		for spec in data.keys():
			for _i in data[spec]:
				var input = {}
				input.bureau = null
				input.corporation = obj.corporation
				input.tools = []
				
				for _j in 1:
					var input_ = {}
					input_.spec = spec
					input_.target = "storage"
					input_.value = 1
					var tool = Classes_3.Tool.new(input_)
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


	func reset_section(section_: String) -> void:
		obj.album.pull_full_section(section_)
		scene.myself.remove_spielkartes_from(section_)


	func reset_after_stadion() -> void:
		obj.album.full_reset()
		scene.myself.reset_spielkartes()


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


	func init_athletens() -> void:
		arr.athleten = []
		var n = 1
		
		for credo in Global.dict.credo.title.keys():
			var input = {}
			input.corporation = self
			input.credo = credo
			var athleten = Classes_2.Athleten.new(input)
			arr.athleten.append(athleten)
