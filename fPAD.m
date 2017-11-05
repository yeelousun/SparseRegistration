function [ bijiao1 ] = fPAD( FD,C )

pnum=size(FD,1);
bijiao1=zeros(pnum,10);
bijiao2=zeros(pnum,10);
for i=1:pnum
T=C(:,:,i)';

x=T(1,:)';
y=T(2,:)';
z=T(3,:)';

planeData=[x,y,z];


% 协方差矩阵的SVD变换中，最小奇异值对应的奇异向量就是平面的方向
xyz0=mean(planeData,1);
centeredPlane=bsxfun(@minus,planeData,xyz0);
[~,~,V]=svd(centeredPlane);

a=V(1,3);
b=V(2,3);
c=V(3,3);
d=-dot([a b c],xyz0);

dic=zeros(1,size(T,2));
for j=1:size(T,2)
 
dic(j)=abs(a*T(1,j)+b*T(2,j)+c*T(3,j)+d)/sqrt(a^2+b^2+c^2);
end

[bijiao1(i,:),bijiao2(i,:)]=hist(dic);
end


end

