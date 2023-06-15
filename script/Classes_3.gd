extends Node


#Конструкторское бюро bureau
class Bureau:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.planet = input_.planet
		init_scene()
		init_designs()


	func init_scene() -> void:
		scene.myself = Global.scene.bureau.instantiate()
		scene.myself.set_parent(self)
		obj.planet.scene.myself.get_node("VBox").add_child(scene.myself)
		obj.planet.scene.myself.get_node("VBox").move_child(scene.myself, 0)


	func init_designs() -> void:
		arr.design = []
		
		for _i in Global.num.bureau.count.total:
			var input = {}
			input.bureau = self
			input.corporation = null
			input.tools = []
			
			for _j in 1:
				var input_ = {}
				input_.target = "storage"
				input_.category = "drone"
				input_.specialty = "arm"
				input_.value = 1
				var tool = Classes_3.Tool.new(input_)
				input.tools.append(tool)
			
			var design = Classes_3.Design.new(input)
			arr.design.append(design)
		
		set_active_design()


	func set_active_design() -> void:
		arr.design.shuffle()
		
		for _i in Global.num.bureau.count.active:
			var design = arr.design[_i]
			scene.myself.get_node("Design").add_child(design.scene.myself)


#Чертеж design
class Design:
	var arr = {}
	var obj = {}
	var flag = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.tool = input_.tools
		obj.bureau = input_.bureau
		obj.corporation = input_.corporation
		obj.spielkarte = null
		obj.owner = null
		flag.exile = false
		init_scene()
		set_tools()


	func init_scene() -> void:
		scene.myself = Global.scene.design.instantiate()
		scene.myself.set_parent(self)
		#obj.bureau.scene.myself.get_node("Design").add_child(scene.myself)


	func set_tools() -> void:
		for tool in arr.tool:
			tool.obj.design = self
			scene.myself.get_node("Tool").add_child(tool.scene.myself)
			
			if !flag.exile and tool.word.category == "schematic":
				flag.exile = true


#Инструмент tool
class Tool:
	var arr = {}
	var num = {}
	var obj = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.design = null
		word.category = input_.category
		word.target = input_.target
		
		match input_.category:
			"drone":
				num.value = input_.value
				word.specialty = input_.specialty
				word.abbreviation = word.category[0].to_upper() + word.specialty[0].to_upper() + str(num.value)
			"schematic":
				word.title = input_.title
				word.abbreviation = word.category[0].to_upper() + word.title[0].to_upper()
		
		init_scene()
		fill_based_on_tool()
		init_icon()


	func init_scene() -> void:
		scene.myself = Global.scene.tool.instantiate()
		scene.myself.set_parent(self)


	func fill_based_on_tool() -> void:
		match word.category:
			"schematic":
				var input = {}
				input.tool = self
				input.title = word.title
				input.types = []
				input.core = false
				obj.schematic = Classes_7.Schematic.new(input)


	func init_icon() -> void:
		match word.category:
			"schematic":
				var input = {}
				input.tool = self
				obj.icon = Classes_3.Icon.new(input)


#Значок icon
class Icon:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.tool = input_.tool
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.icon.instantiate()
		scene.myself.set_parent(self)
		obj.tool.scene.myself.get_node("HBox").add_child(scene.myself)
		obj.tool.scene.myself.get_node("HBox").move_child(scene.myself, 0)
