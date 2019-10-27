extends Spatial

onready var script_model = load("res://scripts/planet_model.gd").new()
onready var script_move = preload("res://scripts/planet_move.gd").new()

export(Enums.PLANET_SIZE) var size = Enums.PLANET_SIZE.SMALL
export(Enums.PLANET_BIOME) var biome = Enums.PLANET_BIOME.TERRA
export(Enums.ORBIT_LEVEL) var orbit_level = Enums.ORBIT_LEVEL.THIRD
export(float) var rotation_speed = 0
export(float) var tilt = 0
export(float) var init_angle = 0


var is_target = false
var planet_model = null

onready var orbit_point = Spatial.new()

func _process(delta):
	orbit_point.rotate_object_local(Vector3.UP, (6 - orbit_level) * delta / 10.0)
	planet_model.rotate_object_local(Vector3.UP, rotation_speed * delta / 20.0)

func _ready():
	add_child(orbit_point)
	orbit_point.rotate_object_local(Vector3.RIGHT, tilt)
	orbit_point.rotate_object_local(Vector3.UP, init_angle)
	set_target()
	add_to_group('planets')
	
func set_target(is_new_target = false):
	if planet_model:
		planet_model.free()
		
	if is_new_target:
		planet_model = script_model.create(size, true, biome)
	else:
		planet_model = script_model.create(size, false, biome)
		
	planet_model.set_name('planet')
	
	planet_model.set_translation(Vector3(orbit_level * orbit_level * 250 + 1000, 0, 0))
	orbit_point.add_child(planet_model)
	is_target = is_new_target
	
	