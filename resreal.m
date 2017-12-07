clc;close all;clear all;
%Load point cloud
%measured point cloud
load('./roomdata/roomD.mat'); 

load('./resrealdata/Pr60_1.mat');
load('./resrealdata/Pr60_2.mat');
load('./resrealdata/Pr60_3.mat');
load('./resrealdata/Pr60_4.mat');
load('./resrealdata/Pr60_5.mat');
load('./resrealdata/Pr60_6.mat');
load('./resrealdata/Pr60_7.mat');
load('./resrealdata/Pr60_8.mat');
load('./resrealdata/Pr60_9.mat');
load('./resrealdata/Pr60_10.mat');
load('./resrealdata/Pr60_11.mat');
load('./resrealdata/Pr60_12.mat');

load('./resrealdata/Pr120_1.mat');
load('./resrealdata/Pr120_2.mat');
load('./resrealdata/Pr120_3.mat');
load('./resrealdata/Pr120_4.mat');
load('./resrealdata/Pr120_5.mat');
load('./resrealdata/Pr120_6.mat');
load('./resrealdata/Pr120_7.mat');
load('./resrealdata/Pr120_8.mat');
load('./resrealdata/Pr120_9.mat');
load('./resrealdata/Pr120_10.mat');
load('./resrealdata/Pr120_11.mat');
load('./resrealdata/Pr120_12.mat');

p60{1}=Pr60_1;
p60{2}=Pr60_2;
p60{3}=Pr60_3;
p60{4}=Pr60_4;
p60{5}=Pr60_5;
p60{6}=Pr60_6;
p60{7}=Pr60_7;
p60{8}=Pr60_8;
p60{9}=Pr60_9;
p60{10}=Pr60_10;
p60{11}=Pr60_11;
p60{12}=Pr60_12;

p120{1}=Pr120_1;
p120{2}=Pr120_2;
p120{3}=Pr120_3;
p120{4}=Pr120_4;
p120{5}=Pr120_5;
p120{6}=Pr120_6;
p120{7}=Pr120_7;
p120{8}=Pr120_8;
p120{9}=Pr120_9;
p120{10}=Pr120_10;
p120{11}=Pr120_11;
p120{12}=Pr120_12;



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

%q1=P90{2}.Location*R;
figure
%pcshow(P90{1}.Location,'r');
hold on
%plot3(p60{1}(:,1),p60{1}(:,2),p60{1}(:,3),'.');
plot3(p120{1}(:,1),p120{1}(:,2),p120{1}(:,3),'.');
for i=2:12
 p90=P90{i}.Location*R^(i-1);
 pp60=p60{i}*R^(i-1);
 pp120=p120{i}*R^(i-1);
 %plot3(p90(:,1),p90(:,2),p90(:,3),'.');
 %plot3(pp60(:,1),pp60(:,2),pp60(:,3),'.');
 plot3(pp120(:,1),pp120(:,2),pp120(:,3),'.');
end
