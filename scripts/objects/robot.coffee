class Robot extends MovableRect
  className: 'robot'
  mass: 1

  directionAngle: Math.PI/2
  speed: 3
  tick: ->
    @move Math.sin(@directionAngle)*@speed, Math.cos(@directionAngle)*@speed