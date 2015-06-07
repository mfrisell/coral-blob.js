var demo, renderer, stats;

stats = new Stats();

stats.domElement.style.position = 'absolute';

stats.domElement.style.left = '0px';

stats.domElement.style.top = '0px';

renderer = new THREE.WebGLRenderer();

demo = Sketch.create({
  type: Sketch.WEBGL,
  element: renderer.domElement,
  context: renderer.context,
  setup: function() {
    var geometry, material;
    this.camera = new THREE.PerspectiveCamera(45, this.width / this.height, 1, 10000);
    this.camera.position.z = 1000;
    this.scene = new THREE.Scene();
    geometry = new THREE.CubeGeometry(200, 200, 200);
    material = new THREE.MeshBasicMaterial({
      color: 0xFFFFFF,
      wireframe: true
    });
    this.mesh = new THREE.Mesh(geometry, material);
    return this.scene.add(this.mesh);
  },
  resize: function() {
    this.camera.aspect = this.width / this.height;
    this.camera.updateProjectionMatrix();
    return renderer.setSize(this.width, this.height);
  },
  draw: function() {
    stats.begin();
    this.mesh.rotation.x += 0.01;
    this.mesh.rotation.y += 0.02;
    renderer.render(this.scene, this.camera);
    return stats.end();
  }
});

window.onload = function() {
  var gui;
  document.body.appendChild(stats.domElement);
  return gui = new dat.GUI();
};

//# sourceMappingURL=main.js.map
