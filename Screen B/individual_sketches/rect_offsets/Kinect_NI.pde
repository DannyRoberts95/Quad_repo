PVector getRighthandLocation() {
  PVector rightHand = new PVector();
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);
    //If we detect one user we have to draw it
    if ( kinect.isTrackingSkeleton(userId)) {
      rightHand = new PVector(getJointLocation(userId, SimpleOpenNI.SKEL_RIGHT_HAND).x, getJointLocation(userId, SimpleOpenNI.SKEL_RIGHT_HAND).y);
      return rightHand;
    }
  }
  return rightHand;
}
PVector getLefthandLocation() {
  PVector leftHand = new PVector();
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);
    //If we detect one user we have to draw it
    if ( kinect.isTrackingSkeleton(userId)) {
      leftHand = new PVector(getJointLocation(userId, SimpleOpenNI.SKEL_LEFT_HAND).x, getJointLocation(userId, SimpleOpenNI.SKEL_LEFT_HAND).y);
    }
  }
  return leftHand;
}

//returns a 2D vector with the requested joints location on screen.
//pass in the user ID and requested joint 
PVector getJointLocation(int userId, int jointID){
//Pvector to hold the 3d location vector
PVector joint = new PVector();
  //kinect.getJointPositionSkeleton assigns a 3d vector to joint
    kinect.getJointPositionSkeleton(userId, jointID,joint);
    PVector convertedJoint = new PVector();
    //3d vector and empty 2d vector are passed to function and converted to projective vectors
    kinect.convertRealWorldToProjective(joint, convertedJoint);
    float x = map(convertedJoint.x,0,kinect.depthImage().width,0,width);
    float y = map(convertedJoint.y,0,kinect.depthImage().height,0,height);
    PVector cartesianLocation = new PVector(x,y);
    return cartesianLocation;
}

void onNewUser(SimpleOpenNI kinect, int userID) {
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
  trackingUser = true;
}

void onLostUser(int userId) {
  println("onLostUser - userId: " + userId);
  trackingUser = false;
}

//Draw the skeleton
//void drawSkeleton(int userId) {
//  stroke(0);
//  strokeWeight(5);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  //kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
//  stroke(0,255,0);
//  fill(255);
//  drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
//  drawJoint(userId, SimpleOpenNI.SKEL_NECK);
//  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
//  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
//  drawJoint(userId, SimpleOpenNI.SKEL_NECK);
//  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
//  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
//  drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
//  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
//  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
//  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);
//  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
//  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
//  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
//  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
//  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
//  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
  
//}

//void drawJoint(int userId, int jointID) {
//  //joint will store the 3D vector co ords for the joint locatin in space
//  PVector joint = new PVector();
//  float confidence = kinect.getJointPositionSkeleton(userId, jointID,joint);
//    if(confidence < 0.5){
//      return;
//    }
//    PVector convertedJoint = new PVector();
//    kinect.convertRealWorldToProjective(joint, convertedJoint);
//    float x = map(convertedJoint.x,0,kinect.depthImage().width,0,width);
//    float y = map(convertedJoint.y,0,kinect.depthImage().height,0,height);
//    ellipse(x,y, 25, 25);
//  }
  
  //Generate the angle
  //float angleOf(PVector one, PVector two, PVector axis) {
  //  PVector limb = PVector.sub(two, one);
  //  return degrees(PVector.angleBetween(limb, axis));
  //}

  ////Calibration not required

//void MassUser(int userId) {
//  if(kinect.getCoM(userId,com)){
//    kinect.convertRealWorldToProjective(com,com2d);
//    stroke(100,255,240);
//    strokeWeight(3);
//    beginShape(LINES);
//    vertex(com2d.x,com2d.y - 5);
//    vertex(com2d.x,com2d.y + 5);
//    vertex(com2d.x - 5,com2d.y);
//    vertex(com2d.x + 5,com2d.y);
//    endShape();
//    fill(0,255,100);
//    text(Integer.toString(userId),com2d.x,com2d.y);
//  }
//}

