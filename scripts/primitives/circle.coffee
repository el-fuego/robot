class Circle extends Primitive
  className: 'circle'
  centerX: 0
  centerY: 0
  diameter: 10

  move: (diffX, diffY) ->
    @centerX += diffX
    @centerY += diffY