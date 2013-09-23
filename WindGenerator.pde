class WindGenerator {
  Vec2D wind;
  GravityBehavior windBehavior;

  float magnitude = 0.15;
  float xoff = 10000;
  float yoff = 0;

  public WindGenerator() {
    wind = new Vec2D();
    windBehavior = new GravityBehavior(wind);
    physics.addBehavior(windBehavior);
  }
  // 
  void update() {
    wind.set(map(noise(xoff), 0, 1, -0.15, 0.15), map(noise(yoff), 0, 1, -0.15, 0.15));

    // Removing and adding the behavior or it has no effect
    if (windBehavior != null)
      physics.removeBehavior(windBehavior);
    physics.addBehavior(windBehavior);

    //update our perlin noise-controlling variables
    xoff += 0.004;
    yoff += 0.006;
  }
}

