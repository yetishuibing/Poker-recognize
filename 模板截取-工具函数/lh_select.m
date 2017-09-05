rgbimage=imread('myimage/t_7.jpg');
grey=rgb2gray(rgbimage);
bw=edge(grey,'sobel','horizontal');%检测图像边缘直线
[m,n]=size(bw);%计算图像大小
S=round(sqrt(m^2+n^2));%S可以取到的最大值 
ma=180;%θ角最大值
md=S;
r=zeros(md,ma);%产生初值为零的计数矩阵
for i=1:m 
   for j=1:n 
     if bw(i,j)==1 
        for k=1:ma  
          ru=round(abs(i*cos(k*3.14/180)+j*sin(k*3.14/180))); 
          r(ru+1,k)=r(ru+1,k)+1;%对矩阵记数
        end 
      end 
    end 
end  
[m,n]=size(r); 
for i=1:m 
   for j=1:n 
      if r(i,j)>r(1,1) 
           r(1,1)=r(i,j);  
           c=j;%把矩阵元素最大值所对应的列坐标送给c。
      end 
   end 
end 
if c<=90  
  rot=-c; %确定旋转角度
else  
  rot=180-c; 
end  
POKER=imrotate(grey,rot,'crop'); %对图片进行旋转，矫正图像
subplot(1,1,1),imshow(POKER),title('扑克纸牌');
    k = waitforbuttonpress;              % 等待鼠标按下
    point1 = get(gca,'CurrentPoint');    % 鼠标按下了
    finalRect = rbbox;                   %
    point2 = get(gca,'CurrentPoint');    % 鼠标松开了
    point1 = point1(1,1:2); % 提取出两个点
    point2 = point2(1,1:2);
    p1 = min(floor(point1),floor(point2));             % 计算位置
    p2 = max(floor(point1),floor(point2));
    offset = abs(floor(point1)-floor(point2)); % offset(1)表示宽，offset(2)表示高
    GRAY=POKER(p1(2):(p1(2)+offset(2)),p1(1):(p1(1)+offset(1)));
    bw=im2bw(GRAY,ostu(GRAY)); 
    BW=logical(abs(double(bw)-1)); 
    %subplot(1,1,1),imshow(BW),title('图像二值化');
    [m,n]=size(GRAY); 
    pokerstr=GRAY(1:m/2,1:n/5.5);%字符粗略定位 
    bw=im2bw(pokerstr,ostu(pokerstr)); 
    bw1=bwmorph(bw,'clean');%清除孤立点 
    bw2=logical(abs(double(bw1)-1));%二值图像反色 
    bw3=reduce(bw2);%清除连续不跳变边缘影响,自定义函数reduce 
    [m,n]=size(bw3); 
    temp=sum(bw3);shadow(2:n+1)=temp;shadow(1)=0;shadow(n+2)=0; 
    for i=2:n+1 
        if shadow(i)~=0&&shadow(i-1)==0&&shadow(i+1)==0%出现孤立线条 
            for j=1:m 
                bw3(j,i-1)=0;%删除孤立线条列 
            end 
        end 
    end 
    [m,n]=find(bw3); 
    BWSTR=bw3(min(m):max(m),min(n):max(n)); 
    subplot(1,1,1),imshow(BWSTR),title('纸牌特征字符'); 
        sym=bwmorph(BWSTR,'clean');%清除孤立点 
        sym=imresize(sym,[58 22]);%模板归一化 
        shadow=(sum(sym,2))';%侧面投影 