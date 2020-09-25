clc;
clear all;
close all;

%% �Զ��岿��
% ��Ԥ�Ƚ�img��ʽת��tif��ʽ
% nodata������Ҫ��������ã�һ��Ϊ-9999
file01='H:\�Ͽ���Ƶ\����GIS\Data2001_2005\20011.tif'; %2001��·��
file05='H:\�Ͽ���Ƶ\����GIS\Data2001_2005\20051.tif'; %2005��·��
filepg='H:\�Ͽ���Ƶ\����GIS\Data2001_2005\pg22.tif';  %pg·��
op='C:\Users\�ܲ���\Desktop\��������ҵ\UGIS\fig\';%������·���������ļ�������'/'��
nodata=-128;

%% tifӰ���ȡ�����tif��ʽ��Ҫ�޸Ķ�ȡ����
[raw01,ref]=geotiffread(file01); 
[raw05,ref1]=geotiffread(file05); 
[pg,ref2]=geotiffread(filepg); 
info=geotiffinfo(file01);

%% ����index��������->1,�ǳ���->0
nrows = size(raw01,1); 
ncols = size(raw01,2); 
testdata=raw05;
initdata=raw01;
initdata(raw01~=1 & raw01~=nodata)=0;  
testdata(raw05~=1 & raw05~=nodata)=0; 

%% ���ƿ���
unsuitable=raw01;
unsuitable(raw01~=3|raw01~=-128)=0; %��ˮ��->0
unsuitable(raw01==3)=1; %ˮ��->1

%% CAģ��

data=initdata;
prod=zeros(1,10);user=zeros(1,10);OA=zeros(1,10);kappa=zeros(1,10);fom=zeros(1,10);

for k=1:10
    data=CAsimulate(data,pg,unsuitable,0.45,1,-128);% ����������2001�����ͼ��pgͼ��unsuitͼ��P��ֵ��
    [ prod(1,k),user(1,k),OA(1,k),kappa(1,k),fom(1,k)]=CAassess(data,testdata);% ����������ģ����ͼ��2005�����ͼ
    oppath=[op,num2str(k),'.tif'];
    %geotiffwrite(oppath,data,ref2,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);%д��Ӱ��
   
    %���̿��ӻ�
    colordata=data;
    colordata(data==nodata)=0; 
    colordata(data==0)=3; 
    colordata(data==1)=2; 
    colordata(raw01==3)=4; 
    im_rgb=label2rgb(colordata, 'jet', 'w', 'shuffle');
    figure;imshow(im_rgb);
    
end



