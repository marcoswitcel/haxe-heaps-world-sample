package;

import h3d.Vector;
import h3d.col.Bounds;
import h3d.parts.GpuParticles;
import h3d.pass.DefaultShadowMap;
import h3d.scene.CameraController;
import h3d.scene.World;
import h3d.scene.World.WorldModel;
import h3d.scene.fwd.DirLight;

class Main extends hxd.App {

  private var world:World;
  private var shadow:DefaultShadowMap;
  private var numObjects:Int;
  private var numParticles:Int;
  


  public function new(numObjects:Int = 1000, numParticles:Int = 10000) {
    super();
    this.numObjects = numObjects;
    this.numParticles = numParticles;
  }

  override function init() {
    world = new World(64, 128, s3d);
    var t = world.loadModel(hxd.Res.tree);
    var r = world.loadModel(hxd.Res.rock);

    for (i in 0...numObjects) {
      var model:WorldModel = Std.random(2) == 0 ? t : r;
      var x = Math.random() * 128;
      var y = Math.random() * 128;
      world.add(model, x, y, 0, 1.2 + hxd.Math.srand(0.4), hxd.Math.srand(Math.PI));
    }

    world.done();

    lightSetup();
    shadowsSetup();
    particlesSetup();
    cameraSetup();
  }
  
  function cameraSetup() {
    s3d.camera.target.set(72, 72, 0);
    s3d.camera.pos.set(120, 120, 40);
  
    s3d.camera.zNear = 1;
    s3d.camera.zFar = 100;

    new CameraController(s3d).loadFromCamera();
  }

  function particlesSetup() {
    var parts = new GpuParticles(world);
    var g = parts.addGroup();
    g.size = 0.2;
    g.gravity = 1;
    g.life = 10;
    g.nparts = numParticles;
    g.emitMode = CameraBounds;
    parts.volumeBounds = Bounds.fromValues(-20, -20, 15, 40, 40, 40);
  }

  function shadowsSetup() {
    shadow = s3d.renderer.getPass(DefaultShadowMap);
    shadow.size = 2048;
    shadow.power = 200;
    shadow.blur.radius = 0;
    shadow.bias *= 0.1;
    shadow.color.set(0.7, 0.7, 0.7);
  }

  function lightSetup() {
    new DirLight(new Vector(0.3, -0.4, -0.9), s3d);
    s3d.lightSystem.ambientLight.setColor(0x909090);
  }

  static function main() {
    hxd.Res.initEmbed();
    var window = hxd.Window.getInstance();
    if (window.width < 900) {
      trace("Rodando versão leve");
      new Main(600, 3000);
    } else {
      trace("Rodando versão completa");
      new Main();
    }
    #if js
    trace("Rodando na Web");
    #end
  }
}
