function [ tempdata ] = CAsimulate( data,pg,unsuitable,pthreshold,urban_index,nodata)
%CAsimulate CA模拟

% data:初始地物分类
% pg:pg影像
% usuitable:限制开发，1水体，0非水体
% pthreshold: p阈值
% urban_index:初始地物分类中城镇代码
% nodata:初始地物分类中NoData像元代码

nrows = size(data,1); %行数
ncols = size(data,2); %列数 
tempdata=NaN(nrows,ncols);

for i=1:nrows
    for j=1:ncols
        if data(i,j)==urban_index || data(i,j)==nodata %城镇和NoData区域不考虑为元胞
            tempdata(i,j)=data(i,j);
        else         
            % 八领域计算影响因子
            count=0; 
            %左列：防超左界
            tempi=i-1;
            if tempi>0 
                tempj=j-1;
                %左上：防超上界
                if tempj>0
                    if data(tempi,tempj)==urban_index
                        count=count+1;
                    end
                end
                %左中
                tempj=j;
                if data(tempi,tempj)==urban_index
                    count=count+1;
                end
                %左下
                tempj=j+1;
                if tempj<=ncols
                    if data(tempi,tempj)==urban_index 
                        count=count+1;
                    end
                end
            end
            
            %中列
            tempi=i;
            %中上
            tempj=j-1;
            if tempj>0
                if data(tempi,tempj)==urban_index
                    count=count+1;
                end
            end
            %中下
            tempj=j+1;
            if tempj<=ncols
                if data(tempi,tempj)==urban_index 
                    count=count+1;
                end
            end
            
            %右列：防超右界
            tempi=i+1;
            if tempi<=nrows
                tempj=j-1;
                %右上：防超上界
                if tempj>0
                    if data(tempi,tempj)==urban_index
                        count=count+1;
                    end
                end
                %右中
                tempj=j;
                if data(tempi,tempj)==urban_index 
                    count=count+1;
                end
                %右下
                tempj=j+1;
                if tempj<=ncols
                    if data(tempi,tempj)==urban_index 
                        count=count+1;
                    end
                end
            end
            con=count/8.0;
           
            % 随机影响因子
            rdm=rand()+0.00001;
            if rdm>1
                rdm=rdm-0.00001;
            end
            alfa=8; %alfa为[1,10]整数
            rdmData=1+power(-log(rdm),alfa);
            
            % 限制开发
            if unsuitable(i,j)~=1 
                suit=1;
            else
                suit=0;
            end
            
            % 发展概率
            pgval=pg(i,j);
            
            % 开发概率
            p=pgval*con*suit*rdmData;
            
            %元胞是否开发为城市
            if p>pthreshold
                tempdata(i,j)=urban_index;
            else
                tempdata(i,j)=data(i,j);
            end
        end
    end
end


end

