extends Spatial
	
var pressed = false
	
func _input(event):
	return
	if event is InputEventMouseButton and event.button_index == 1:
		pressed = event.pressed
	if event is InputEventMouseMotion:
		if pressed:
			print('move', event.relative, event.speed)
			var x = event.speed[0]
			
func _process(delta):
	return
	# Precision errors 
	# https://docs.godotengine.org/en/3.1/tutorials/3d/using_transforms.html#precision-errors
	transform = transform.orthonormalized()
	
	var target_pos = get_owner().transform.origin
	var self_pos = self.transform.origin
	var direction = self_pos - target_pos
	print(direction.dot(transform.basis.z))
	#self.look_at(target_pos - self_pos, Vector3(0,1,0)) 
	rotate_y( PI * delta/ 10)