function  [C,sumpgsize] = sepknNR(F,FD,K)
pnum=size(FD,1);
idx=rangesearch(F,FD,K);
C=cell(1,pnum);
sumpgsize=zeros(1,pnum);
idxr=rangesearch(F,FD,K);
for i=1:pnum
sumpgsize(i)=size(idxr{i},2);
C{i}=F(idx{i},:);
end

end
