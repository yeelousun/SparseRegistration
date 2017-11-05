function [icpR,icpT,P1,Q1] = Ricp(icpD,icpM,P,Q )
ptCloudM = pointCloud(icpM);
ptCloudD = pointCloud(icpD);
ptCloudP = pointCloud(P);
ptCloudQ = pointCloud(Q);

tform2 = pcregrigid(ptCloudM, ptCloudD, 'Metric','pointToPoint','Extrapolate', true);
ptCloudAlignedM = pctransform(ptCloudM,tform2);
ptCloudAlignedQ = pctransform(ptCloudQ,tform2);
icpR= [tform2.T(1,1) tform2.T(1,2) tform2.T(1,3);
      tform2.T(2,1) tform2.T(2,2) tform2.T(2,3);
      tform2.T(3,1) tform2.T(3,2) tform2.T(3,3)];
icpT=[tform2.T(4,1) tform2.T(4,2) tform2.T(4,3)];
%show point cloud
figure
pcshow(ptCloudD.Location,'b');
hold on;
pcshow(ptCloudAlignedM.Location,'r');
hold off;


figure

pcshow(ptCloudP.Location,'b');
hold on;
pcshow(ptCloudAlignedQ.Location,'r');
hold off;
title('ICP After registering Q to P');
P1=ptCloudP.Location;
Q1=ptCloudAlignedQ.Location;
