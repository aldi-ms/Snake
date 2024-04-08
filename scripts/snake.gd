extends Sprite2D

@export var size: int = 20

signal game_over

var head: Rect2
var dir: Vector2
var pos: Vector2
var speed := 70
var length := 0
var tail = []
var old_dir: Vector2
var window_size: Vector2

func _ready():
	window_size = get_viewport().get_visible_rect().size
	head = Rect2(Vector2.ZERO, Vector2(size, size))
	pos = Vector2.ZERO
	dir = Vector2.RIGHT
	old_dir = Vector2.ZERO

func _process(delta):
	process_movement()
	var old_head_pos = head.position
	
	if (old_dir + dir != Vector2.ZERO):
		var delta_position = dir * speed * delta
		pos += delta_position
		head.position = get_grid_position(pos)
	else:
		end_game()
	
	if head.position != old_head_pos:
		old_dir = (head.position - old_head_pos).normalized()
		if length > 0:
			tail.push_front(old_head_pos)
			tail.pop_back()
		for t in tail:
			if t == head.position:
				end_game()
		if head.position.x < 0 || head.position.x >= window_size.x || head.position.y < 0 || head.position.y >= window_size.y:
			end_game()
			
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
			length += 1
			tail.push_front(fruit_pos)
			eaten_idx = i
			speed += 20
			break
	return eaten_idx

func process_movement(): 
	if Input.is_action_just_pressed("down") && dir != Vector2.UP:
		dir = Vector2.DOWN
	elif Input.is_action_just_pressed("up") && dir != Vector2.DOWN:
		dir = Vector2.UP
	elif Input.is_action_just_pressed("left") && dir != Vector2.RIGHT:
		dir = Vector2.LEFT
	elif Input.is_action_just_pressed("right") && dir != Vector2.LEFT:
		dir = Vector2.RIGHT

func get_grid_position(pos: Vector2):
	return floor(pos / size) * size

func end_game():
	emit_signal("game_over")
