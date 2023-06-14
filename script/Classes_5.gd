extends Node


#Альбом album
class Album:
	var num = {}
	var obj = {}
	var arr = {}
	var dict = {}


	func _init(input_: Dictionary) -> void:
		obj.director = input_.director
		init_spielkartes()


	func init_spielkartes() -> void:
		dict.link = {}
		#archive == upcoming spielkartes
		#thought == spielkartes in hand
		dict.link["archive"] = "thought"
		#dream == spielkartes in game
		dict.link["thought"] = "dream"
		#memoir == previous spielkartes
		dict.link["dream"] = "memoir"
		dict.link["memoir"] = "archive"
		#forgotten == exiled spielkartes
		dict.link["forgotten"] = "archive"
		arr.spielkarte = {}
		
		for key in dict.link.keys():
			arr.spielkarte[key] = []
		
		set_standard_content_of_album()


	func set_standard_content_of_album() -> void:
		for design in obj.director.arr.design:
			var input = {}
			input.album = self
			input.design = design
			var spielkarte = Classes_5.Spielkarte.new(input)
			arr.spielkarte.archive.append(spielkarte)
		
		arr.spielkarte.archive.shuffle()


	func pull_full_section(section_: String) -> void:
		var from = section_
		var where = dict.link[section_]
		
		while arr.spielkarte[from].size() > 0:
			var spielkarte = arr.spielkarte[from].pop_front()
			arr.spielkarte[where].append(spielkarte)
			
			match section_:
				"memoir":
					obj.croupier.dict.out[spielkarte.num.rank].append(spielkarte.word.kind)


	func pull_spielkarte_from_archive() -> void:
		#arr.spielkarte.archive.shuffle()
		var spielkarte = arr.spielkarte.archive.pop_front()
		arr.spielkarte.thought.append(spielkarte)
		obj.director.obj.factory.scene.myself.set_free_stamp_by_design(spielkarte.obj.design)
		
		if arr.spielkarte.archive.size() == 0:
			pull_full_section("memoir")


	func convert_thought_into_dream(spielkarte_: Spielkarte) -> void:
		arr.spielkarte.thought.erase(spielkarte_)
		arr.spielkarte.dream.append(spielkarte_)
		obj.croupier.scene.myself.convert_thought_into_dream(spielkarte_)


	func fill_thought() -> void:
		while arr.spielkarte.thought.size() < Global.num.factory.count.total:
			pull_spielkarte_from_archive()


	func full_reset() -> void:
		var sections = ["thought", "dream", "memoir", "forgotten"]
		
		for section in sections:
			pull_full_section(section)
		
		arr.spielkarte.archive.shuffle()


	func put_above_on_archive(spielkarte_: Spielkarte) -> void:
		var index = arr.spielkarte.archive.find(spielkarte_)
		
		if index != -1:
			arr.spielkarte.archive.pop_at(index)
			arr.spielkarte.archive.push_front(spielkarte_)
		else:
			print("archive doesn't have ", spielkarte_)


#Игральная карта spielkarte
class Spielkarte:
	var arr = {}
	var obj = {}
	var num = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.album = input_.album
		obj.design = input_.design

