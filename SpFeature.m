function [ PC , FC2 ] = SpFeature( FD,FC )


pnum=size(FD,1);
FC2=zeros(121,3,pnum);

PC=zeros(121,pnum);

for i=1:pnum
A=FC{i};
downNum=size(A,1);
if(mod(i,100)==0)
    disp('*');
    i
end
%svd
[~,AU,AS,AV,Amean]=ALLpointSVDD(A,downNum);

PCloud=(AU(:,1:3));

Px=PCloud(:,1);
Py=PCloud(:,2);
Pz=PCloud(:,3);

%fit plane
numx=20;
numy=20;
imageshow=0;
[AImage,~,AIxy,~]=point2imageSmall( Px,Py,Pz,numx,numy,imageshow );

AI0=AImage;

%image with out NAN
AI0id=find(~isnan(AI0));
AImean=mean(AI0(AI0id));

AI1=AI0;
AI1(isnan(AI1)) = AImean;

%ksvd with out NAN
AI1=double(AI1);

params.x = AI1;
params.blocksize =4;
params.dictsize =fix(size(AI0id,1)/params.blocksize)+params.blocksize;
params.psnr =1;
params.maxval = 1.0;
params.trainnum = 64;%64
params.iternum = 50;%50
params.memusage = 'high';
params.noisemode= 'psnr';
params.xn = AI1;

[imout, ~,~] = ksvddenoise(params,-1);
PC(:,i)=imout(:);
%image to point 

AI2p=imout(end:-1:1,:);
AI2z=reshape(AI2p,1,size(imout,1)*size(imout,2));
AI02p=[AIxy,AI2z'];

Up=AI02p;
Sp=AS(1:3,1:3);
Vp=AV(:,1:3)';

BK=Up*Sp*Vp;
ABK=bsxfun(@plus,Amean,BK);

FC2(:,:,i)=ABK;
end
PC=PC';
end