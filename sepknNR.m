function  [C] = sepknNR(F,FD,K)

pnum=size(FD,1);
idx=knnsearch(F,FD,'Distance',K);
C=cell(1,pnum);
for i=1:pnum
C{i}=F(idx(i,:),:);
end
end