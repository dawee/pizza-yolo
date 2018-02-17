local path = {}

path.WALL_TYPE = 'W'
path.PATH_TYPE = '_'

function path.findAdjacentTiles(tile, map)
  local adjacentTiles = {}
  local tileType = map.tiles[tile.row][tile.col]

  for __, offset in pairs({{-1, 0}, {0, -1}, {1, 0}, {0, 1}}) do
    local offsetCol, offsetRow = unpack(offset)
    local row = tile.row + offsetRow
    local col = tile.col + offsetCol
    local rowTiles = map.tiles[row]
    local adjacentTileType = rowTiles and rowTiles[col]

    if adjacentTileType == tileType then
      adjacentTiles[#adjacentTiles + 1] = {row = row, col = col}
    end
  end

  return adjacentTiles
end

function path.findNextTile(actor, map)


end

return path
