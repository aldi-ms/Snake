extends Sprite2D

var _size: int
var rect: Rect2

func init(pos: Vector2, size: int):
	rect = Rect2(pos, Vector2(size, size))
	_size = size
	queue_redraw()
	
func _draw():
	draw_rect(rect, Color.RED)
