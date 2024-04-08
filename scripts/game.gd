extends Node2D

var should_spawn_fruit := true
var game_over := false
var size: int
var grid_rows: int
var grid_cols: int
var fruits = []
var window_size: Vector2
var fruit_scene = preload("res://scenes/fruit.tscn")
var game_over_scene = preload("res://scenes/game_over_control.tscn")

func _ready():
	size = $Snake.size
	window_size = get_viewport().get_visible_rect().size
	grid_rows = floor(window_size.x / size)
	grid_cols = floor(window_size.y / size)
	print("grid_size: %s, %s" % [grid_rows, grid_cols])

func _process(delta):
	if game_over:
		return
		
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
	var grid_position = Vector2(randi_range(0, grid_rows - 1), randi_range(0, grid_cols - 1))
	while !is_valid_position(grid_position):
		print("retry")
		grid_position = Vector2(randi_range(0, grid_rows - 1), randi_range(0, grid_cols - 1))
		
	print("spawn_fruit:", grid_position)
	var fruit = fruit_scene.instantiate()
	var pos = Vector2(grid_position.x * size, grid_position.y * size)
	fruit.init(pos, size)
	$".".add_child(fruit)
	
	return fruit

func is_valid_position(pos: Vector2):
	pos *= size
	if $Snake.head.position == pos:
		return false
		
	for tail_pos in $Snake.tail:
		if tail_pos == pos:
			return false
			
	return true

func _on_snake_game_over():
	game_over = true
	for child in $".".get_children():
		if child.name != "LevelInfoControl":
			child.queue_free()

	var go = game_over_scene.instantiate()
	$".".add_child(go)
