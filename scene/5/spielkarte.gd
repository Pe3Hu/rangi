extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	set_vertexs()
	update_rec_size()
	update_labes()
	recolor_bg("default")


func set_vertexs() -> void:
	var order = "even"
	var corners = 6
	var r = Global.num.size.spielkarte.r
	var vertexs = []
	
	for corner in corners:
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	$PolygonBG.set_polygon(vertexs)
	$PolygonBG.offset = Vector2.ONE * r


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte)


func update_labes() -> void:
	$Label/Kind/Value.text = parent.word.kind
	$Label/Rank/Value.text = str(parent.num.rank)


func recolor_bg(layer_: String) -> void:
	match layer_:
		"default":
			$BG.color = Color.BLACK
		"winner":
			$BG.color = Color.BLACK
		"loser":
			$BG.color = Color.WHITE
		"tie":
			$BG.color = Color.LIGHT_GRAY
