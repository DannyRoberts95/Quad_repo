
class FlowField {
  PVector[][] flowGrid;
  int   cols, rows;
  int   resolution;
  float zNoise = 0.0;

  FlowField (int res) {
    resolution = res;
    rows = height/resolution;
    cols = width/ resolution;
    flowGrid = new PVector[cols][rows];
  }

  void updateField() {
    float xNoise = 0;
    for (int i = 0; i < cols; i++) {
      float yNoise = 0;
      for (int j = 0; j < rows; j++) {
        float angle = radians((noise(xNoise, yNoise, zNoise)) * 700);
        flowGrid[i][j] = PVector.fromAngle(angle);
        yNoise += 0.03; 
      }
      xNoise += 0.03;
    }
    zNoise += 0.05;
  }

  PVector lookupVelocity(PVector particleLocation) {
    int column = int(
      constrain(
      particleLocation.x / resolution, 
      0, 
      cols - 1)
      );
    int row = int(
      constrain(
      particleLocation.y / resolution, 
      0, 
      rows - 1)
      );
    return flowGrid[column][row].copy();
  }
}
