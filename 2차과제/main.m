clear;
droneObj = ryze("TELLO-FE0145");

takeoff(droneObj);
pause(3);

moveleft(droneObj, 'Distance', 1.2);
pause(3);

turn(droneObj, deg2rad(30));
pause(3);

moveforward(droneObj, 'Distance', 0.8);
pause(3);

turn(droneObj, deg2rad(60));
pause(3);

moveforward(droneObj, 'Distance', 0.4);
pause(3);

cameraObj = camera(droneObj);
preview(cameraObj);
pause(3);
frame = snapshot(cameraObj);
closePreview(cameraObj);
imshow(frame);

turn(droneObj, deg2rad(-30));
pause(3);

moveright(droneObj, 'Distance', 0.8);
pause(3);

land(droneObj);