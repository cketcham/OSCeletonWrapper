import com.cketcham.osceleton.*;

import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

import java.util.LinkedList;
import java.util.Random;

OSCeletonWrapper osceleton;

HashMap<Skeleton, GrowingTree> trees = new HashMap<Skeleton, GrowingTree>();

int MAX_PARTICLES = 40;

VerletPhysics2D physics;
WindGenerator wind;
AttractionBehavior[] attractors = new AttractionBehavior[4];

float MAX_PARTICLE_WIDTH = 10;
float MIN_PARTICLE_WIDTH = 7;
float BOUNDING_BOX = MAX_PARTICLE_WIDTH + 1;

Random generator = new Random();

void setup() {
  frameRate(40);

  size(800, 560, P2D);
  colorMode(RGB, 255);
  background(192);
  smooth(8);

  osceleton = new OSCeletonWrapper(this, 12345);

  physics = new VerletPhysics2D();
  physics.setDrag(0.05f);
  physics.setWorldBounds(new Rect(-BOUNDING_BOX, -BOUNDING_BOX, width+BOUNDING_BOX*2, height+BOUNDING_BOX*2));

  wind = new WindGenerator();
}

void addParticle() {

  float x, y;

  if (generator.nextFloat() < 0.5) {
    if (generator.nextFloat() < 0.5) {
      x = -MAX_PARTICLE_WIDTH;
    } 
    else {
      x = width+MAX_PARTICLE_WIDTH;
    }
    y = generator.nextFloat()*height/2;
  } 
  else {
    y = -MAX_PARTICLE_WIDTH;
    x = generator.nextFloat()*width;
  }

  Stream p = new Stream(Vec2D.randomVector().scale(5).addSelf(x, y));
  physics.addParticle(p);
  p.addBehavior(new GravityBehavior(new Vec2D(random(-0.05, 0.05), random(-0.05, 0.05))));
}

void removeLostParticles() {
  ArrayList<VerletParticle2D> remove = new ArrayList<VerletParticle2D>();
  for (VerletParticle2D p : physics.particles) {
    Vec2D point = p.getPreviousPosition();
    if (point.x <= -BOUNDING_BOX || point.x >= width+BOUNDING_BOX || point.y <= -BOUNDING_BOX || point.y >= height+BOUNDING_BOX)
      remove.add(p);
  }
  for (VerletParticle2D p : remove) {
    physics.particles.remove(p);
  }
}

void draw() {
  frame.setTitle(frameRate + "fps");
  background(192);

  wind.update();

  removeLostParticles();
  if (physics.particles.size() < factorTreesizes()) {
    addParticle();
  }
  physics.update();
  for (VerletParticle2D p : physics.particles) {
    ((Stream) p).display();
  }

  for (Skeleton sk : osceleton.getSkeletons()) {
    if (sk.isVisible() && handsAboveHead(sk)) {
      //      Uncomment these lines to draw the skeleton
      //      ellipse(sk.get("head").x, sk.get("head").y, 40, 60);
      //      fill(255, 50, 50);
      //      ellipse(sk.get("l_hand").x, sk.get("l_hand").y, 30, 30);
      //      fill(50, 50, 255);
      //      ellipse(sk.get("r_hand").x, sk.get("r_hand").y, 30, 30);
      //
      //      for (String name : sk.mJoints.keySet()) {
      //        Joint j = sk.mJoints.get(name);
      //        ellipse(j.x, j.y, 15, 15);
      //      }

      GrowingTree tree = trees.get(sk);
      if (tree == null && sk.get("head").x!=0) {
        tree = new GrowingTree(sk.get("head").x, height, 100, 80);
        trees.put(sk, tree);
      }
      if (tree != null) {

        Joint neck = sk.get("neck");
        Joint torso = sk.get("torso");
        tree.setAngle(atan2((neck.y-torso.y), (neck.x-torso.x))+1.5);

        Joint l_hand = sk.get("l_hand");
        Joint r_hand = sk.get("r_hand");

        float distance = (torso.y-l_hand.y)*(torso.y-l_hand.y) +(torso.x-l_hand.y)*(torso.x-l_hand.y);
        distance += (torso.y-r_hand.y)*(torso.y-r_hand.y) +(torso.x-r_hand.y)*(torso.x-r_hand.y);

        tree.setStretchFactor(map(distance/2, 54646, 230855, 1, 1.2));

        tree.absorbParticles();

        tree.render();
      }
    }
    else {
      trees.remove(sk);
    }
  }
}

boolean handsAboveHead(Skeleton sk) {
  float head_y = sk.get("head").y;
  float offset = 200;
  return sk.get("l_hand").y - offset < head_y || sk.get("r_hand").y - offset < head_y;
}

float factorTreesizes() {
  float totalH = 0;
  for (Skeleton sk : osceleton.getSkeletons()) {
    if (sk.isVisible() && handsAboveHead(sk) && trees.get(sk) != null) {
      if (totalH == 0)
        totalH = trees.get(sk).h;
      else
        totalH = Math.min(totalH, trees.get(sk).h);
    }
  }
  return map(totalH, 0, 170, MAX_PARTICLES, 0);
}

