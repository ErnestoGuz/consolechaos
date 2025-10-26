extends Control

@export var n_tiles: int = 4
@export var tile_size: int = 80
@export var tile_scene: PackedScene
@export var slide_duration: float = 0.15

var board = []
var tiles = []
var empty = Vector2()
var is_animating = false
var tiles_animating = 0

var move_count = 0
var number_visible = true
var background_texture: Texture2D = null

enum GAME_STATES {
	NOT_STARTED,
	STARTED,
	WON
}
var game_state = GAME_STATES.NOT_STARTED

signal game_started
signal game_won
signal moves_updated

# --------------------------------------------------------------------
# GENERAR TABLERO
# --------------------------------------------------------------------
func gen_board():
	var value = 1
	board = []
	for r in range(n_tiles):
		board.append([])
		for c in range(n_tiles):
			if value == n_tiles * n_tiles:
				board[r].append(0)
				empty = Vector2(c, r)
			else:
				board[r].append(value)
				var tile = tile_scene.instantiate()
				tile.position = Vector2(c * tile_size, r * tile_size)
				tile.set_text(value)
				if background_texture:
					tile.set_sprite_texture(background_texture)
				tile.set_sprite(value - 1, n_tiles, tile_size)
				tile.set_number_visible(number_visible)
				tile.tile_pressed.connect(_on_Tile_pressed)
				tile.slide_completed.connect(_on_Tile_slide_completed)
				add_child(tile)
				tiles.append(tile)
			value += 1

# --------------------------------------------------------------------
# VERIFICACIONES DEL JUEGO
# --------------------------------------------------------------------
func is_board_solved() -> bool:
	var count = 1
	for r in range(n_tiles):
		for c in range(n_tiles):
			if board[r][c] != count:
				if r == c and c == n_tiles - 1 and board[r][c] == 0:
					return true
				else:
					return false
			count += 1
	return true

func print_board():
	print("------ board ------")
	for r in range(n_tiles):
		var row = ""
		for c in range(n_tiles):
			row += str(board[r][c]).pad_zeros(2) + " "
		print(row)

func value_to_grid(value: int) -> Vector2:
	for r in range(n_tiles):
		for c in range(n_tiles):
			if board[r][c] == value:
				return Vector2(c, r)
	return Vector2(-1, -1)

func get_tile_by_value(value: int):
	for tile in tiles:
		if str(tile.number) == str(value):
			return tile
	return null

# --------------------------------------------------------------------
# INICIO
# --------------------------------------------------------------------
func _ready():
	tile_size = floor(size.x / n_tiles)
	self.size = Vector2(tile_size * n_tiles, tile_size * n_tiles)
	gen_board()

# --------------------------------------------------------------------
# CUANDO SE PRESIONA UN TILE
# --------------------------------------------------------------------
func _on_Tile_pressed(number):
	if is_animating:
		return

	if game_state == GAME_STATES.NOT_STARTED:
		scramble_board()
		game_state = GAME_STATES.STARTED
		game_started.emit()
		return

	if game_state == GAME_STATES.WON:
		game_state = GAME_STATES.STARTED
		reset_move_count()
		scramble_board()
		game_started.emit()
		return

	var tile = value_to_grid(number)
	empty = value_to_grid(0)

	if tile.x != empty.x and tile.y != empty.y:
		return

	var dir = Vector2(sign(tile.x - empty.x), sign(tile.y - empty.y))
	var start = Vector2(min(tile.x, empty.x), min(tile.y, empty.y))
	var end = Vector2(max(tile.x, empty.x), max(tile.y, empty.y))

	for r in range(end.y, start.y - 1, -1):
		for c in range(end.x, start.x - 1, -1):
			if board[r][c] == 0:
				continue
			var obj: TextureButton = get_tile_by_value(board[r][c])
			obj.slide_to((Vector2(c, r) - dir) * tile_size, slide_duration)
			is_animating = true
			tiles_animating += 1

	var old_board = board.duplicate(true)

	if tile.y == empty.y:
		if dir.x == -1:
			board[tile.y] = slide_row(board[tile.y], 1, start.x)
		else:
			board[tile.y] = slide_row(board[tile.y], -1, end.x)

	if tile.x == empty.x:
		var col = []
		for r in range(n_tiles):
			col.append(board[r][tile.x])
		if dir.y == -1:
			col = slide_column(col, 1, start.y)
		else:
			col = slide_column(col, -1, end.y)
		for r in range(n_tiles):
			board[r][tile.x] = col[r]

	var moves_made = 0
	for r in range(n_tiles):
		for c in range(n_tiles):
			if old_board[r][c] != board[r][c]:
				moves_made += 1

	move_count += moves_made - 1
	moves_updated.emit(move_count)

	if is_board_solved():
		game_state = GAME_STATES.WON
		game_won.emit()

