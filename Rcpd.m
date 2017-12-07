function [R,T,Yicp,Yicp1] = Rcpd( X,Y,X1,Y1,dis )

% add a random rigid transformation

% Set the options

opt.method='rigid'; % use rigid registration
opt.viz=dis;          % show every iteration
opt.outliers=0.6;     % do not assume any noise 

opt.normalize=1;    % normalize to unit variance and zero mean before registering (default)
opt.scale=1;        % estimate global scaling too (default)
opt.rot=1;          % estimate strictly rotational matrix (default)
opt.corresp=0;      % do not compute the correspondence vector at the end of registration (default)

opt.max_it=100;     % max number of iterations
opt.tol=1e-8;       % tolerance


% registering Y to X
[Transform, ~]=cpd_register(X,Y,opt);

%figure,cpd_plot_iter(X1, Y1); title('Before');
%figure,cpd_plot_iter(X, Transform.Y);  title('After registering Y to X');

%Transform.Y=T*normal.xscale+repmat(normal.xd,M,1);
Yicp = Transform.s*Transform.R *  Y1' + repmat(Transform.t, 1,size(Y1,1) );
%Yicp=Transform.normal.xscale*Yicp2'+repmat(Transform.normal.xd,1,size(Y1,1));
Yicp1 = Transform.s*Transform.R *  Y' + repmat(Transform.t, 1,size(Y,1) );
ptCloudP = pointCloud(X1);
ptCloudQ = pointCloud(Yicp');
ptCloudP1 = pointCloud(X);
ptCloudQ1 = pointCloud(Yicp1');
if(opt.viz)
figure
pcshow(ptCloudP.Location,'b');
hold on;
pcshow(ptCloudP1.Location,'k');
pcshow(ptCloudQ.Location,'r');
pcshow(ptCloudQ1.Location,'y');
hold off;
%figure,cpd_plot_iter(X1, Yicp');  
title('CPD After registering Q to P');
% figure
% plot3(ptCloudP.Location(:,1),ptCloudP.Location(:,2),ptCloudP.Location(:,3),'b.');
% hold on; 
% plot3(ptCloudQ.Location(:,1),ptCloudQ.Location(:,2),ptCloudQ.Location(:,3),'r.');
% axis off
end
R=Transform.s*Transform.R;
T=Transform.t;
Yicp=Yicp';
Yicp1=Yicp1';
end

