extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	parent.num.start = Time.get_unix_time_from_system()
	update_rec_size()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.timeflow)


func _on_3hours_timeout():
	$DayProgressBar.value += 3
	
	if $DayProgressBar.max_value <= $DayProgressBar.value:
		$DayProgressBar.value -= $DayProgressBar.max_value
		next_day()



func next_day():
	Global.num.index.day += 1
	wood_accumulation_per_day()
	#print("End day ", Global.num.index.day)
	var t = Time.get_unix_time_from_system()
	#print([Global.num.index.day, t - parent.num.start])
	parent.num.start = Time.get_unix_time_from_system()


func wood_accumulation_per_day():
	for kind in parent.obj.planet.obj.sanctuary.obj.greenhouse.arr.plant:
		for plant in parent.obj.planet.obj.sanctuary.obj.greenhouse.arr.plant[kind]:
			plant.accumulation_per_day()
