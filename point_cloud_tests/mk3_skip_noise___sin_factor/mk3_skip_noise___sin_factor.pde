import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

float a = 0.0;
float noiseOffsetX, noiseOffsetY, noiseOffsetZ;
float noiseIncX, noiseIncY, noiseIncZ;

int skip = 3;
int minthresh = 0;
int maxthresh = 850;
float factor = 1000;

void setup() {
  
  fullScreen(P3D);
  colorMode(HSB,360,100,100,100);
  kinect = new Kinect(this);
  kinect.initDepth();

  noiseOffsetX = random(10000);
  noiseOffsetY = random(10000);
  noiseOffsetZ = random(10000);
  
}

void draw() {

  background(0);
  int[] depth = kinect.getRawDepth();
  
  
  noiseIncX = map(noise(mouseX),0,width,0,1);
  noiseIncY = map(noise(mouseY),0,height,0,1);
  noiseIncZ = 0.000;
  
  translate(width/2, height/2, 30);
  rotateX(-18.56);
  for (int x = 0; x < kinect.width; x += skip) {
    
    if(random(1) > 0.75) continue;
    
    factor = map(noise(noiseOffsetZ), 0, 1, 500, 1000);
    for (int y = 0; y < kinect.height; y += skip) {
      
      if(random(1) > 0.5) continue;
        
      int offset = x + y * kinect.width;

      int rawDepth = depth[offset];

      if (rawDepth > minthresh && rawDepth < maxthresh) {
        PVector point = depthToWorld(x, y, rawDepth);

        float xOffset = map(noise(noiseOffsetX), 0, 1, 0, 0.05);
        float yOffset = map(noise(noiseOffsetY), 0, 1, 0, 0.05);
        
         
        stroke(100);
        strokeWeight(2);
        pushMatrix();
        beginShape(POINTS);
        translate((point.x+xOffset)*factor, (point.y+yOffset)*factor, factor-point.z*factor);
        vertex(0, 0);
        endShape();
        popMatrix();
        
        noiseOffsetX += noiseIncX;
        noiseOffsetY += noiseIncY;
        noiseOffsetZ += noiseIncZ;
      }
    }
    
  }

  // Rotate
  a += 0.005f;
}

// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

// Only needed to make sense of the ouput depth values from the kinect
PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

  // Drawing the result vector to give each point its three-dimensional space
  PVector result = new PVector();
  double depth =  rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}