# --------------------------------------------------------------------
# MEZCLAR Y VALIDAR
# --------------------------------------------------------------------
func is_board_solvable(flat: Array) -> bool:
	var parity = 0
	var grid_width = n_tiles
	var row = 0
	var blank_row = 0
	for i in range(n_tiles * n_tiles):
		if i % grid_width == 0:
			row += 1
		if flat[i] == 0:
			blank_row = row
			continue
		for j in range(i + 1, n_tiles * n_tiles):
			if flat[i] > flat[j] and flat[j] != 0:
				parity += 1
	if grid_width % 2 == 0:
		if blank_row % 2 == 0:
			return parity % 2 == 0
		else:
			return parity % 2 != 0
	else:
		return parity % 2 == 0

func scramble_board():
	reset_board()
	var temp_flat_board = []
	for i in range(n_tiles * n_tiles - 1, -1, -1):
		temp_flat_board.append(i)
	randomize()
	temp_flat_board.shuffle()

	while not is_board_solvable(temp_flat_board):
		randomize()
		temp_flat_board.shuffle()

	for r in range(n_tiles):
		for c in range(n_tiles):
			board[r][c] = temp_flat_board[r * n_tiles + c]
			if board[r][c] != 0:
				set_tile_position(r, c, board[r][c])
	empty = value_to_grid(0)

# --------------------------------------------------------------------
# RESETEAR Y ACTUALIZAR
# --------------------------------------------------------------------
func reset_board():
	reset_move_count()
	board = []
	for r in range(n_tiles):
		board.append([])
		for c in range(n_tiles):
			board[r].append(r * n_tiles + c + 1)
			if r * n_tiles + c + 1 == n_tiles * n_tiles:
				board[r][c] = 0
			else:
				set_tile_position(r, c, board[r][c])
	empty = value_to_grid(0)

func set_tile_position(r: int, c: int, val: int):
	var obj: TextureButton = get_tile_by_value(val)
	obj.position = Vector2(c, r) * tile_size

# --------------------------------------------------------------------
# SLIDE ROW / COLUMN
# --------------------------------------------------------------------
func slide_row(row: Array, dir: int, limiter: int) -> Array:
	var empty_index = row.find(0)
	if dir == 1:
		var start = row.slice(0, limiter)
		start.pop_back()
		var pre = row.slice(limiter, empty_index)
		pre.pop_back()
		var post = row.slice(empty_index, row.size())
		post.pop_front()
		return start + [0] + pre + post
	else:
		var pre = row.slice(0, empty_index)
		pre.pop_back()
		var post = row.slice(empty_index, limiter)
		post.pop_front()
		var end = row.slice(limiter, row.size() - 1)
		end.pop_front()
		return pre + post + [0] + end

func slide_column(col: Array, dir: int, limiter: int) -> Array:
	var empty_index = col.find(0)
	if dir == 1:
		var start = col.slice(0, limiter)
		start.pop_back()
		var pre = col.slice(limiter, empty_index)
		pre.pop_back()
		var post = col.slice(empty_index, col.size() - 1)
		post.pop_front()
		return start + [0] + pre + post
	else:
		var pre = col.slice(0, empty_index)
		pre.pop_back()
		var post = col.slice(empty_index, limiter)
		post.pop_front()
		var end = col.slice(limiter, col.size() - 1)
		end.pop_front()
		return pre + post + [0] + end

# --------------------------------------------------------------------
# OTROS
# --------------------------------------------------------------------
func _on_Tile_slide_completed(_number):
	tiles_animating -= 1
	if tiles_animating == 0:
		is_animating = false

func reset_move_count():
	move_count = 0
	moves_updated.emit(move_count)

func set_tile_numbers(state: bool):
	number_visible = state
	for tile in tiles:
		tile.set_number_visible(state)

func update_size(new_size: int):
	n_tiles = new_size
	print("Updating board size to ", n_tiles)
	tile_size = floor(size.x / n_tiles)
	for tile in tiles:
		tile.queue_free()
	tiles.clear()
	gen_board()
	game_state = GAME_STATES.NOT_STARTED
	reset_move_count()

func update_background_texture(texture: Texture2D):
	background_texture = texture
	for tile in tiles:
		tile.set_sprite_texture(texture)
		tile.update_size(n_tiles, tile_size)
