close all
j=14
for i=j:j
% if(Dis(i)>0.0)
% test
[cpdR1 ,cpdT1,Pr60_12,Qpgrt ]=Rcpd(PC(:,:,matchP(fa(i))),QC(:,:,matchQ(fa(i))),Ppc,Qpc,dis);
% Ricp(Qpgrt,PC(:,:,matchP(i)),Qrt,Ppc);
end
save('Pr60_12.mat','Pr60_12');

figure
pcshow(P90{1}.Location)
hold on
for i=1:12
    plot3(P90{i}.Location(:,1),P90{i}.Location(:,2),P90{i}.Location(:,3),'.');
    hold on
    plot3(P60{i}.Location(:,1),P60{i}.Location(:,2),P60{i}.Location(:,3),'.');
    plot3(P120{i}.Location(:,1),P120{i}.Location(:,2),P120{i}.Location(:,3),'.');
end
