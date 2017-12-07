clc;close all;clear all;
%Load point cloud
%measured point cloud
pMeasure=1;
if(pMeasure)
P = pcread('./roomdata/px120y0z00.ply'); 
Q = pcread('./roomdata/px120y0z30.ply');

figure('Name','point cloud P and Q')
 pcshow(P);
 hold on
 pcshow(Q);
 hold off
end

Tx = 0;
Ty = 0;
Tz = 0;  
rx = 0;   
ry = -pi/6;
rz = 0;

% Translation vector
T = [Tx, Ty, Tz];

% Rotation values 
Rx = [1 0 0;
      0 cos(rx) -sin(rx);
      0 sin(rx) cos(rx)];
  
Ry = [cos(ry) 0 sin(ry);
      0 1 0;
      -sin(ry) 0 cos(ry)];
  
Rz = [cos(rz) -sin(rz) 0;
      sin(rz) cos(rz) 0;
      0 0 1];

% Rotation matrix
R = Rx*Ry*Rz;

tform=[R(1,:)  0; ...
       R(2,:)  0; ...
       R(3,:)  0; ...
        T      1];
    
tform1 = affine3d(tform);
BptCloudRT = pctransform(Q,tform1);

figure('Name','point cloud P and Qrt')
 pcshow(P.Location,'r');
 hold on
 pcshow(BptCloudRT.Location,'b');
 hold off
