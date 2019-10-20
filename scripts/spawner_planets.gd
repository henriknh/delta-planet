extends Spatial

onready var planet = preload("res://assets/prefabs/planet.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	
	var my_group_members1 = get_tree().get_nodes_in_group("planets")
	print(my_group_members1.size())
	
	for i in range(20):
		var x = rng.randi_range(-10000, 10000)
		var y = rng.randi_range(-10000, 10000)
		var z = rng.randi_range(-10000, 10000)
		var pos = Vector3(x, y, z)
		var size = rng.randi_range(1, 3)
		print(pos)
		var planet_instance = planet.instance()
		planet_instance.set_translation(pos)
		planet_instance.planet_size = size
		add_child(planet_instance)
		
	var my_group_members2 = get_tree().get_nodes_in_group("planets")
	print(my_group_members2.size())
		
		