extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_color()


func update_color() -> void:
	var max_h = 360.0
	var h = float(parent.obj.athleten.num.index)/Global.num.index.athleten
	var s = 0.75
	var v = 1
	var color_ = Color.from_hsv(h, s, v)
	$BG.set_color(color_)


func add_spielkarte_into_thought(spielkarte_):
	$HBox/Spielkarte/Thought.add_child(spielkarte_.scene.myself)


func convert_thought_into_dream(spielkarte_):
	$HBox/Spielkarte/Thought.remove_child(spielkarte_.scene.myself)
	parent.obj.athleten.obj.mannschaft.obj.trainerin.obj.kombi.continue_combo_with(spielkarte_)
	
	if $HBox/Spielkarte/Thought.get_child_count() == 0:
		$HBox/Spielkarte.set("theme_override_constants/separation", 0)
	else:
		$HBox/Spielkarte.set("theme_override_constants/separation", Global.num.separation.spielkarte)


func remove_spielkartes_from(hbox_: String):
	var node = $HBox/Spielkarte.get_node(hbox_.capitalize())
	
	while node.get_child_count() > 0:
		var child = node.get_children().pop_front()
		node.remove_child(child)
		child.recolor_bg("default")


func recolor_spielkartes_bg(layer_: String) -> void:
	for child in $HBox/Spielkarte/Dream.get_children():
		child.recolor_bg(layer_)


func reset_spielkartes() -> void:
	remove_spielkartes_from("dream")
	remove_spielkartes_from("thought")
