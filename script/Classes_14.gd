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


	func roll() -> Edge:
		var edge = arr.edge.pick_random()
		print(edge.word.gist)
		return edge


#Грань edge
class Edge:
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		word.gist = input_.gist
		obj.dice = null
