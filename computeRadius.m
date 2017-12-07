%compute R of point group at 1% of pint cloud
function  [r] = computeRadius(F,FD,K,per)
pnum=size(FD,1);
idx=rangesearch(F,FD,K);
sumpgsize=zeros(1,pnum);
for i=1:pnum
sumpgsize(i)=size(idx{i},2);
end
Mpi=max(sumpgsize)/(K^2);
r=sqrt(per*size(F,1)/Mpi);
end