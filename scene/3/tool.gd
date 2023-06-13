extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()
	set_label()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte)


func set_label() -> void:
	$Label.set("horizontal_alignment", "Center")
	$Label.set("vertical_alignment", "Center")
	#$Label.set("size_flags_horizontal", "Shrink Center")
	#var font = get("res://asset/font/metal lord ot.otf")
	#$Label.set("theme_override_fonts/font", Font.
	$Label.text = parent.word.spec[0].to_upper() + str(parent.num.value)


func remove_bg() -> void:
	$BG.visible = false
