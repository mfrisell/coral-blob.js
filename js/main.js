var cfg, complexGeometry, demo, noiseOptions, renderer, rendererStats, stats;

cfg = {
  NOISE_AMPLITUDE: 5,
  POINTS: false,
  WIREFRAME: true,
  POLY_DETAIL: 3
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

noiseOptions = {
  amplitude: 1.0,
  frequency: 1.0,
  octaves: 1,
  persistence: 0.5
};

complexGeometry = {};

complexGeometry.initiateNoise = function(options) {
  return new FastSimplexNoise(options);
};

complexGeometry.geometry = function(diameter, detail) {
  var c, d, r;
  d = diameter;
  c = d * Math.PI;
  r = d / 2;
  return new THREE.IcosahedronGeometry(d, detail);
};

complexGeometry.sample = function(geometry, noise) {
  var e, i, j, len, ref, v;
  console.assert(geometry.vertices != null);
  ref = geometry.vertices;
  for (i = j = 0, len = ref.length; j < len; i = ++j) {
    v = ref[i];
    e = noise.getSpherical3DNoise(1 * Math.PI, v.x, v.y, v.z);
    v.multiplyScalar(1 + e / cfg.NOISE_AMPLITUDE);
  }
  return geometry.verticesNeedUpdate = true;
};

complexGeometry["new"] = function() {
  var geometry, i, j, len, material, noise, ref;
  ref = demo.scene.children;
  for (j = 0, len = ref.length; j < len; j++) {
    i = ref[j];
    if (i.type === "Mesh") {
      demo.scene.remove(i);
    }
  }
  noise = complexGeometry.initiateNoise(noiseOptions);
  geometry = complexGeometry.geometry(1, cfg.POLY_DETAIL);
  complexGeometry.sample(geometry, noise);
  if (cfg.POINTS) {
    material = new THREE.PointCloudMaterial({
      size: 1,
      sizeAttenuation: false
    });
    this.mesh = new THREE.PointCloud(geometry, material);
  } else {
    if (cfg.WIREFRAME) {
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
    this.mesh = new THREE.Mesh(geometry, material);
  }
  this.mesh.castShadow = true;
  this.mesh.receiveShadow = true;
  return demo.scene.add(this.mesh);
};

demo = Sketch.create({
  type: Sketch.WEBGL,
  element: renderer.domElement,
  context: renderer.context,
  setup: function() {
    this.camera = new THREE.PerspectiveCamera(45, this.width / this.height, 1, 10000);
    this.camera.position.set(0, 0, 4);
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
  complexGeometry["new"]();
  gui.add(noiseOptions, "amplitude", -10, 1000).onChange(function() {
    return complexGeometry["new"]();
  });
  gui.add(noiseOptions, "frequency", -10, 100).onChange(function() {
    return complexGeometry["new"]();
  });
  gui.add(noiseOptions, "octaves").onChange(function() {
    return complexGeometry["new"]();
  });
  gui.add(noiseOptions, "persistence", 0.5, 1).onChange(function() {
    return complexGeometry["new"]();
  });
  gui.add(cfg, "NOISE_AMPLITUDE", 1, 10).onChange(function() {
    return complexGeometry["new"]();
  });
  gui.add(cfg, "POINTS").onChange(function() {
    return complexGeometry["new"]();
  });
  gui.add(cfg, "WIREFRAME").onChange(function() {
    return complexGeometry["new"]();
  });
  return gui.add(cfg, "POLY_DETAIL").onChange(function() {
    return complexGeometry["new"]();
  });
};

//# sourceMappingURL=main.js.map