//public void ArmsAngle(int userId){
//  // get the positions of the three joints of our right arm
//  PVector rightHand = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
//  PVector rightElbow = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,rightElbow);
//  PVector rightShoulder = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,rightShoulder);
//  // we need right hip to orient the shoulder angle
//  PVector rightHip = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,rightHip);
//  // get the positions of the three joints of our left arm
//  PVector leftHand = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
//  PVector leftElbow = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_ELBOW,leftElbow);
//  PVector leftShoulder = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,leftShoulder);
//  // we need left hip to orient the shoulder angle
//  PVector leftHip = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,leftHip);
//  // reduce our joint vectors to two dimensions for right side
//  PVector rightHand2D = new PVector(rightHand.x, rightHand.y);
//  PVector rightElbow2D = new PVector(rightElbow.x, rightElbow.y);
//  PVector rightShoulder2D = new PVector(rightShoulder.x,rightShoulder.y);
//  PVector rightHip2D = new PVector(rightHip.x, rightHip.y);
//  // calculate the axes against which we want to measure our angles
//  PVector torsoOrientation = PVector.sub(rightShoulder2D, rightHip2D);
//  PVector upperArmOrientation = PVector.sub(rightElbow2D, rightShoulder2D);
//  // reduce our joint vectors to two dimensions for left side
//  PVector leftHand2D = new PVector(leftHand.x, leftHand.y);
//  PVector leftElbow2D = new PVector(leftElbow.x, leftElbow.y);
//  PVector leftShoulder2D = new PVector(leftShoulder.x,leftShoulder.y);
//  PVector leftHip2D = new PVector(leftHip.x, leftHip.y);
//  // calculate the axes against which we want to measure our angles
//  PVector torsoLOrientation = PVector.sub(leftShoulder2D, leftHip2D);
//  PVector upperArmLOrientation = PVector.sub(leftElbow2D, leftShoulder2D);
//  // calculate the angles between our joints for rightside
//  RightshoulderAngle = angleOf(rightElbow2D, rightShoulder2D, torsoOrientation);
//  RightelbowAngle = angleOf(rightHand2D,rightElbow2D,upperArmOrientation);
//  // show the angles on the screen for debugging
//  fill(255,0,0);
//  scale(1);
//  text("Right shoulder: " + int(RightshoulderAngle) + "\n" + " Right elbow: " + int(RightelbowAngle), 20, 20);
//  // calculate the angles between our joints for leftside
//  LeftshoulderAngle = angleOf(leftElbow2D, leftShoulder2D, torsoLOrientation);
//  LeftelbowAngle = angleOf(leftHand2D,leftElbow2D,upperArmLOrientation);
//  // show the angles on the screen for debugging
//  fill(255,0,0);
//  scale(1);
//  text("Left shoulder: " + int(LeftshoulderAngle) + "\n" + " Left elbow: " + int(LeftelbowAngle), 20, 55);

//}

//void LegsAngle(int userId) {
//  // get the positions of the three joints of our right leg
//  PVector rightFoot = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_FOOT,rightFoot);
//  PVector rightKnee = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_KNEE,rightKnee);
//  PVector rightHipL = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,rightHipL);
//  // reduce our joint vectors to two dimensions for right side
//  PVector rightFoot2D = new PVector(rightFoot.x, rightFoot.y);
//  PVector rightKnee2D = new PVector(rightKnee.x, rightKnee.y);
//  PVector rightHip2DLeg = new PVector(rightHipL.x,rightHipL.y);
//  // calculate the axes against which we want to measure our angles
//  PVector RightLegOrientation = PVector.sub(rightKnee2D, rightHip2DLeg);
//  // calculate the angles between our joints for rightside
//  RightLegAngle = angleOf(rightFoot2D,rightKnee2D,RightLegOrientation);
//  fill(255,0,0);
//  scale(1);
//  text("Right Knee: " + int(RightLegAngle), 500, 20);
//  // get the positions of the three joints of our left leg
//  PVector leftFoot = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_FOOT,leftFoot);
//  PVector leftKnee = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_KNEE,leftKnee);
//  PVector leftHipL = new PVector();
//  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,leftHipL);
//  // reduce our joint vectors to two dimensions for left side
//  PVector leftFoot2D = new PVector(leftFoot.x, leftFoot.y);
//  PVector leftKnee2D = new PVector(leftKnee.x, leftKnee.y);
//  PVector leftHip2DLeg = new PVector(leftHipL.x,leftHipL.y);
//  // calculate the axes against which we want to measure our angles
//  PVector LeftLegOrientation = PVector.sub(leftKnee2D, leftHip2DLeg);
//  // calculate the angles between our joints for left side
//  LeftLegAngle = angleOf(leftFoot2D,leftKnee2D,LeftLegOrientation);
//  // show the angles on the screen for debugging
//  fill(255,0,0);
//  scale(1);
//  text("Leftt Knee: " + int(LeftLegAngle), 500, 55);
//}
