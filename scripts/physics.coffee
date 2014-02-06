physics =
  _isBetween: (value, rangeStart, rangeEnd) ->
    value > rangeStart && value < rangeEnd

  _coordinatesDifference: (value, rangeStart, rangeEnd) ->
    return 0 unless @_isBetween value, rangeStart, rangeEnd
    Math.min Math.abs(value - rangeStart), Math.abs(value - rangeEnd)

  _areasDifference: (firstArea,  secondArea) ->
    x: @_coordinatesDifference(firstArea.x1, secondArea.x1, secondArea.x2) || @_coordinatesDifference(firstArea.x2, secondArea.x1, secondArea.x2)
    y: @_coordinatesDifference(firstArea.y1, secondArea.y1, secondArea.y2) || @_coordinatesDifference(firstArea.y2, secondArea.y1, secondArea.y2)

  hasCollision: (firstObject, secondObject) ->
    diff = @_areasDifference firstObject.getCollisionArea(), secondObject.getCollisionArea()
    backDiff = @_areasDifference secondObject.getCollisionArea(), firstObject.getCollisionArea()
    (!!diff.x && !!diff.y) || (!!backDiff.x && !!backDiff.y)

  resolveCollision: (firstObject, secondObject) ->
    diff = @_areasDifference firstObject.getCollisionArea(),  secondObject.getCollisionArea()
    massRatio = firstObject.mass / secondObject.mass
    firstObject.move  diff.x / massRatio, diff.y / massRatio
    secondObject.move diff.x * massRatio, diff.y * massRatio
  
