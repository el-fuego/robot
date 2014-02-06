module.exports = (grunt) ->

  lessSrc = [
    '{**/,}*.less',
    '!node_modules/{**/,}*'
  ]

  grunt.initConfig
    less:
      app:
        options:
          paths: ["templates", 'lib']
        files:
          # get all less files as
          # 'some.css': 'some.less'
          (->
            files = {}
            grunt.file.expand(lessSrc).forEach (path)->
              files['build/' + path.replace /(\.css)?\.less$/i, '.css'] = [path]
            files
          )()

    coffee:
      app:
        join:    true
        flatten: true
        src: [
          'build/tmp.coffee'
        ]
        dest: 'build/coffee.tmp.js'

    concat:
      coffee:
        src: [
          'scripts/primitives/primitive.coffee',
          'scripts/primitives/*.coffee',
          'scripts/objects/wall.coffee',
          'scripts/objects/movable_rect.coffee',
          'scripts/objects/robot.coffee',
          'scripts/physics.coffee',
          'scripts/init.coffee',
          '!Gruntfile*',
          '!node_modules/{**/,}*'
        ]
        dest: 'build/tmp.coffee'
      js:
        src: [
          'lib/*.js',
          'scripts/*.js',
          'build/*.tmp.js',
          '!Gruntfile*',
          '!node_modules/{**/,}*'
        ]
        dest: 'build/app.js'
    clean:
      app:
        src: [
          'build/{**/,}*.tmp.*'
        ]

    watch:
      less:
        files: [
          '{**/,}*.less'
        ]
        tasks: ['less']
      scripts:
        files: [
          '{**/,}*.{js,coffee}',
          '!Gruntfile*',
          '!{node_modules,build}/{**/,}*'
        ]
        tasks: ['js']

  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.registerTask 'js', ['concat:coffee', 'coffee', 'concat:js', 'clean']
  grunt.registerTask 'default', ['less', 'js', 'watch']