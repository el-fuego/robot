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