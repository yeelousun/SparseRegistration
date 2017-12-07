clc;close all;clear all;
%Load point cloud
%measured point cloud
load('./roomdata/roomD.mat'); 
pMeasure=1;
if(pMeasure)
P =P90{12}; 
Q =P60{12};% will add R and T
load('testR');

figure('Name','point cloud P and Q')
 pcshow(P);
 hold on
 pcshow(Q);
 hold off
end
%Point Group

PGNum=600;%150
Pdown = pcdownsample(P,'random',0.5);
Qdown = pcdownsample(Q,'random',0.5);%0.01

Ppc=P.Location;
Qpc=Q.Location;

Pdownpc=Pdown.Location;
Qdownpc=Qdown.Location;

PC=sepknn(Ppc,Pdownpc,PGNum);
QC=sepknn(Qpc,Qdownpc,PGNum);



%PAD feature
PAD=1;
if(PAD)
[PF,PC]=fPAD( Pdownpc,PC );
[QF,QC]=fPAD( Qdownpc,QC );
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
SpF=0;
if(SpF)
[PF,PC2]=SpFeature( Pdownpc,PC,PGNum );
[QF,QC2]=SpFeature( Qdownpc,QC,PGNum );
Fn=121;
end
%Match feature
disp('start match group');
misserror=0.1;
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
dis=0;
if(PQdis<30)%30
fa(n)=i;

% test
[cpdR1 ,cpdT1,Qrt,Qpgrt ]=Rcpd(PC(:,:,matchP(i)),QC(:,:,matchQ(i)),Ppc,Qpc,dis);
DisR(n)=sum(sum(abs(cpdR1-Ro)));
%Ricp(Qpgrt,PC(:,:,matchP(i)),Qrt,Ppc);
n=n+1;
end

end

dis=1;
for i=1:size(fa,2)
% if(Dis(i)>0.0)
% test
[cpdR1 ,cpdT1,Qrt,Qpgrt ]=Rcpd(PC(:,:,matchP(fa(i))),QC(:,:,matchQ(fa(i))),Ppc,Qpc,dis);
% Ricp(Qpgrt,PC(:,:,matchP(i)),Qrt,Ppc);
end

% minr=max(DisR)
% [~,rows]=max(DisR);
% for i=fa(rows):fa(rows)
% % if(Dis(i)>0.0)
% % test
% [cpdR1 ,cpdT1,Qrt,Qpgrt ]=Rcpd(PC(:,:,matchP(i)),QC(:,:,matchQ(i)),Ppc,Qpc,dis);
% %Ricp(Qpgrt,PC(:,:,matchP(i)),Qrt,Ppc);
% end

