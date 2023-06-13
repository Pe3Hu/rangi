extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()
	$Stamp.columns = Global.num.factory.count.n


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte) * 3


func set_free_stamp_by_design(design_: Classes_3.Design) -> void:
	var grid = parent.get_frist_free_stamp()
	
	if grid != null:
		var index = grid.y * Global.num.factory.count.n + grid.x
		var node = $Stamp.get_child(index)
		node.set_design(design_)
		

