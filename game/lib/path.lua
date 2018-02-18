local path = {}

path.WALL_TYPE = 'W'
path.PATH_TYPE = '_'

function path.isSameTile(tile1, tile2)
  return tile1
    and tile2
    and (tile1.row == tile2.row)
    and (tile1.col == tile2.col)
end

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
  local nextTile = actor.tile
  local adjacentTiles = path.findAdjacentTiles(actor.tile, map)

  for __, adjacentTile in pairs(adjacentTiles) do
    local beenThere = false

    for __, seenTile in pairs(actor.seenTiles) do
      beenThere = path.isSameTile(adjacentTile, seenTile)

      if beenThere then
        break
      end
    end

    if not beenThere then
      nextTile = adjacentTile
      break
    end
  end

  return nextTile
end

return path
