$ ->
  objects = [
    new Wall({x: 0, y: 0, width: 30, height: 300})
    new Wall({x: 30, y: 0, width: 300, height: 30})
    new Wall({x: 300, y: 30, width: 30, height: 300})
    new Wall({x: 0, y: 300, width: 300, height: 30})
    new MovableRect({x: 100, y: 42, width: 27, height: 100})
    new Robot({x: 75, y: 60, width: 30, height: 30})
  ]

  setInterval ->
    _.each objects, (object) -> 
      object.tick()
      object.render()

    setTimeout ->
      _.each objects, (firstObject) =>
        _.each objects, (secondObject) =>
          physics.resolveCollision(firstObject, secondObject) if physics.hasCollision firstObject, secondObject

      _.each objects, (object) ->
        object.render()
    , 100

  , 300