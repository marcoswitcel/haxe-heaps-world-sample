package;

class AppConfig {

    private static inline final FULL_DEMO_MIN_WIDTH = 900;

    private var lightDemo:Bool;
    public var numObjects:Int;
    public var numParticles:Int;
    public var chunkSize:Int;
    public var worldSize:Int;

    public function new(numObjects:Int, numParticles:Int, chunkSize:Int, worldSize:Int, lightDemo:Bool) {
        this.numObjects = numObjects;
        this.numParticles = numParticles;
        this.chunkSize = chunkSize;
        this.worldSize = worldSize;
        this.lightDemo = lightDemo;
    }

    public function isLightDemo() {
        return lightDemo;
    }

    public static inline function factory() {
        var window = hxd.Window.getInstance();
        if (window.width < FULL_DEMO_MIN_WIDTH) {
            return new AppConfig(300, 1500, 32, 64, true);
        }
        
        return new AppConfig(1000, 10000, 64, 128, false);
    }
}
