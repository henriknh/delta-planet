extends Spatial

onready var planet = preload("res://assets/prefabs/planet.tscn")

var rng = RandomNumberGenerator.new()

func generate_pos():
	var x = rng.randi_range(-2000, 2000)
	var y = rng.randi_range(-2000, 2000)
	var z = rng.randi_range(-500, 500)
	return Vector3(x, y, z)

func _ready():
	
	var my_group_members1 = get_tree().get_nodes_in_group("planets")
	print(my_group_members1.size())
	
	var isFirst = true
	
	for i in range(20):
		var pos = null
		var curr_smallest_dist = 0
		print('- - - - - - -')
		while curr_smallest_dist < 500:
			pos = generate_pos()
			curr_smallest_dist = 5000*5000*5000
			
			for planet in get_tree().get_nodes_in_group("planets"):
				var curr_dist = pos.distance_to(planet.translation)
				if(curr_dist < curr_smallest_dist):
					curr_smallest_dist = curr_dist
			print('min dist: ', curr_smallest_dist)
		
		var size = rng.randi_range(1, 3)
		var planet_instance = planet.instance()
		planet_instance.set_translation(pos)
		planet_instance.planet_size = size
		#planet_instance.planet_speed = rng.randf_range(3, 10)
		add_child(planet_instance)
		
		if isFirst:
			var camera_base = get_node('/root/spatial/camera_base')
			camera_base.set_target_planet(planet_instance)
			isFirst = false
		
	var my_group_members2 = get_tree().get_nodes_in_group("planets")
	print(my_group_members2.size())
		
		