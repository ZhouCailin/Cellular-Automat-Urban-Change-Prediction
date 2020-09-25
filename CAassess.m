function [ prod,user,OA,kappa,fom,fusion ] = CAassess( data,testdata )
%CAassess CA精度评价
%   此处显示详细说明

fusion=zeros(6,6);
fusion(1,1)=sum(data(testdata==1)==1);
fusion(1,2)=sum(data(testdata==1)==0);
fusion(2,1)=sum(data(testdata==0)==1);
fusion(2,2)=sum(data(testdata==0)==0);

S=sum(sum(fusion));
OA=(fusion(1,1)+fusion(2,2))/S;

fusion(1,3)=sum(fusion(1,:));
fusion(2,3)=sum(fusion(2,:));
fusion(3,1)=sum(fusion(:,1));
fusion(3,2)=sum(fusion(:,2));

prod=fusion(1,1)/fusion(1,3);
user=fusion(1,1)/fusion(3,1);

pc=(fusion(1,3)*fusion(3,1)+fusion(2,3)*fusion(3,2))/(S*S);
kappa=(OA-pc)/(1-pc);

fom=fusion(1,1)/(S-fusion(1,1));

end

