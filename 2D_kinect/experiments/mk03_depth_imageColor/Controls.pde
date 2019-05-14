void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      tiltAngle++;
    } else if (keyCode == DOWN) {
      tiltAngle--;
    }
    tiltAngle = constrain(tiltAngle, 0, 30);
    kinect.setTilt(tiltAngle);
  }
}
