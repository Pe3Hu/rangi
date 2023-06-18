extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_size()
	update_mastery_label()
	update_knowledge_label()


func update_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte) * 0.5


func update_mastery_label() -> void:
	var mastery = 0
	
	for tool in parent.obj.design.arr.tool:
		match tool.word.category:
			"schematic":
				var title = tool.obj.schematic.word.title
				
				if mastery < Global.dict.schematic.title[title].mastery:
					mastery = Global.dict.schematic.title[title].mastery
	
	$VBox/Mastery.text = "-" + str(mastery) + "-"


func update_knowledge_label() -> void:
	var knowledge = 0
	
	for tool in parent.obj.design.arr.tool:
		match tool.word.category:
			"schematic":
				knowledge += tool.obj.schematic.num.knowledge
				
	$VBox/Knowledge.text = "$" + str(knowledge) + "$"
