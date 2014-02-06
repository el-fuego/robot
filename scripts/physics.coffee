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

  _moveCollised: (object, diff, totalMass, isReverse) ->
    massRatio = 1 - (object.mass / totalMass)
    object.move(
      (if isReverse then -1 else 1) * diff.x * massRatio,
      (if isReverse then -1 else 1) * diff.y * massRatio
    )


  resolveCollision: (firstObject, secondObject) ->
    diff = @_areasDifference firstObject.getCollisionArea(),  secondObject.getCollisionArea()

    # hack: collapse was given by minimum diff value (ortoganal moves only)
    if diff.x < diff.y
      diff.y = 0
    else
      diff.x = 0
      
    totalMass = firstObject.mass + secondObject.mass
    @_moveCollised firstObject,  diff, totalMass, true
    @_moveCollised secondObject, diff, totalMass
  
