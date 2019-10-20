extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	for i in range(20):
		var x = randi_range(-1000, 1000)
		var y = randi_range(-1000, 1000)
		var z = randi_range(-1000, 1000)
		var pos = Vector3(x, y, z)
		print(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
