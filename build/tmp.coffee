MAX_MASS = 9999999999999999
class Primitive
  scene:  'body'
  object: null
  mass:   MAX_MASS

  constructor: (settings) ->
    _.extend @, settings
    @scene = $ @scene
    @render()

  constructObject: ->
  applyPosition: ->
  tick: ->
  getCollisionArea: ->
    x1: 0
    y1: 0
    x2: 0
    y2: 0

  render: ->
    @object = @constructObject().appendTo @scene unless @object
    @applyPosition()
class Circle extends Primitive
  className: 'circle'
  centerX: 0
  centerY: 0
  diameter: 10

  move: (diffX, diffY) ->
    @centerX += diffX
    @centerY += diffY
class Rectangle extends Primitive
  className: 'rectangle'
  x: 0
  y: 0
  width:  10
  height: 10
  
  constructObject: ->
    $('<div>').css 
      position: 'absolute'
      background: '#555'
    .addClass @className

  applyPosition: ->
    @object.css 
      top:  @y
      left: @x
      width:  @width
      height: @height

  move: (diffX, diffY) ->
    @x += diffX
    @y += diffY

  getCollisionArea: ->
    x1: @x
    y1: @y
    x2: @x + @width
    y2: @y + @height
class Wall extends Rectangle
  className: 'wall'
class MovableRect extends Wall
  className: 'mowable-rect'
  mass: 3
class Robot extends MovableRect
  className: 'robot'
  mass: 1

  directionAngle: Math.PI/2
  speed: 3.1
  tick: ->
    @move Math.sin(@directionAngle)*@speed, Math.cos(@directionAngle)*@speed
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
  

$ ->
  objects = [
    new Wall({x: 0, y: 0, width: 30, height: 300})
    new Wall({x: 30, y: 0, width: 300, height: 30})
    new Wall({x: 300, y: 30, width: 30, height: 300})
    new Wall({x: 0, y: 300, width: 300, height: 30})
    new MovableRect({x: 270, y: 42, width: 27, height: 100})
    new Robot({x: 235, y: 60, width: 30, height: 30})
  ]

  renderObjects = ->
    _.each objects, (object) ->
      object.render()

  resolveCollisions = ->
    hasCollision = false
    _.each objects, (firstObject) =>
      return _.each objects, (secondObject) =>
        if physics.hasCollision firstObject, secondObject
          physics.resolveCollision(firstObject, secondObject)
          hasCollision = true

    #debugger if hasCollision
    resolveCollisions() if hasCollision


  setInterval ->
    _.each objects, (object) -> 
      object.tick()
      #object.render()

    setTimeout ->
      resolveCollisions()
      renderObjects()
    , 100

  , 300