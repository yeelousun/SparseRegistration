function  [C] = sepknn(F,FD,K)

pnum=size(FD,1);
idx=knnsearch(F,FD,'k',K);
C=zeros(K,3,pnum);

for i=1:pnum
C(:,:,i)=F(idx(i,:),:);
end
end