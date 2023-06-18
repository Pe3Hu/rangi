extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte)


func update_color() -> void:
	$BG.set_color(parent.obj.branch.obj.badge.color.bg)
