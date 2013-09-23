import java.util.LinkedList;

class Stream extends toxi.physics2d.VerletParticle2D {
  float opac, radius, b, c;
  
  public Stream(Vec2D point) {
    super(point);
    opac = random(0,1000);
    radius = random(MIN_PARTICLE_WIDTH, MAX_PARTICLE_WIDTH);
    b = 130 + random(40, 80);
    c = 0;
  }
  
  
  void display() {
    strokeWeight(0);
    colorMode(HSB);
    float h = map(noise(c),0,1,80,250);
    float s = map(noise(c),0,1,130,170);
    float b_ = map(noise(c),0,1,b-20,b+20);
    
    fill(h, s, b_, opacity());
    ellipse(x, y, radius, radius);
    
    colorMode(RGB);
  }
  
  float opacity() {
     return noise(opac) * 255;
  }
  
  @Override
  public void update() {
    opac += 0.1;
    c += 0.001;
    super.update();
  }
}
