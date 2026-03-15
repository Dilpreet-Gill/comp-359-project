class_name SpatialHashGrid

var cell_size: float
var _cells: Dictionary = {}

func _init(_cell_size: float):
    cell_size = _cell_size

func _cell_key(x: int, z: int) -> Vector2i:
    return Vector2i(x, z)

func _get_cell_coords(pos: Vector2) -> Vector2i:
    return (
        Vector2i(
            floor(pos.x / cell_size),
            floor(pos.y / cell_size)
        )
    )

func insert(client: SpatialClient):
    var cell_coords = _get_cell_coords(client.position)
    
    if not _cells.has(cell_coords):
        _cells[cell_coords] = []
    _cells[cell_coords].append(client)

func remove(client: SpatialClient):
    var cell_coords = _get_cell_coords(client.position)

    if _cells.has(cell_coords):
        _cells[cell_coords].erase(client)
        if _cells[cell_coords].empty():
            _cells.erase(cell_coords)

func update(client: SpatialClient, old_position: Vector2) -> void:
    var old_cell_coords = _get_cell_coords(old_position)
    var new_cell_coords = _get_cell_coords(client.position)

    if old_cell_coords != new_cell_coords:
        remove(client)
        insert(client)

func clear() -> void:
    _cells.clear()


func _find_nearby(pos: Vector2, radius: float) -> Array:
    var results: Array[SpatialClient] = []

    var min_coords = _get_cell_coords(pos - Vector2(radius, radius))
    var max_coords = _get_cell_coords(pos + Vector2(radius, radius))

    for x in range(min_coords.x, max_coords.x + 1):
        for y in range(min_coords.y, max_coords.y + 1):
            var cell_key = _cell_key(x, y)
            if _cells.has(cell_key):
                results.append_array(_cells[cell_key])

    return results