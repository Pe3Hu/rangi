extends Node


#Куб dice
class Dice:
	var arr = {}
	var num = {}
	var obj = {}


	func _init(input_: Dictionary) -> void:
		arr.edge = []
		num.face = input_.faces
		obj.chain = input_.chain
		fill_with_default_edges()


	func add_edge(edge_: Edge) -> void:
		arr.edge.append(edge_)
		edge_.obj.dice = self


	func fill_with_default_edges() -> void:
		match num.face:
			20:
				var edges = {}
				edges["advantage"] = 4
				edges["critical advantage"] = 1
				edges["hindrance"] = 4
				edges["critical hindrance"] = 1
				edges["standard"] = 10
				
				for gist in edges:
					for _i in edges[gist]:
						var input = {}
						input.gist = gist
						var edge = Classes_14.Edge.new(input)
						add_edge(edge)
			6:
				var edges = {}
				edges["debuff"] = 1
				edges["buff"] = 1
				edges["standard"] = 4
				
				for gist in edges:
					for _i in edges[gist]:
						var input = {}
						input.gist = gist
						var edge = Classes_14.Edge.new(input)
						add_edge(edge)


	func roll() -> Edge:
		var edge = arr.edge.pick_random()
		return edge


	func apply_debuff() -> void:
		var edge = find_standart_edge()
		
		if edge != null:
			edge.set_temp_gist("debuff")


	func apply_buff() -> void:
		var edge = find_standart_edge()
		
		if edge != null:
			edge.set_temp_gist("buff")


	func find_standart_edge() -> Edge:
		for edge in arr.edge:
			if edge.word.gist.current == "standart":
				return edge
		
		return null



#Грань edge
class Edge:
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		obj.dice = null
		word.gist = {}
		word.gist.current = input_.gist
		word.gist.base = input_.gist


	func set_temp_gist(gist_: String) -> void:
		word.gist.current = gist_
