clc;close all;clear all;
%Load point cloud
pCloud = pcread('bun000.ply'); 

figure('Name','all point cloud')
pcshow(pCloud);
%Initialization (Separation Rotation and Translation) 

[P,Q,RO,TO]=pcInitialization(pCloud);

figure('Name','point cloud P and Q')
pcshow(P);
hold on
pcshow(Q);
hold off

%Add noise
pSNR=40;

if(pSNR)    
noisep =awgn(P.Location,pSNR,'measured'); 
P =pointCloud(noisep);

noisep =awgn(Q.Location,pSNR,'measured'); 
Q =pointCloud(noisep);
end
%Add outliers
pOUT=0;
if(pOUT)
AOut = (rand(pOUT,3)-0.5)*0.2+repmat(mean(P.Location)', 1, pOUT)';
outp=[P.Location;AOut];
P =pointCloud(outp);

BOut = (rand(pOUT,3)-0.5)*0.2+repmat(mean(Q.Location)', 1, pOUT)';
outp=[Q.Location;BOut];
Q =pointCloud(outp);
end

figure('Name','point cloud P_Noise_Out and Q_Noise_Out')
pcshow(P);
hold on
pcshow(Q);
hold off

%measured point cloud
pMeasure=0;
if(pMeasure)
load('IMAGEpc');
P=pointCloud(P1);
Q=pointCloud(Q1);
figure('Name','point cloud P and Q')
 pcshow(P.Location,'r');
 hold on
 pcshow(Q.Location,'b');
 hold off
end
%Point Group

PGNum=600;
Pdown = pcdownsample(P,'random',0.05);
Qdown = pcdownsample(Q,'random',0.05);

Ppc=P.Location;
Qpc=Q.Location;

Pdownpc=Pdown.Location;
Qdownpc=Qdown.Location;

PC=sepknn(Ppc,Pdownpc,PGNum);
QC=sepknn(Qpc,Qdownpc,PGNum);



%PAD feature
PAD=0;
if(PAD)
PF=fPAD( Pdownpc,PC );
QF=fPAD( Qdownpc,QC );
Fn=10;
end
%MAP feature
MAP=0;
if(MAP)
MPRw=[1;1;1;1;1];
[ePC,PF]=fMPR( Pdownpc,PC,MPRw);
[eQC,QF]=fMPR( Qdownpc,QC,MPRw);
PF=PF*0.00001;
QF=QF*0.00001;
Fn=5;
end
%Use K-SVD to solve miss point and noise and get Sparse feature 
SpF=1;
if(SpF)
[PF,PC2]=SpFeature( Pdownpc,PC,PGNum );
[QF,QC2]=SpFeature( Qdownpc,QC,PGNum );
Fn=121;
end
%Match feature
disp('start match group');
[matchP,matchQ ] = sparsematchslow( PF,QF,Fn );

figure('Name','point cloud P_Noise_Out and PG matched')
plot3(Ppc(:,1),Ppc(:,2),Ppc(:,3),'.');
hold on
for i=1:size(matchP,2)
plot3(PC(:,1,matchP(i)),PC(:,2,matchP(i)),PC(:,3,matchP(i)),'o');
end
hold off

figure('Name','point cloud Q_Noise_Out and PG matched')
plot3(Qpc(:,1),Qpc(:,2),Qpc(:,3),'.');
hold on
for i=1:size(matchQ,2)
plot3(QC(:,1,matchQ(i)),QC(:,2,matchQ(i)),QC(:,3,matchQ(i)),'o');
end
hold off
%Register point cloud

%close all
n=1;

fa=zeros(1,1);
DisR=zeros(1,1);
DisT=zeros(1,1);
for i=1:size(matchQ,2)
% if(Dis(i)>0.0)
PQdis=Rcpddis(PC(:,:,matchP(i)),QC(:,:,matchQ(i)));

if(PQdis<3)%30
fa(n)=i;

% test
[cpdR1 ,cpdT1,Qrt,Qpgrt ]=Rcpd(PC(:,:,matchP(i)),QC(:,:,matchQ(i)),Ppc,Qpc);
DisR(n)=sum(sum(abs(cpdR1-RO)));
DisT(n)=sum(sum(abs(cpdT1+TO')));
%Ricp(Qpgrt,PC(:,:,matchP(i)),Qrt,Ppc);
n=n+1;
end

end

min(DisR)
min(DisT)
[~,rows]=min(DisR);


for i=fa(rows):fa(rows);
% if(Dis(i)>0.0)
% test
[cpdR1 ,cpdT1,Qrt,Qpgrt ]=Rcpd(PC(:,:,matchP(i)),QC(:,:,matchQ(i)),Ppc,Qpc);
sum(sum(abs(cpdR1-RO)))
sum(sum(abs(cpdT1+TO')))
Ricp(Qpgrt,PC(:,:,matchP(i)),Qrt,Ppc);
end

