OPTIONS = {
  smoothing: 25
  detail: 5
  radius: 0.5
  
  noiseOptions: {
    amplitude: 1.0
    frequency: 0.4
    octaves: 1
    persistence: 0.5
  }
}

renderOptions = {
  wireframe: true
}

# Include FPS and Render stats 
stats = new Stats()
stats.domElement.style.position = 'absolute'
stats.domElement.style.left = '0px'
stats.domElement.style.top = '0px'

rendererStats = new THREEx.RendererStats()
rendererStats.domElement.style.position = 'absolute'
rendererStats.domElement.style.left = '0px'
rendererStats.domElement.style.bottom   = '0px'

# Generate a WebGLrenderer instance
renderer = new THREE.WebGLRenderer()


Coral  = Coral  || {}

Coral.Blob = (options) ->

  ###
  # Return a procedurally generated Blob geometry
  ###

  # Parse the options object
  @noiseOps = {}

  if options?.smoothing?
    @smoothing = options.smoothing
  else
    @smoothing = 25

  if options?.detail?
    @detail = options.detail
  else
    @detail = 5

  if options?.radius?
    @radius = options.radius
  else
    @radius = 0.5

  if options?.noiseOptions?.amplitude?
    @noiseOps.amplitude = options.noiseOptions.amplitude
  else
    @noiseOps.amplitude = 1.0

  if options?.noiseOptions?.frequency?
    @noiseOps.frequency = options.noiseOptions.frequency
  else
    @noiseOps.frequency = 0.4

  if options?.noiseOptions?.octaves?
    @noiseOps.octaves = options.noiseOptions.octaves
  else
    @noiseOps.octaves = 1

  if options?.noiseOptions?.persistence?
    @noiseOps.persistence = options.noiseOptions.persistence
  else
    @noiseOps.persistence = 0.5


  generateNoise = (options) ->
    new FastSimplexNoise(options)


  sample = ( geometry, noise ) =>
    console.assert(geometry.vertices?)

    for v, i in geometry.vertices
      c = @radius * 2 * Math.PI
      e = @noise.getSpherical3DNoise( c, v.x, v.y, v.z )

      v.multiplyScalar( 1 + e / @smoothing )

    geometry



  # Generate a noise field
  @noise = generateNoise( @noiseOps )

  # Create a base Polyhedron
  baseGeometry = new THREE.IcosahedronGeometry( @radius * 2, @detail )

  # Sample the noise field using the baseGeometry's vertices
  sampleGeometry = sample( baseGeometry, @noise )

  # Return sampled geometry
  sampleGeometry

  
generate = ->
  # Test implementation

  # Remove other meshes
  for i in demo.scene.children
    demo.scene.remove(i) if i.type == "Mesh"

  console.log demo.scene

  @geometry = Coral.Blob( OPTIONS )

  if renderOptions.wireframe
    material = new THREE.MeshBasicMaterial { color: 0xffffff, wireframe: true }
  else
    material = new THREE.MeshPhongMaterial { color: 0xffffff, shading: THREE.FlatShading }

  @mesh = new THREE.Mesh( @geometry, material )
  @mesh.castShadow = true
  @mesh.receiveShadow = true

  demo.scene.add(@mesh)



# Boilerplate part
demo = Sketch.create({

  type: Sketch.WEBGL
  element: renderer.domElement
  context:renderer.context

  setup: ->

    @camera = new THREE.PerspectiveCamera(90, @.width / @.height, 0.01, 400 )
    # @camera.setLens(25, 35)
    @camera.setLens(25, 55)
    @camera.position.set(0, 0, 2)
    # @camera.rotation.x = 0 * Math.PI / 180

    @light = new THREE.PointLight( 0xffffff )
    @light.position.set(500, 1000,1000) 

    @scene = new THREE.Scene()

    @scene.add(@light)

  resize: ->
    @camera.aspect = @.width / @.height
    @camera.updateProjectionMatrix()

    renderer.setSize( @.width, @.height )

  draw: ->

    ## Start of stats.js monitored code.
    stats.begin()

    if @scene.children? && @scene.children.length > 0
      for mesh in @scene.children
        mesh.rotation.x += 0.002
        # mesh.rotation.y += 0.005
      
    renderer.render( @scene, @camera )

    ## End of stats.js monitored code.
    stats.end()

    # pass renderer to update renderer stats
    rendererStats.update(renderer)
  })


window.onload = ->

  # Append stats indicators to the dom
  document.body.appendChild( stats.domElement )
  document.body.appendChild( rendererStats.domElement )

  gui = new dat.GUI()

  # Create the initial mesh
  generate()

  # Set the noise field's options as tunable variables 
  gui.add( OPTIONS.noiseOptions, "amplitude", 1, 100).onChange( ->
    generate()
    )

  gui.add( OPTIONS.noiseOptions, "frequency", 0, 10).onChange( ->
    generate()
    )

  gui.add( OPTIONS.noiseOptions, "octaves", 1, 10).onChange( ->
    generate()
    )

  gui.add( OPTIONS.noiseOptions, "persistence", 0.5, 5).onChange( ->
    generate()
    )

  gui.add(OPTIONS, "smoothing", 1, 50).onChange( ->
    generate()
    )

  gui.add(renderOptions, "wireframe").onChange( ->
    generate()
    )

  gui.add(OPTIONS, "detail").onChange( ->
    generate()
    )
