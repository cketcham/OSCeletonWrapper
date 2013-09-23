class GrowingTree {
  float MAX_TREE_HEIGHT = 160;
  
  float x, y;
  float h;
  float angle = 0;
  float stretch = 1;
  float steps;
  Polygon2D shape;

  int seed;

  GrowingTree() {
    x = 0;
    y = 0;
    h = 0;
    steps = 0;
    seed = int(random(0, 1000));
  }

  GrowingTree(float x_, float y_, float h_, int s_) {
    x = x_;
    y = y_;
    h = map(h_, 0, height, 0, 160);
    steps = s_;
    seed = int(random(0, 1000));
  }

  void setHeight(float h_) {
    h = Math.min(Math.max(0, h_), MAX_TREE_HEIGHT);
  }

  void setAngle(float a) {
    angle = a;
  }
  
  void setStretchFactor (float s) {
    stretch = s;
  }

  void render() {
    int reset = int(random(0, 1000));
    randomSeed(seed);
    shape = new Polygon2D();
    stroke(32);
    branch(x, y, -HALF_PI, Math.min(h,steps));
    
    randomSeed(reset);
  }

  void branch(float x_, float y_, float a_, float s_) {

    branches.add(new Branch(x_, y_, a_, s_));

    while (branches.size () > 0) {

      Branch b = branches.get(0);
      branches.remove(0);

      strokeWeight(b.s/16);
      float a = random(-PI/16, PI/16)+b.a;
      float factor = 1;
      if(h > steps)
        factor = h/steps;//map(h,0,160,0,log(steps));
      float nx = cos(a)*b.s*stretch*factor+b.x;
      float ny = sin(a)*b.s*stretch*factor+b.y;
      stroke(32, 16*b.s);
      line(b.x, b.y, nx, ny);

      if (b.s>10) {
        float offset  = PI/8*angle;

        branches.add(new Branch(nx, ny, b.a-random(PI/4)+offset, b.s*random(0.6, 0.8)));
        branches.add(new Branch(nx, ny, b.a+offset, b.s*random(0.6, 0.8)));
        branches.add(new Branch(nx, ny, b.a+random(PI/4)+offset, b.s*random(0.6, 0.8)));
      } 
      else {
        shape.add(new Vec2D(nx, ny));
        float w = random(155, 255);
        stroke(255, w, w, random(32, 192));
        strokeWeight(random(0, 8));
        float offx = random(-2, 2);
        float offy = random(-2, 2);
        point(nx+offx, ny+offy);
      }
    }
  }
  
  void absorbParticles() {
  ArrayList<VerletParticle2D> remove = new ArrayList<VerletParticle2D>();
  for (VerletParticle2D p : physics.particles) {
    Vec2D point = p.getPreviousPosition();
    if (containsPoint(p)) {
      remove.add(p);
      setHeight(h + 5);
    }
  }
  for (VerletParticle2D p : remove) {
    physics.particles.remove(p);
  }
}


  boolean containsPoint(Vec2D point) {
    return shape != null && shape.containsPoint(point); 
  }

  class Branch {
    float x, y, a, s;
    public Branch(float x_, float y_, float a_, float s_) {
      x = x_;
      y = y_;
      a = a_;
      s = s_;
    }
  }


  ArrayList<Branch> branches = new ArrayList<Branch> ();
}

