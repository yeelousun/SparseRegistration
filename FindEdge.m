function [ FD,C ] = FindEdge( FD,C,Ppgnum,t1,t2)
id=(Ppgnum(1,:)>t2 | Ppgnum(1,:)<t1);
FD(id,:)=[];
C(id)=[];
end