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