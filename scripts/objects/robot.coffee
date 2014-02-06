class Robot extends MovableRect
  mass: 10
  tick: ->
    @move Math.random()*3, Math.random()*1