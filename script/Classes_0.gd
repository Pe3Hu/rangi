extends Node


#Космос cosmos
class Cosmos:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init() -> void:
		init_scene()
		init_planet()
		init_corporations()


	func init_scene() -> void:
		scene.myself = Global.scene.cosmos.instantiate()
		Global.node.game.get_node("Layer0").add_child(scene.myself)


	func init_planet() -> void:
		var input = {}
		input.cosmos = self
		obj.planet = Classes_0.Planet.new(input)


	func init_corporations() -> void:
		arr.corporation = []
		var n = 2
		
		for _i in n:
			var input = {}
			input.cosmos = self
			var corporation = Classes_1.Corporation.new(input)
			arr.corporation.append(corporation)
			obj.planet.add_corporation(corporation)


#Планета planet  
class Planet:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.cosmos = input_.cosmos
		arr.corporation = []
		init_scene()
		init_continent()
		init_bureau()


	func init_scene() -> void:
		scene.myself = Global.scene.planet.instantiate()
		scene.myself.set_parent(self)
		obj.cosmos.scene.myself.get_node("Planet").add_child(scene.myself)


	func init_continent() -> void:
		var input = {}
		input.planet = self
		obj.continent = Classes_0.Continent.new(input)


	func init_bureau() -> void:
		var input = {}
		input.planet = self
		obj.bureau = Classes_3.Bureau.new(input)


	func add_corporation(corporation_: Classes_1.Corporation) -> void:
		arr.corporation.append(corporation_)
		corporation_.obj.planet = self
		corporation_.obj.outpost.obj.continent = obj.continent
		scene.myself.get_node("VBox/Director").add_child(corporation_.obj.director.scene.myself)


#континент continent
class Continent:
	var arr = {}
	var num = {}
	var obj = {}
	var vec = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary):
		vec.offset = Vector2.ONE * 0.5 * Global.num.size.sector.d
		obj.planet = input_.planet
		init_scene()
		init_piliers()
		init_sectors()
		init_clusters()


	func init_scene() -> void:
		scene.myself = Global.scene.continent.instantiate()
		scene.myself.set_parent(self)
		obj.planet.scene.myself.get_node("VBox").add_child(scene.myself)


	func init_piliers() -> void:
		arr.pilier = []
		
		for _i in Global.num.size.continent.row + 1:
			arr.pilier.append([])
			
			for _j in Global.num.size.continent.col + 1:
				var input = {}
				input.grid = Vector2(_j, _i)
				input.continent = self
				var pilier = Classes_6.Pilier.new(input)
				arr.pilier[_i].append(pilier)
		
		init_pilier_neighbors()


	func init_pilier_neighbors() -> void:
		dict.frontière = {}
		
		for piliers in arr.pilier:
			for pilier in piliers:
				for direction in Global.dict.neighbor.linear2:
					var grid = pilier.vec.grid + direction
					
					if Global.boundary_of_array_check(arr.pilier, grid):
						var neighbor_pilier = arr.pilier[grid.y][grid.x]
						
						if !neighbor_pilier.dict.neighbor.has(pilier):
							var input = {}
							input.continent = self
							input.piliers = [pilier, neighbor_pilier] 
							var frontière = Classes_6.Frontière.new(input)
							
							if !dict.frontière.has(pilier):
								dict.frontière[pilier] = {}
							
							if !dict.frontière.has(neighbor_pilier):
								dict.frontière[neighbor_pilier] = {}
							
							dict.frontière[pilier][neighbor_pilier] = frontière
							dict.frontière[neighbor_pilier][pilier] = frontière


	func init_sectors() -> void:
		arr.sector = []
		
		for _i in Global.num.size.continent.row:
			arr.sector.append([])
			
			for _j in Global.num.size.continent.col:
				var input = {}
				input.grid = Vector2(_j, _i)
				input.continent = self
				var sector = Classes_6.Sector.new(input)
				arr.sector[_i].append(sector)
		
		init_sector_neighbors()


	func init_sector_neighbors() -> void:
		var directions = []
		
		for _i in Global.dict.neighbor.diagonal.size():
			directions.append(Global.dict.neighbor.diagonal[_i])
			directions.append(Global.dict.neighbor.linear2[_i])
		
		for sectors in arr.sector:
			for sector in sectors:
				for _i in directions.size():
					var grid = sector.vec.grid + directions[_i]
					
					if Global.boundary_of_array_check(arr.sector, grid):
						var neighbor = arr.sector[grid.y][grid.x]
						var windrose = Global.arr.windrose[_i]
						sector.dict.neighbor[neighbor] = windrose


	func init_clusters() -> void:
		arr.cluster = []
		
		for _i in Global.num.size.continent.cluster:
			arr.cluster.append([])
			
			for _j in Global.num.size.continent.cluster:
				var input = {}
				input.grid = Vector2(_j, _i)
				input.continent = self
				var cluster = Classes_6.Cluster.new(input)
				arr.cluster[_i].append(cluster)
		
		init_cluster_neighbors()

	func init_cluster_neighbors() -> void:
		for clusters in arr.cluster:
			for cluster in clusters:
				for direction in Global.dict.neighbor.linear2:
					var grid = cluster.obj.center.vec.grid + direction * Global.num.size.cluster.n
					
					if Global.boundary_of_array_check(arr.sector, grid):
						var neighbor = arr.sector[grid.y][grid.x].obj.cluster
						var windrose = Global.get_windrose(direction)
						cluster.dict.neighbor[neighbor] = windrose

