extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte) * 2


func _on_day_timeout():
	Global.num.index.day += 1
	wood_accumulation_per_day()
	#print("End day ", Global.num.index.day)


func wood_accumulation_per_day():
	for wood in parent.obj.sanctuary.obj.greenhouse.arr.wood:
		wood.accumulation_per_day()
