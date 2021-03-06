function [ res,systemcost ] = parametertest(PGnumofPC,PGRper)
close all;%clear all;
systemcost=0;

%res=1 cannot find feature
%res=2 no match
%res=3 bad registration
%res=4 good res

res=0;
%Load point cloud
t1=clock;
pCloud = pcread('bun000.ply'); 

% figure('Name','all point cloud')
% pcshow(pCloud);
%Initialization (Separation Rotation and Translation) 

[P,Q,RO,TO]=pcInitialization(pCloud);

% figure('Name','point cloud P and Q')
% pcshow(P.Location,'b');
% hold on
% pcshow(Q.Location,'r');
% hold off
% view(0,90);
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

% figure('Name','point cloud P_Noise_Out and Q_Noise_Out')
% pcshow(P);
% hold on
% pcshow(Q);
% hold off

%Point Group
% %number of PG
% PGnumofPC=0.008;
% 
% %radius of PG //precent of point cloud
% PGRper=0.012;

%Threshold of point in PG//precent of max number of PG
PGNumT=1;%0.8


Pdown = pcdownsample(P,'random',PGnumofPC);
Qdown = pcdownsample(Q,'random',PGnumofPC);

Ppc=P.Location;
Qpc=Q.Location;

Pdownpc=Pdown.Location;
Qdownpc=Qdown.Location;
%radius of computeRadiusPG
PGRtest=0.01;
%radius of PG 
PGR=computeRadius(Ppc,Pdownpc,PGRtest,PGRper);
[PC,Ppgnum]=sepknNR(Ppc,Pdownpc,PGR);
[QC,Qpgnum]=sepknNR(Qpc,Qdownpc,PGR);
Tedge=linspace(min(Ppgnum),max(Ppgnum),10);

[Pdownpc,PC]=FindEdge(Pdownpc,PC,Ppgnum,Tedge(1),PGNumT*Tedge(10));%5~8
[Qdownpc,QC]=FindEdge(Qdownpc,QC,Qpgnum,Tedge(1),PGNumT*Tedge(10));

% figure('Name','point groups in point cloud')
% hold on
% pcshow(P.Location,'b');
% pcshow(Q.Location,'r');
% for i=1:size(PC,2)
% plot3(PC{i}(:,1),PC{i}(:,2),PC{i}(:,3),'.');
% end
% for i=1:size(QC,2)
% plot3(QC{i}(:,1),QC{i}(:,2),QC{i}(:,3),'.');
% end
% hold off
% view(0,90);

try
%PAD feature
PAD=0;
if(PAD)
PF=fPAD( Pdownpc,PC );
QF=fPAD( Qdownpc,QC );
Fn=10;
misserror=0.1;
end
%MAP feature
MAP=0;
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
SpF=1;
if(SpF)
[PF,PC2]=SpFeature( Pdownpc,PC );
[QF,QC2]=SpFeature( Qdownpc,QC );
Fn=121;
misserror=0.1;
end


%Match feature
disp('start match group');

[matchP,matchQ ] = sparsematchslow( PF,QF,Fn,misserror );
catch
res=1;
return
end

try
figure('Name','point cloud P_Noise_Out and PG matched')
plot3(Ppc(:,1),Ppc(:,2),Ppc(:,3),'.');
hold on
for i=1:size(matchP,2)
plot3(PC{matchP(i)}(:,1),PC{matchP(i)}(:,2),PC{matchP(i)}(:,3),'o');
end
hold off

figure('Name','point cloud Q_Noise_Out and PG matched')
plot3(Qpc(:,1),Qpc(:,2),Qpc(:,3),'.');
hold on
for i=1:size(matchQ,2)
plot3(QC{matchQ(i)}(:,1),QC{matchQ(i)}(:,2),QC{matchQ(i)}(:,3),'o');
end
hold off
catch
    res=2;
    return
end
%Register point cloud

%close all
n=1;

fa=zeros(1,1);
DisR=zeros(1,1);
DisT=zeros(1,1);
for i=1:size(matchQ,2)
% if(Dis(i)>0.0)
%PQdis=Rcpddis(PC{matchP(i)},QC{matchQ(i)});
disply=0;
%if(PQdis<10)%30
fa(n)=i;
% test
[cpdR1 ,cpdT1,Qrt,Qpgrt ]=Rcpd(PC{matchP(i)},QC{matchQ(i)},Ppc,Qpc,disply);
DisR(n)=sum(sum(abs(cpdR1-RO)));
DisT(n)=sum(sum(abs(cpdT1+TO')));
%Ricp(Qpgrt,PC(:,:,matchP(i)),Qrt,Ppc);
n=n+1;
%end

end

% minR=min(DisR)
% minT=min(DisT)
[~,rows]=min(DisR);

disply=1;
if(fa(rows)==0)
    res=2;
    return
end
for i=fa(rows):fa(rows)
% if(Dis(i)>0.0)
% test
[cpdR1 ,cpdT1,Qrt,Qpgrt ]=Rcpd(PC{matchP(i)},QC{matchQ(i)},Ppc,Qpc,disply);
Rerror=sum(sum(abs(cpdR1-RO)))
Terror=sum(sum(abs(cpdT1+TO')))
Ricp(Qpgrt,PC{matchP(i)},Qrt,Ppc);
end
if (Rerror>0.4)
    res=3;
    return
end
res=4;
t2=clock; 
systemcost=etime(t2,t1) ;


end