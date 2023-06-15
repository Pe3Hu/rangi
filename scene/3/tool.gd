extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()
	set_label()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte)


func set_label() -> void:
	$HBox/Label.set("horizontal_alignment", "Center")
	$HBox/Label.set("vertical_alignment", "Center")
	#$HBox/Label.set("size_flags_horizontal", "Shrink Center")
	#var font = get("res://asset/font/metal lord ot.otf")
	#$HBox/Label.set("theme_override_fonts/font", Font.
	$HBox/Label.text = parent.word.abbreviation


func switch_bg() -> void:
	$BG.visible = !$BG.visible
