cfg = {
  NOISE_AMPLITUDE: 25
  POINTS: false
  WIREFRAME: true
  POLY_DETAIL: 5
  PLANET: {
    DIAMETER: 1
  }
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


# Todo, this object is a temporary solution

noiseOptions = {
  amplitude: 1.0
  frequency: 0.4
  octaves: 1
  persistence: 0.5
}


complexGeometry = {}

complexGeometry.initiateNoise = (options) ->
  new FastSimplexNoise(options)

complexGeometry.geometry = (diameter, detail) ->
  d = diameter
  c = d * Math.PI
  r = d / 2

  new THREE.IcosahedronGeometry(d, detail)

complexGeometry.sample = (geometry, noise) -> #double arrow?
  console.assert(geometry.vertices?)
  for v, i in geometry.vertices
    # Incredinote: does the diameter HAVE to resemble the diameter of the actual sphere?
    e = noise.getSpherical3DNoise( cfg.PLANET.DIAMETER * Math.PI, v.x, v.y, v.z) #TODO: hardcode c

    v.multiplyScalar( 1 + e / cfg.NOISE_AMPLITUDE ) 
    
    

  geometry.verticesNeedUpdate = true


complexGeometry.new = ->

  # Remove existing objects from the scene
  for i in demo.scene.children
    demo.scene.remove(i) if i.type == "Mesh"
  
  # Initiate a new noise field
  noise = complexGeometry.initiateNoise(noiseOptions)

  # Generate base geometry
  geometry = complexGeometry.geometry(cfg.PLANET.DIAMETER, cfg.POLY_DETAIL)

  # Sample noise and distort
  complexGeometry.sample(geometry, noise)

  # Create a new mesh and add to scene

  if cfg.POINTS
    material = new THREE.PointCloudMaterial { size: 1, sizeAttenuation: false }
    @mesh = new THREE.PointCloud( geometry, material)
  else
    if cfg.WIREFRAME
      material = new THREE.MeshBasicMaterial { color: 0xffffff, wireframe: true }
    else
      material = new THREE.MeshPhongMaterial { color: 0xffffff, shading: THREE.FlatShading }
    @mesh = new THREE.Mesh( geometry, material)
    
  
  @mesh.castShadow = true
  @mesh.receiveShadow = true
  demo.scene.add(@mesh)




# The actual boilerplate part
demo = Sketch.create({

  type: Sketch.WEBGL
  element: renderer.domElement
  context:renderer.context

  setup: ->

    @camera = new THREE.PerspectiveCamera(90, @.width / @.height, 0.01, 400 )
    @camera.setLens(25, 35)
    @camera.position.set(0, 0, cfg.PLANET.DIAMETER / 2 + 0.54)
    @camera.rotation.x = 70 * Math.PI / 180

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
  complexGeometry.new()

  # Set the noise field's options as tunable variables 
  gui.add(noiseOptions, "amplitude", -10, 1000).onChange( ->
    complexGeometry.new()
    )

  gui.add(noiseOptions, "frequency", -10, 100).onChange( ->
    complexGeometry.new()
    )

  gui.add(noiseOptions, "octaves").onChange( ->
    complexGeometry.new()
    )

  gui.add(noiseOptions, "persistence", 0.5, 1).onChange( ->
    complexGeometry.new()
    )

  gui.add(cfg, "NOISE_AMPLITUDE", 1, 50).onChange( ->
    complexGeometry.new()
    )

  gui.add(cfg, "POINTS").onChange( ->
    complexGeometry.new()
    )

  gui.add(cfg, "WIREFRAME").onChange( ->
    complexGeometry.new()
    )

  gui.add(cfg, "POLY_DETAIL").onChange( ->
    complexGeometry.new()
    )
