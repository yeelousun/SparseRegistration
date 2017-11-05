Ppcg=PC2(:,:,1);
Qpcg=QC2(:,:,1);

for i=2:size(PC2,3)
Ppcg=[PC2(:,:,i);Ppcg];
end
Pg=pointCloud(Ppcg);
Pgd=pcdownsample(Pg,'nonuniformGridSample',7);

for i=2:size(QC2,3)
Qpcg=[QC2(:,:,i);Qpcg];
end
Qg=pointCloud(Qpcg);
Qgd=pcdownsample(Qg,'nonuniformGridSample',7);

figure('Name','point cloud de P and Q')
pcshow(Pgd);
hold on
pcshow(Qgd);
hold off
i=5;
[cpdR1 ,cpdT1,Qrt ]=Rcpd(PC(:,:,matchP(i)),QC(:,:,matchQ(i)),Ppc,Qpc);
[cpdR1 ,cpdT1,Qrt ]=Rcpd(PC2(:,:,matchP(i)),QC2(:,:,matchQ(i)),Pgd.Location,Qgd.Location);