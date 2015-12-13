
extends Node2D

export(Color) var vine_color = Color(0, 1, 0)
var vine_width = 4
const vines_limit = 255
var vines = []
var texture = null
var path = null

func _ready():
	Globals.set("Vine", self)
	texture = get_node("Sprite").get_texture()

func add_vine(from, to):
	vines.append([from, to])
	if vines.size() > vines_limit:
		vines.remove(0)
	update()

func draw_path(path):
	self.path = path
	update()

func _draw():
	for v in vines:
		draw_line(v[0], v[1], vine_color, vine_width)
#		var pos = Vector2(v)
#		var rot = (v - vines[v]).angle()
#		var scale = Vector2(1, 1)
#		draw_set_transform(pos, rot, scale)
#		draw_texture(texture, vines[v])
	if path != null and path.size()>1:
		for i in range(1, path.size()):
			draw_line(path[i-1], path[i], Color(1, 1, 1))
			#draw_circle(p, 5, Color(1, 1, 1))

