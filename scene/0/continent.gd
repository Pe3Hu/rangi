extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_size()


func update_size() -> void:
	var x = Global.num.size.continent.col + 1
	var y = Global.num.size.continent.row + 1
	custom_minimum_size = Vector2(x, y) * Global.num.size.sector.d
