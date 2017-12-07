clc;close all;clear all;
%Load point cloud
t1=clock;
pCloud = pcread('bun000.ply'); 

figure('Name','all point cloud')
pcshow(pCloud);
%Initialization (Separation Rotation and Translation) 

[P,Q,RO,TO]=pcInitialization(pCloud);

figure('Name','point cloud P and Q')
pcshow(P.Location,'b');
hold on
pcshow(Q.Location,'r');
hold off
view(0,90);
%Add noise
pSNR=0;

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

%Point Group
%number of PG
PGnumofPC=0.005;
%number of point in PG
PnumofPG=0.01;
PGNum=fix(PnumofPG*size(P.Location,1));
Pdown = pcdownsample(P,'random',PGnumofPC);
Qdown = pcdownsample(Q,'random',PGnumofPC);

Ppc=P.Location;
Qpc=Q.Location;

Pdownpc=Pdown.Location;
Qdownpc=Qdown.Location;

PC=sepknNR(Ppc,Pdownpc,PGNum);
QC=sepknNR(Qpc,Qdownpc,PGNum);

figure('Name','point groups in point cloud')
hold on
pcshow(Q.Location(1,:),'r');
for i=1:size(PC,3)
plot3(PC(:,1,i),PC(:,2,i),PC(:,3,i),'.');
end
for i=1:size(QC,3)
plot3(QC(:,1,i),QC(:,2,i),QC(:,3,i),'.');
end
hold off
view(0,90);

%PAD feature
PAD=0;
if(PAD)
PF=fPAD( Pdownpc,PC );
QF=fPAD( Qdownpc,QC );
Fn=10;
misserror=0.1;
end
%MAP feature
MAP=1;
if(MAP)
MPRw=[1;1;1;1;1];
[ePC,PF]=fMPR( Pdownpc,PC,MPRw);
[eQC,QF]=fMPR( Qdownpc,QC,MPRw);
PF=PF*0.00001;
QF=QF*0.00001;
misserror=0.1;
Fn=5;
end
%Use K-SVD to solve miss point and noise and get Sparse feature 
SpF=0;
if(SpF)
[PF,PC2]=SpFeature( Pdownpc,PC,PGNum );
[QF,QC2]=SpFeature( Qdownpc,QC,PGNum );
Fn=121;
misserror=0.1;
end
%Match feature
disp('start match group');

[matchP,matchQ ] = sparsematchslow( PF,QF,Fn,misserror );

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
disply=0;
if(PQdis<10)%30
fa(n)=i;
% test
[cpdR1 ,cpdT1,Qrt,Qpgrt ]=Rcpd(PC(:,:,matchP(i)),QC(:,:,matchQ(i)),Ppc,Qpc,disply);
DisR(n)=sum(sum(abs(cpdR1-RO)));
DisT(n)=sum(sum(abs(cpdT1+TO')));
%Ricp(Qpgrt,PC(:,:,matchP(i)),Qrt,Ppc);
n=n+1;
end

end

% minR=min(DisR)
% minT=min(DisT)
[~,rows]=min(DisR);

disply=1;
for i=fa(rows):fa(rows)
% if(Dis(i)>0.0)
% test
[cpdR1 ,cpdT1,Qrt,Qpgrt ]=Rcpd(PC(:,:,matchP(i)),QC(:,:,matchQ(i)),Ppc,Qpc,disply);
Rerror=sum(sum(abs(cpdR1-RO)))
Terror=sum(sum(abs(cpdT1+TO')))
Ricp(Qpgrt,PC(:,:,matchP(i)),Qrt,Ppc);
end
t2=clock; 
systemcost=etime(t2,t1) 
