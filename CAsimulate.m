function [ tempdata ] = CAsimulate( data,pg,unsuitable,pthreshold,urban_index,nodata)
%CAsimulate CAģ��

% data:��ʼ�������
% pg:pgӰ��
% usuitable:���ƿ�����1ˮ�壬0��ˮ��
% pthreshold: p��ֵ
% urban_index:��ʼ��������г������
% nodata:��ʼ���������NoData��Ԫ����

nrows = size(data,1); %����
ncols = size(data,2); %���� 
tempdata=NaN(nrows,ncols);

for i=1:nrows
    for j=1:ncols
        if data(i,j)==urban_index || data(i,j)==nodata %�����NoData���򲻿���ΪԪ��
            tempdata(i,j)=data(i,j);
        else         
            % ���������Ӱ������
            count=0; 
            %���У��������
            tempi=i-1;
            if tempi>0 
                tempj=j-1;
                %���ϣ������Ͻ�
                if tempj>0
                    if data(tempi,tempj)==urban_index
                        count=count+1;
                    end
                end
                %����
                tempj=j;
                if data(tempi,tempj)==urban_index
                    count=count+1;
                end
                %����
                tempj=j+1;
                if tempj<=ncols
                    if data(tempi,tempj)==urban_index 
                        count=count+1;
                    end
                end
            end
            
            %����
            tempi=i;
            %����
            tempj=j-1;
            if tempj>0
                if data(tempi,tempj)==urban_index
                    count=count+1;
                end
            end
            %����
            tempj=j+1;
            if tempj<=ncols
                if data(tempi,tempj)==urban_index 
                    count=count+1;
                end
            end
            
            %���У������ҽ�
            tempi=i+1;
            if tempi<=nrows
                tempj=j-1;
                %���ϣ������Ͻ�
                if tempj>0
                    if data(tempi,tempj)==urban_index
                        count=count+1;
                    end
                end
                %����
                tempj=j;
                if data(tempi,tempj)==urban_index 
                    count=count+1;
                end
                %����
                tempj=j+1;
                if tempj<=ncols
                    if data(tempi,tempj)==urban_index 
                        count=count+1;
                    end
                end
            end
            con=count/8.0;
           
            % ���Ӱ������
            rdm=rand()+0.00001;
            if rdm>1
                rdm=rdm-0.00001;
            end
            alfa=8; %alfaΪ[1,10]����
            rdmData=1+power(-log(rdm),alfa);
            
            % ���ƿ���
            if unsuitable(i,j)~=1 
                suit=1;
            else
                suit=0;
            end
            
            % ��չ����
            pgval=pg(i,j);
            
            % ��������
            p=pgval*con*suit*rdmData;
            
            %Ԫ���Ƿ񿪷�Ϊ����
            if p>pthreshold
                tempdata(i,j)=urban_index;
            else
                tempdata(i,j)=data(i,j);
            end
        end
    end
end


end

