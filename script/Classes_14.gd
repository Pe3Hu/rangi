extends Node


#Куб dice
class Dice:
	var arr = {}
	var num = {}
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		arr.edge = []
		num.face = input_.faces
		obj.chain = input_.chain
		obj.edge = null
		word.type = input_.type
		word.title = input_.title
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


	func roll() -> void:
		obj.edge = arr.edge.pick_random()


	func reset() -> void:
		obj.edge = null


	func apply_debuff() -> void:
		var edge = find_standard_edge()
		
		if edge != null:
			edge.set_temp_gist("debuff")


	func apply_buff() -> void:
		var edge = find_standard_edge()
		
		if edge != null:
			edge.set_temp_gist("buff")


	func find_standard_edge() -> Edge:
		for edge in arr.edge:
			if edge.word.gist.current == "standard":
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


	func get_value() -> Variant:
		var value = null
		
		match obj.dice.word.type:
			"aspect":
				match obj.dice.word.title:
					"offensive":
						match word.gist.current:
							"standard":
								value = 1.0
							"buff":
								value = 3.0 / 4.0
							"debuff":
								value = 5.0 / 4.0
					"resilience":
						match word.gist.current:
							"standard":
								value = 0
							"buff":
								value = -1
							"debuff":
								value = 1
					"sensory":
						match word.gist.current:
							"standard":
								value = 1.0
							"buff":
								value = 2.0 / 3.0
							"debuff":
								value = 4.0 / 3.0
					"mobility":
						match word.gist.current:
							"standard":
								value = 1.0
							"buff":
								value = 1.0 / 2.0
							"debuff":
								value = 3.0 / 2.0
		
		return value
