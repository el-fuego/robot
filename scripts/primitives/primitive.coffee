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