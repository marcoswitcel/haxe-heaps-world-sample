package;

import h2d.Text;
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
  private var config:AppConfig;
  private var titleText:Text;
  private var fpsText:Text;

  public function new(config:AppConfig) {
    super();
    this.config = config;
  }

  override function init() {
    world = new World(config.chunkSize, config.worldSize, s3d);
    var t = world.loadModel(hxd.Res.tree);
    var r = world.loadModel(hxd.Res.rock);

    for (i in 0...config.numObjects) {
      var model:WorldModel = Std.random(2) == 0 ? t : r;
      var x = Math.random() * config.worldSize;
      var y = Math.random() * config.worldSize;
      world.add(model, x, y, 0, 1.2 + hxd.Math.srand(0.4), hxd.Math.srand(Math.PI));
    }

    world.done();

    lightSetup();
    if (!config.isLightDemo()) {
      shadowsSetup();
    }
    particlesSetup();
    cameraSetup();
    setupText();
  }

  override function update(dt:Float) {
    fpsText.text = "fps: " + Std.int(hxd.Timer.fps());
	}
  
  function cameraSetup() {
    s3d.camera.target.set(config.worldSize * .56, config.worldSize * .56, 0);
    s3d.camera.pos.set(config.worldSize * .93, config.worldSize * .93, 40);
  
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
    g.nparts = config.numParticles;
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

  function setupText() {
    var font = hxd.Res.customFont.toFont();

    titleText = new Text(font, s2d);
    titleText.textColor = 0xFFFFFF;
    titleText.text = config.isLightDemo() ? "versão simplificada" : "versão completa";
    titleText.x = 10;
    titleText.y = 10;
    titleText.scale(3);

    fpsText = new Text(font, s2d);
    fpsText.textColor = 0xFFFFFF;
    fpsText.text = "-";
    fpsText.x = 10;
    fpsText.y = 40;
    fpsText.scale(3);
  }

  static function main() {
    hxd.Res.initEmbed();
    
    var config = AppConfig.factory();
    new Main(config);

    if (config.isLightDemo()) {
      trace("Rodando versão leve");
    } else {
      trace("Rodando versão completa");
    }

    #if js
    trace("Rodando na Web");
    #end
  }
}
