function [ eC,bijiao ] = fMPR( FD,C,A )

bijiaonum=5;
pnum=size(FD,1);
bijiao=zeros(pnum,bijiaonum);
eC=zeros(bijiaonum,3,pnum);
for i=1:pnum

T=C{i};
GMModel =fitgmdist(T,1);
F=pdf(GMModel,T);
[GMModel1,F1,X1]=gmpr(F,T);
[GMModel2,F2,X2]=gmpr(F1,X1);
[GMModel3,F3,X3]=gmpr(F2,X2);
%size(X3,1)
if (size(X3,1)<28)
    GMModel4=GMModel3;
    F4=F3;
else
[GMModel4,F4,~] =gmpr(F3,X3);
end
%[GMModel5,F5,X5]=gmmnum1(F4,X4);
egmm=[GMModel.mu;GMModel1.mu;GMModel2.mu;GMModel3.mu;GMModel4.mu];
eC(:,:,i)=egmm;

bijiao(i,:)=[mean(F);mean(F1);mean(F2);mean(F3);mean(F4)].*A;

end

end

