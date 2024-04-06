extends Sprite2D

@export var size: int = 20

var head: Rect2
var dir: Vector2
var pos: Vector2
var speed := 2
var length := 0
var tail = []
#var grid_rows: int
#var grid_cols: int

func _ready():
	var window_size = get_viewport().get_visible_rect().size
	var grid_rows = floor(window_size.x / size)
	var grid_cols = floor(window_size.y / size)
	
	head = Rect2(Vector2.ZERO, Vector2(size, size))
	pos = Vector2.ZERO
	dir = Vector2.RIGHT

func _process(delta):
	if Input.is_action_just_pressed("down") && dir != Vector2.UP:
		dir = Vector2.DOWN
	elif Input.is_action_just_pressed("up") && dir != Vector2.DOWN:
		dir = Vector2.UP
	elif Input.is_action_just_pressed("left") && dir != Vector2.RIGHT:
		dir = Vector2.LEFT
	elif Input.is_action_just_pressed("right") && dir != Vector2.LEFT:
		dir = Vector2.RIGHT
	
	var old_head_pos = head.position
	var delta_position = dir * speed
	pos += delta_position
	head.position = get_grid_position(pos)
	
	if length > 0 && head.position != old_head_pos:
		tail.push_front(old_head_pos)
		tail.pop_back()
	
	queue_redraw()
	
func _draw():
	draw_rect(head, Color.WHITE)
	for t in tail:
		var rect = Rect2(t, Vector2(size, size))
		draw_rect(rect, Color.WHITE)

func try_eat(fruits: Array):
	var eaten_idx = -1
	for i in range(fruits.size()):
		var fruit_pos = fruits[i].rect.position
		if get_grid_position(pos) == fruit_pos:
			print("food")
			length += 1
			tail.push_front(fruit_pos)
			eaten_idx = i
			break
	return eaten_idx

func get_grid_position(pos: Vector2):
	return floor(pos / size) * size
