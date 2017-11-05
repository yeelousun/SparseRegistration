function [Is ,clss,grid_centerss,class_stats]= point2imageSmall( x,y,z,numc,numr ,imageshow)
%%%%%

%%%%%

% zmean=mean(z);
xl = -0.1; xr = 0.1; yl = -0.1; yr = 0.1;
xg = linspace(xl,xr,numc); yg = linspace(yl,yr,numr);
scmin=fix(numc/4);scmax=fix(numc/4)*3;srmin=fix(numr/4);srmax=fix(numr/4)*3;
xgs=xg(scmin:scmax);
ygs=yg(srmin:srmax);

[X,Y] = meshgrid(xg,yg);
[Xs,Ys] = meshgrid(xgs,ygs);
grid_centerss = [Xs(:),Ys(:)];

grid_centers = [X(:),Y(:)];

clss = knnsearch(grid_centers,[x,y]); 

local_stat = @(x)mean(x);

class_stat = accumarray(clss,z,[numr*numc 1],local_stat);
class_stat_M  = reshape(class_stat , size(Y)); 
class_stat_M (class_stat_M == 0) =NaN;
I = class_stat_M(end:-1:1,:);
Is=I(scmin:scmax,srmin:srmax);
Iss = Is(end:-1:1,:);
class_stats=reshape(Iss,(scmax-scmin+1)*(srmax-srmin+1),1);

if(imageshow)
Is = ( Is - min(min(Is)) ) ./ ( max(max(Is)) - min(min(Is)) );
figure('Name','point2image');
imshow(Is);
end
end


