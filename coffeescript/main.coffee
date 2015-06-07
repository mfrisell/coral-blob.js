stats = new Stats()
stats.domElement.style.position = 'absolute'
stats.domElement.style.left = '0px'
stats.domElement.style.top = '0px'

renderer = new THREE.WebGLRenderer()

demo = Sketch.create({

  type: Sketch.WEBGL
  element: renderer.domElement
  context:renderer.context

  setup: ->

    @camera = new THREE.PerspectiveCamera(45, @.width / @.height, 1, 10000 )
    @camera.position.z = 1000

    @scene = new THREE.Scene()

    geometry = new THREE.CubeGeometry( 200, 200, 200)
    material = new THREE.MeshBasicMaterial { color: 0xFFFFFF, wireframe: true }
    @mesh = new THREE.Mesh( geometry, material )

    @scene.add(@mesh)

  resize: ->
    @camera.aspect = @.width / @.height
    @camera.updateProjectionMatrix()

    renderer.setSize( @.width, @.height )

  draw: ->

    ## Start of stats.js monitored code.
    stats.begin()

    @mesh.rotation.x += 0.01
    @mesh.rotation.y += 0.02

    renderer.render( @scene, @camera )

    ## End of stats.js monitored code.
    stats.end()
  })

window.onload = ->
  document.body.appendChild( stats.domElement )

  gui = new dat.GUI()

