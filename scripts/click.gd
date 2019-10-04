extends Spatial

const ray_length = 1000
var from
var to

func _input(event):
	
	return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var camera = $Camera
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		var space_state = get_world().get_direct_space_state()
		var result = space_state.intersect_ray(from, to)
		print(result)
