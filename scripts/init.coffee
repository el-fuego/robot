$ ->
  objects = [
    new Wall({x: 0, y: 0, width: 30, height: 300})
    new Wall({x: 30, y: 0, width: 300, height: 30})
    new Wall({x: 300, y: 30, width: 30, height: 300})
    new Wall({x: 0, y: 300, width: 300, height: 30})
    new MovableRect({x: 130, y: 42, width: 27, height: 100})
    new Robot({x: 45, y: 60, width: 30, height: 30})
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