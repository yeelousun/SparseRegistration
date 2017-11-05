function [ model,F1,A ] = gmpr( F,X )

j=1;
A=zeros(1,3);
for i=1:size(F)
if(F(i)<mean(F)*1.0)
    A(j,:)=X(i,:);
    j=j+1;
end
end

GMModel1 =fitgmdist(A,1);

F1=pdf(GMModel1,A);
model=GMModel1;

end

