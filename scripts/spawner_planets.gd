extends Spatial

export(int) var nr_of_planets = 20

onready var planet = preload("res://assets/prefabs/planet.tscn")
var rng = RandomNumberGenerator.new()
var planets_on_orbit_levels = {
	Enums.ORBIT_LEVEL.FIRST: [],
	Enums.ORBIT_LEVEL.SECOND: [],
	Enums.ORBIT_LEVEL.THIRD: [],
	Enums.ORBIT_LEVEL.FORTH: [],
	Enums.ORBIT_LEVEL.FIFTH: []
}
	
func _ready():
	var start_time = OS.get_ticks_msec()
	
	var planets = []
	
	for i in range(nr_of_planets):
		var planet_data = {}
		planet_data.orbit_level = gen_orbit_level()
		planet_data.size = gen_size(planet_data.orbit_level)
		planet_data.biome = gen_biomo(planet_data.orbit_level)
		planet_data.rotation_speed = rng.randf_range(-1, 3)
		planet_data.tilt = rng.randf_range(-0.25, 0.25)
		planet_data.init_angle = 0 #rng.randf_range(0, 2*PI)
		
		if i == 0:
			planet_data.orbit_level = Enums.ORBIT_LEVEL.DEFAULT
			planet_data.size = Enums.PLANET_SIZE.DEFAULT
			planet_data.biome = Enums.PLANET_BIOME.DEFAULT
			
		planets_on_orbit_levels[planet_data.orbit_level].push_back(planet_data)
		planets.push_back(planet_data)
		
		
	print("Elapsed time1: ", OS.get_ticks_msec() - start_time)
	for key in planets_on_orbit_levels.keys():
		var planets_on_orbit_level = planets_on_orbit_levels[key]
		var bracket_size = (2 * PI) / planets_on_orbit_level.size()
		for idx in range(planets_on_orbit_level.size()):
			var planet_data = planets_on_orbit_level[idx]
			var pivot_start = idx * bracket_size + bracket_size * 0.33
			var pivot_end = (idx + 1) * bracket_size + bracket_size - 0.33
			planet_data.init_angle = rng.randf_range(pivot_start, pivot_end)
			
	print("Elapsed time2: ", OS.get_ticks_msec() - start_time)
	
	for idx in range(planets.size()):
		var planet_data = planets[idx]
		var planet_instance = planet.instance()
		planet_instance.orbit_level = planet_data.orbit_level
		planet_instance.size = planet_data.size
		planet_instance.biome = planet_data.biome
		planet_instance.rotation_speed = planet_data.rotation_speed
		planet_instance.tilt = planet_data.tilt
		planet_instance.init_angle = planet_data.init_angle
		add_child(planet_instance)
		
		if idx == 0:
			var camera_base = get_node('/root/spatial/camera_base')
			planet_instance.set_target(true)
			camera_base.set_target_planet(planet_instance)
	
	print("Elapsed time3: ", OS.get_ticks_msec() - start_time)

func gen_orbit_level():
	var left_level_1 = int(0.1 * nr_of_planets) - planets_on_orbit_levels[Enums.ORBIT_LEVEL.FIRST].size()
	var left_level_2 = int(0.2 * nr_of_planets) - planets_on_orbit_levels[Enums.ORBIT_LEVEL.SECOND].size()
	var left_level_3 = int(0.4 * nr_of_planets) - planets_on_orbit_levels[Enums.ORBIT_LEVEL.THIRD].size()
	var left_level_4 = int(0.2 * nr_of_planets) - planets_on_orbit_levels[Enums.ORBIT_LEVEL.FORTH].size()
	var left_level_5 = int(0.1 * nr_of_planets) - planets_on_orbit_levels[Enums.ORBIT_LEVEL.FIFTH].size()
	
	var placed_planets = 0
	placed_planets += planets_on_orbit_levels[Enums.ORBIT_LEVEL.FIRST].size()
	placed_planets += planets_on_orbit_levels[Enums.ORBIT_LEVEL.SECOND].size()
	placed_planets += planets_on_orbit_levels[Enums.ORBIT_LEVEL.THIRD].size()
	placed_planets += planets_on_orbit_levels[Enums.ORBIT_LEVEL.FORTH].size()
	placed_planets += planets_on_orbit_levels[Enums.ORBIT_LEVEL.FIFTH].size()
	
	var orbit_level_value = rng.randi_range(1, nr_of_planets - placed_planets)
	var bracket = 0
	
	bracket += left_level_1
	if left_level_1 && orbit_level_value <= bracket:
		return Enums.ORBIT_LEVEL.FIRST
	bracket += left_level_2
	if left_level_2 && orbit_level_value <= bracket:
		return Enums.ORBIT_LEVEL.SECOND
	bracket += left_level_3
	if left_level_3 && orbit_level_value <= bracket:
		return Enums.ORBIT_LEVEL.THIRD
	bracket += left_level_4
	if left_level_4 && orbit_level_value <= bracket:
		return Enums.ORBIT_LEVEL.FORTH
	bracket += left_level_5
	if left_level_5 && orbit_level_value <= bracket:
		return Enums.ORBIT_LEVEL.FIFTH

func gen_size(orbit_level):
	var size_value = rng.randf()
	var size = Enums.PLANET_SIZE.DEFAULT
	match orbit_level:
		1:
			size = Enums.PLANET_SIZE.SMALL
		2:
			if size_value < 0.66:
				size = Enums.PLANET_SIZE.SMALL
			else:
				size = Enums.PLANET_SIZE.MEDIUM
		3:
			if size_value < 0.20:
				size = Enums.PLANET_SIZE.SMALL
			if size_value < 0.80:
				size = Enums.PLANET_SIZE.MEDIUM
			else:
				size = Enums.PLANET_SIZE.LARGE
		4:
			if size_value < 0.33:
				size = Enums.PLANET_SIZE.MEDIUM
			else:
				size = Enums.PLANET_SIZE.LARGE
		5:
			size = Enums.PLANET_SIZE.LARGE
	return size
	
func gen_biomo(orbit_level):
	var biome_value = rng.randf()
	var biome = Enums.PLANET_BIOME.DEFAULT
	match orbit_level:
		1:
			if biome_value < 0.80:
				biome = Enums.PLANET_BIOME.ROCK
			else:
				biome = Enums.PLANET_BIOME.TERRA
		2:
			if biome_value < 0.40:
				biome = Enums.PLANET_BIOME.ROCK
			elif biome_value < 0.90:
				biome = Enums.PLANET_BIOME.TERRA
			else:
				biome = Enums.PLANET_BIOME.ICE
		3:
			if biome_value < 0.20:
				biome = Enums.PLANET_BIOME.ROCK
			elif biome_value < 0.80:
				biome = Enums.PLANET_BIOME.TERRA
			else:
				biome = Enums.PLANET_BIOME.ICE
		4:
			if biome_value < 0.10:
				biome = Enums.PLANET_BIOME.ROCK
			elif biome_value < 0.60:
				biome = Enums.PLANET_BIOME.TERRA
			else:
				biome = Enums.PLANET_BIOME.ICE
		5:
			if biome_value < 0.20:
				biome = Enums.PLANET_BIOME.TERRA
			else:
				biome = Enums.PLANET_BIOME.ICE
	return biome
	
func calc_angle(planet):
	pass