function [ matchA,matchB ] = sparsematchslow( bijiao1,bijiao2,dicn,misserror )

A=bijiao1;
B=bijiao2;
Bnum=size(B,1);
NormA=norm(A);
% generate DCT-spike dictionary %

Dic = zeros(dicn);

for i = 1:size(A,1)
  v = A(i,:)';
  Dic(:,i) = v/norm(v);
end

%Dic = [Dic eye(size(A,2))];

if 0
figure
for i=1:size(Dic,2)
    plot(Dic(:,i))
    hold on
end
end

matchA=zeros(1,1);
matchB=zeros(1,1);
matchnum=1;
for i =1:Bnum
  
    gammaB = omp(Dic, B(i,:)',[],4)';
    %gammaB = omp(Dic'*B(i,:)',Dic'*Dic,4);
    %gammaB=gammaB';
    err =    B(i,:)'- Dic*gammaB';
    
    if(sum(abs(err))>0&&sum(abs(err))<misserror)
        %figure
        %plot(B(i,:)')
        %hold on
        %plot(Dic*gammaB')
        %hold off
        %figure
        %plot(gammaB')
        %gammaB
        [~,my_rows] = max(gammaB);
        fprintf('test:');
        my_rows
        i
        if(sum(abs(bijiao1(my_rows,:)-bijiao2(i,:)))>10)
           continue;
        end
        fprintf('--------------\n');
        fprintf('P:');
        matchA(matchnum)=my_rows
        fprintf('Q:');
        matchB(matchnum)=i
        fprintf('sum:');
           err
    matchnum=matchnum+1;
    end
    if(matchnum>200)
        break
    end
end

end

