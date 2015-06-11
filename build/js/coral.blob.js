var Coral;

Coral = Coral || {};

Coral.Blob = function(options) {

  /*
   * Return a procedurally generated Blob geometry
   */
  var baseGeometry, generateNoise, ref, ref1, ref2, ref3, sample, sampleGeometry;
  this.noiseOps = {};
  if ((options != null ? options.smoothing : void 0) != null) {
    this.smoothing = options.smoothing;
  } else {
    this.smoothing = 25;
  }
  if ((options != null ? options.detail : void 0) != null) {
    this.detail = options.detail;
  } else {
    this.detail = 5;
  }
  if ((options != null ? options.radius : void 0) != null) {
    this.radius = options.radius;
  } else {
    this.radius = 0.5;
  }
  if ((options != null ? (ref = options.noiseOptions) != null ? ref.amplitude : void 0 : void 0) != null) {
    this.noiseOps.amplitude = options.noiseOptions.amplitude;
  } else {
    this.noiseOps.amplitude = 1.0;
  }
  if ((options != null ? (ref1 = options.noiseOptions) != null ? ref1.frequency : void 0 : void 0) != null) {
    this.noiseOps.frequency = options.noiseOptions.frequency;
  } else {
    this.noiseOps.frequency = 0.4;
  }
  if ((options != null ? (ref2 = options.noiseOptions) != null ? ref2.octaves : void 0 : void 0) != null) {
    this.noiseOps.octaves = options.noiseOptions.octaves;
  } else {
    this.noiseOps.octaves = 1;
  }
  if ((options != null ? (ref3 = options.noiseOptions) != null ? ref3.persistence : void 0 : void 0) != null) {
    this.noiseOps.persistence = options.noiseOptions.persistence;
  } else {
    this.noiseOps.persistence = 0.5;
  }
  generateNoise = function(options) {
    return new FastSimplexNoise(options);
  };
  sample = (function(_this) {
    return function(geometry, noise) {
      var c, e, i, j, len, ref4, v;
      console.assert(geometry.vertices != null);
      ref4 = geometry.vertices;
      for (i = j = 0, len = ref4.length; j < len; i = ++j) {
        v = ref4[i];
        c = _this.radius * 2 * Math.PI;
        e = _this.noise.get3DNoise(v.x, v.y, v.z);
        v.multiplyScalar(1 + e / _this.smoothing);
      }
      return geometry;
    };
  })(this);
  this.noise = generateNoise(this.noiseOps);
  baseGeometry = new THREE.IcosahedronGeometry(this.radius * 2, this.detail);
  sampleGeometry = sample(baseGeometry, this.noise);
  return sampleGeometry;
};
