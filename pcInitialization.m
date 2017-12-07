function [AptCloud, BptCloudRT,R,T] = pcInitialization(ptCloud)

% ------separate point cloud-------------------
%[xmin,xmax;ymin,ymax;zmin,zmax]
Aroi = [-inf,0.03;-inf,inf;-inf,inf]; 
Broi = [-0.03,inf;-inf,inf;-inf,inf];

Aindices = findPointsInROI(ptCloud, Aroi);
AptCloud = select(ptCloud,Aindices);

Bindices = findPointsInROI(ptCloud, Broi);
BptCloud = select(ptCloud,Bindices);

overlap=(AptCloud.Count+BptCloud.Count-ptCloud.Count)/ptCloud.Count
% ------------R&T------------------------------
Tx = 0.1;
Ty = 0;
Tz = 0;  
rx = -pi/6;   
ry = 0;
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
BptCloudRT = pctransform(BptCloud,tform1);


end