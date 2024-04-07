extends Node2D

var size: int
var fruit_scene = preload("res://scenes/fruit.tscn")
var should_spawn_fruit := true
var fruits = []
var window_size
var rows
var cols

func _ready():
	size = $Snake.size
	window_size = get_viewport().get_visible_rect().size
	rows = floor(window_size.x / size)
	cols = floor(window_size.y / size)
	print("grid_size: %s, %s" % [rows, cols])

func _process(delta):
	if should_spawn_fruit:
		fruits.append(spawn_fruit())
		should_spawn_fruit = false
		
	var eaten_idx = $Snake.try_eat(fruits)
	if eaten_idx != -1:
		var frt = fruits.pop_at(eaten_idx)
		frt.queue_free()
		should_spawn_fruit = true
		$LevelInfoControl.level += 1
		
func spawn_fruit():
	# TODO: Check so that fruit is not spawned on top of snake

	var grid_position = Vector2(randi_range(0, rows - 1), randi_range(0, cols - 1))
	print("spawn_fruit: grid_pos=", grid_position)
	var fruit = fruit_scene.instantiate()
	var pos = Vector2(grid_position.x * size, grid_position.y * size)
	print("spawn_pos", pos)
	fruit.init(pos, size)
	$".".add_child(fruit)
	return fruit

