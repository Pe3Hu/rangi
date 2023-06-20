extends Node


#Космос cosmos
class Cosmos:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init() -> void:
		init_scene()
		init_corporations()
		init_planet()


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


#Планета planet  
class Planet:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.cosmos = input_.cosmos
		init_scene()
		init_bureau()
		init_orbit()
		init_sanctuary()
		init_outposts()
		update_badges()


	func init_scene() -> void:
		scene.myself = Global.scene.planet.instantiate()
		scene.myself.set_parent(self)
		obj.cosmos.scene.myself.get_node("Planet").add_child(scene.myself)


	func init_bureau() -> void:
		var input = {}
		input.planet = self
		obj.bureau = Classes_3.Bureau.new(input)


	func init_orbit() -> void:
		var input = {}
		input.planet = self
		obj.orbit = Classes_9.Orbit.new(input)


	func init_sanctuary() -> void:
		var input = {}
		input.planet = self
		obj.sanctuary = Classes_10.Sanctuary.new(input)


	func init_outposts() -> void:
		arr.outpost = []
		
		for _i in obj.cosmos.arr.corporation.size() - 1:
			var input = {}
			input.planet = self
			input.corporations = []
			var corporation = obj.cosmos.arr.corporation[_i]
			input.corporations.append(corporation)
			corporation = obj.cosmos.arr.corporation[_i + 1]
			input.corporations.append(corporation)
			var outpost = Classes_7.Outpost.new(input)
			arr.outpost.append(outpost)


	func update_badges() -> void:
		for outpost in arr.outpost:
			for branch in outpost.arr.branch:
				branch.obj.badge.set_bg_color()
				branch.obj.director.scene.myself.update_color()


#континент continent
class Continent:
	var arr = {}
	var num = {}
	var obj = {}
	var vec = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		vec.offset = Vector2.ONE * 0.5 * Global.num.size.sector.d
		obj.outpost = input_.outpost
		init_scene()
		init_piliers()
		init_sectors()
		init_clusters()


	func init_scene() -> void:
		scene.myself = Global.scene.continent.instantiate()
		scene.myself.set_parent(self)
		obj.outpost.scene.myself.get_node("VBox").add_child(scene.myself)


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
		init_sector_boundaries()
		init_cluster_rings()
		init_cluster_breaths()


	func init_cluster_neighbors() -> void:
		for clusters in arr.cluster:
			for cluster in clusters:
				for direction in Global.dict.neighbor.linear2:
					var grid = cluster.obj.center.vec.grid + direction * Global.num.size.cluster.n
					
					if Global.boundary_of_array_check(arr.sector, grid):
						var neighbor = arr.sector[grid.y][grid.x].obj.cluster
						var windrose = Global.get_windrose(direction)
						cluster.dict.neighbor[neighbor] = windrose


	func init_sector_boundaries() -> void:
		for clusters in arr.cluster:
			for cluster in clusters:
				for sector in cluster.arr.sector:
					for neighbor in sector.dict.neighbor:
						var windrose = sector.dict.neighbor[neighbor]
						
						if neighbor.obj.cluster != cluster and windrose.length() == 1:
							sector.dict.boundary[neighbor] = neighbor.obj.cluster


	func init_cluster_rings() -> void:
		var unringed_clusters = []
		
		for clusters in arr.cluster:
			for cluster in clusters:
				unringed_clusters.append(cluster)
		
		var center_grid = Vector2(Global.num.size.continent.col, Global.num.size.continent.row) / 2
		var center_cluster = arr.sector[center_grid.y][center_grid.x].obj.cluster
		var ring = {}
		ring.value = 0
		ring.current = []
		ring.current.append(center_cluster)
		
		while unringed_clusters.size() > 0:
			ring.next = []
			
			for cluster in ring.current:
				cluster.num.ring = ring.value
				unringed_clusters.erase(cluster)
				
			
			while ring.current.size() > 0:
				var cluster = ring.current.pop_front()
				
				for sector in cluster.arr.sector:
					for neighbor_sector in sector.dict.neighbor:
						var neighbor_cluster = neighbor_sector.obj.cluster
						
						if neighbor_cluster != cluster and neighbor_cluster.num.ring == null:
							if unringed_clusters.has(neighbor_cluster) and !ring.next.has(neighbor_cluster):
								ring.next.append(neighbor_cluster)
			
			ring.current.append_array(ring.next)
			ring.value += 1


	func init_cluster_breaths() -> void:
		for clusters in arr.cluster:
			for cluster in clusters:
				cluster.num.breath = Global.num.size.cluster.breath
				var neighbors = cluster.dict.neighbor.keys().size()
				cluster.num.breath -= (cluster.num.breath - neighbors)
				#cluster.paint_breath()
