clear all;close all;clc;
%number of PG
% PGnumofPC=0.012;%m
% 
% %radius of PG //precent of point cloud
% PGRper=0.02;%n
% for i=1:10
%     [a(i),b(i)]=parametertest(PGnumofPC,PGRper);
% end


res=zeros(8,10);
time=zeros(8,10);
n1=1;
for n=0.006:0.002:0.02
    m1=1;    
    for m=0.002:0.002:0.02
        
        a=zeros(1,10);
        b=zeros(1,10);
         for i=1:10
             [a(i),b(i)]=parametertest(m,n);
         end
             res(n1,m1)=  sum(a(:)==4);
             time(n1,m1)= max(b);
             m1=m1+1;
    end
    n1=n1+1;
end