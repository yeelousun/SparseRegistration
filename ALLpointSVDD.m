function [ B,U,S,V ,xyz0] = ALLpointSVDD( A,n )

xyz0=mean(A,1);
centeredPlane=bsxfun(@minus,A,xyz0);

[U,S,V] = svd(centeredPlane); %调用pca分析函数

% [ va1,vb1] = LiftRight( centeredPlane,V(:,1) );
% [ va2,vb2] = LiftRight( centeredPlane,V(:,2) );
% [ va3,vb3] = LiftRight( centeredPlane,V(:,3) );

%first
if (xyz0*V(:,1)<0)
    U(:,1)=-U(:,1);
    V(:,1)=-V(:,1);
end
%second
if (xyz0*V(:,2)<0)
    U(:,2)=-U(:,2);
    V(:,2)=-V(:,2);
end
%third
if (xyz0*V(:,3)<0)
    U(:,3)=-U(:,3);
    V(:,3)=-V(:,3);
end


Up=U(1:n,1:3);
Sp=S(1:3,1:3);
Vp=V(:,1:3)';

B=Up*Sp*Vp;

end