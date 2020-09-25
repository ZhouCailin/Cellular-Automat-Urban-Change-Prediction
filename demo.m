clc;
clear all;
close all;

%% 自定义部分
% 已预先将img格式转成tif格式
% nodata参数需要看情况设置，一般为-9999
file01='H:\上课视频\城市GIS\Data2001_2005\20011.tif'; %2001年路径
file05='H:\上课视频\城市GIS\Data2001_2005\20051.tif'; %2005年路径
filepg='H:\上课视频\城市GIS\Data2001_2005\pg22.tif';  %pg路径
op='C:\Users\周财霖\Desktop\大三下作业\UGIS\fig\';%结果输出路径（不含文件名，加'/'）
nodata=-128;

%% tif影像读取，如非tif格式需要修改读取函数
[raw01,ref]=geotiffread(file01); 
[raw05,ref1]=geotiffread(file05); 
[pg,ref2]=geotiffread(filepg); 
info=geotiffinfo(file01);

%% 调整index——城镇->1,非城镇->0
nrows = size(raw01,1); 
ncols = size(raw01,2); 
testdata=raw05;
initdata=raw01;
initdata(raw01~=1 & raw01~=nodata)=0;  
testdata(raw05~=1 & raw05~=nodata)=0; 

%% 限制开发
unsuitable=raw01;
unsuitable(raw01~=3|raw01~=-128)=0; %非水体->0
unsuitable(raw01==3)=1; %水体->1

%% CA模拟

data=initdata;
prod=zeros(1,10);user=zeros(1,10);OA=zeros(1,10);kappa=zeros(1,10);fom=zeros(1,10);

for k=1:10
    data=CAsimulate(data,pg,unsuitable,0.45,1,-128);% 函数参数：2001年分类图，pg图，unsuit图，P阈值，
    [ prod(1,k),user(1,k),OA(1,k),kappa(1,k),fom(1,k)]=CAassess(data,testdata);% 函数参数：模拟结果图，2005年分类图
    oppath=[op,num2str(k),'.tif'];
    %geotiffwrite(oppath,data,ref2,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);%写出影像
   
    %即刻可视化
    colordata=data;
    colordata(data==nodata)=0; 
    colordata(data==0)=3; 
    colordata(data==1)=2; 
    colordata(raw01==3)=4; 
    im_rgb=label2rgb(colordata, 'jet', 'w', 'shuffle');
    figure;imshow(im_rgb);
    
end



