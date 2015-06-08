var Coral, OPTIONS, demo, generate, renderOptions, renderer, rendererStats, stats;

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
        e = _this.noise.getSpherical3DNoise(c, v.x, v.y, v.z);
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

OPTIONS = {
  smoothing: 25,
  detail: 5,
  radius: 0.5,
  noiseOptions: {
    amplitude: 1.0,
    frequency: 0.4,
    octaves: 1,
    persistence: 0.5
  }
};

renderOptions = {
  wireframe: true
};

stats = new Stats();

stats.domElement.style.position = 'absolute';

stats.domElement.style.left = '0px';

stats.domElement.style.top = '0px';

rendererStats = new THREEx.RendererStats();

rendererStats.domElement.style.position = 'absolute';

rendererStats.domElement.style.left = '0px';

rendererStats.domElement.style.bottom = '0px';

renderer = new THREE.WebGLRenderer();

generate = function() {
  var i, j, len, material, ref;
  ref = demo.scene.children;
  for (j = 0, len = ref.length; j < len; j++) {
    i = ref[j];
    if (i.type === "Mesh") {
      demo.scene.remove(i);
    }
  }
  console.log(demo.scene);
  this.geometry = Coral.Blob(OPTIONS);
  if (renderOptions.wireframe) {
    material = new THREE.MeshBasicMaterial({
      color: 0xffffff,
      wireframe: true
    });
  } else {
    material = new THREE.MeshPhongMaterial({
      color: 0xffffff,
      shading: THREE.FlatShading
    });
  }
  this.mesh = new THREE.Mesh(this.geometry, material);
  this.mesh.castShadow = true;
  this.mesh.receiveShadow = true;
  return demo.scene.add(this.mesh);
};

demo = Sketch.create({
  type: Sketch.WEBGL,
  element: renderer.domElement,
  context: renderer.context,
  setup: function() {
    this.camera = new THREE.PerspectiveCamera(90, this.width / this.height, 0.01, 400);
    this.camera.setLens(25, 55);
    this.camera.position.set(0, 0, 2);
    this.light = new THREE.PointLight(0xffffff);
    this.light.position.set(500, 1000, 1000);
    this.scene = new THREE.Scene();
    return this.scene.add(this.light);
  },
  resize: function() {
    this.camera.aspect = this.width / this.height;
    this.camera.updateProjectionMatrix();
    return renderer.setSize(this.width, this.height);
  },
  draw: function() {
    var j, len, mesh, ref;
    stats.begin();
    if ((this.scene.children != null) && this.scene.children.length > 0) {
      ref = this.scene.children;
      for (j = 0, len = ref.length; j < len; j++) {
        mesh = ref[j];
        mesh.rotation.x += 0.002;
        mesh.rotation.y += 0.002;
      }
    }
    renderer.render(this.scene, this.camera);
    stats.end();
    return rendererStats.update(renderer);
  }
});

window.onload = function() {
  var gui;
  document.body.appendChild(stats.domElement);
  document.body.appendChild(rendererStats.domElement);
  gui = new dat.GUI();
  generate();
  gui.add(OPTIONS.noiseOptions, "amplitude", 1, 100).onChange(function() {
    return generate();
  });
  gui.add(OPTIONS.noiseOptions, "frequency", 0, 10).onChange(function() {
    return generate();
  });
  gui.add(OPTIONS.noiseOptions, "octaves", 1, 10).onChange(function() {
    return generate();
  });
  gui.add(OPTIONS.noiseOptions, "persistence", 0.5, 5).onChange(function() {
    return generate();
  });
  gui.add(OPTIONS, "smoothing", 1, 50).onChange(function() {
    return generate();
  });
  gui.add(renderOptions, "wireframe").onChange(function() {
    return generate();
  });
  return gui.add(OPTIONS, "detail").onChange(function() {
    return generate();
  });
};

//# sourceMappingURL=main.js.map
