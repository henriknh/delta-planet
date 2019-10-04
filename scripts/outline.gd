extends MeshInstance

var parent
func _ready():
	parent = get_parent().get_node('/root/Spatial')
	print(parent)

func _mouse_entered():
	print('_mouse_entered')

func _mouse_exited():
	print('_mouse_exited')
