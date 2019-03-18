class_name Grid extends Resource

var width := 0
var height := 0

var astar := AStar.new()

var map : TileMap = null

func _init(map : TileMap, width : int, height : int) -> void:
	self.map = map
	self.width = width
	self.height = height

	_generate_points()
	_generate_point_connections()

func find_path_by_position(start_position : Vector2, end_position : Vector2) -> Array:
	var start_cell := map.world_to_map(start_position)
	var end_cell := map.world_to_map(end_position)
	return find_path_by_cell(start_cell, end_cell)

func find_path_by_cell(start_cell : Vector2, end_cell : Vector2) -> Array:
	var path2D = []
	if _check_boundaries(start_cell) and _check_boundaries(end_cell):
		var path3D = astar.get_point_path(_flatten(start_cell), _flatten(end_cell))
		for point in path3D:
			path2D.append(Vector2(point.x, point.y))
	return path2D

func _generate_points() -> void:
	for y in range(height):
		for x in range(width):
			var cell := Vector2(x, y)
			var id := _flatten(cell)

			astar.add_point(id, Vector3(x, y, 0))

func _generate_point_connections() -> void:
	for y in range(height):
		for x in range(width):
			var cell := Vector2(x, y)
			var id := _flatten(cell)
			var point : Vector3 = astar.get_point_position(id)

			_connect_with_neighbors(cell)

func _connect_with_neighbors(cell : Vector2) -> void:
	var id := _flatten(cell)
	var neighbors := Hex.get_neighbors(cell)

	for n in neighbors:
		var n_id := _flatten(n)

		if _check_boundaries(n) and not astar.are_points_connected(id, n_id):
			if not map.locations[id].is_blocked and not map.locations[n_id].is_blocked:
				astar.connect_points(id, n_id)

func _disconnect_with_neighbors(cell : Vector2) -> void:
	var id = _flatten(cell)
	var neighbors = Hex.get_neighbors(cell)

	for n in neighbors:
		var n_id = _flatten(n)

		if _check_boundaries(n) and not astar.are_points_connected(id, n_id):
			astar.disconnect_points(id, n_id)

func _flatten(cell : Vector2) -> int:
	return int(cell.y) * width + int(cell.x)

func _check_boundaries(cell : Vector2) -> bool:
	return (cell.x >= 0 and cell.y >= 0 and cell.x < width  and cell.y < height)
