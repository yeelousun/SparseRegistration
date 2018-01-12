clear all;close all;clc;
% %number of PG
% PGnumofPC=0.01;%m
% 
% %radius of PG //precent of point cloud
% PGRper=0.01;%n
% for i=1:1
%     [a(i),b(i)]=parametertest(PGnumofPC,PGRper);
% end


res=zeros(6,7);
time=zeros(6,7);
n1=1;
for n=0.0005:0.0005:0.003
    m1=1;    
    for m=0.004:0.001:0.01
        
        a=zeros(1,10);
        b=zeros(1,10);
         for i=1:10
             [a(i),b(i)]=parametertest(m,n);
             m
             n
         end
             res(n1,m1)=  sum(a(:)==4);
             time(n1,m1)= max(b);
             m1=m1+1;
    end
    n1=n1+1;
end
% 
% savefile='resout';
% save(savefile,'res','time');