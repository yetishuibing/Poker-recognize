rgbimage=imread('myimage/t_7.jpg');
grey=rgb2gray(rgbimage);
bw=edge(grey,'sobel','horizontal');%���ͼ���Եֱ��
[m,n]=size(bw);%����ͼ���С
S=round(sqrt(m^2+n^2));%S����ȡ�������ֵ 
ma=180;%�Ƚ����ֵ
md=S;
r=zeros(md,ma);%������ֵΪ��ļ�������
for i=1:m 
   for j=1:n 
     if bw(i,j)==1 
        for k=1:ma  
          ru=round(abs(i*cos(k*3.14/180)+j*sin(k*3.14/180))); 
          r(ru+1,k)=r(ru+1,k)+1;%�Ծ������
        end 
      end 
    end 
end  
[m,n]=size(r); 
for i=1:m 
   for j=1:n 
      if r(i,j)>r(1,1) 
           r(1,1)=r(i,j);  
           c=j;%�Ѿ���Ԫ�����ֵ����Ӧ���������͸�c��
      end 
   end 
end 
if c<=90  
  rot=-c; %ȷ����ת�Ƕ�
else  
  rot=180-c; 
end  
POKER=imrotate(grey,rot,'crop'); %��ͼƬ������ת������ͼ��
subplot(1,1,1),imshow(POKER),title('�˿�ֽ��');
    k = waitforbuttonpress;              % �ȴ���갴��
    point1 = get(gca,'CurrentPoint');    % ��갴����
    finalRect = rbbox;                   %
    point2 = get(gca,'CurrentPoint');    % ����ɿ���
    point1 = point1(1,1:2); % ��ȡ��������
    point2 = point2(1,1:2);
    p1 = min(floor(point1),floor(point2));             % ����λ��
    p2 = max(floor(point1),floor(point2));
    offset = abs(floor(point1)-floor(point2)); % offset(1)��ʾ��offset(2)��ʾ��
    GRAY=POKER(p1(2):(p1(2)+offset(2)),p1(1):(p1(1)+offset(1)));
    bw=im2bw(GRAY,ostu(GRAY)); 
    BW=logical(abs(double(bw)-1)); 
    %subplot(1,1,1),imshow(BW),title('ͼ���ֵ��');
    [m,n]=size(GRAY); 
    pokerstr=GRAY(1:m/2,1:n/5.5);%�ַ����Զ�λ 
    bw=im2bw(pokerstr,ostu(pokerstr)); 
    bw1=bwmorph(bw,'clean');%��������� 
    bw2=logical(abs(double(bw1)-1));%��ֵͼ��ɫ 
    bw3=reduce(bw2);%��������������ԵӰ��,�Զ��庯��reduce 
    [m,n]=size(bw3); 
    temp=sum(bw3);shadow(2:n+1)=temp;shadow(1)=0;shadow(n+2)=0; 
    for i=2:n+1 
        if shadow(i)~=0&&shadow(i-1)==0&&shadow(i+1)==0%���ֹ������� 
            for j=1:m 
                bw3(j,i-1)=0;%ɾ������������ 
            end 
        end 
    end 
    [m,n]=find(bw3); 
    BWSTR=bw3(min(m):max(m),min(n):max(n)); 
    subplot(1,1,1),imshow(BWSTR),title('ֽ�������ַ�'); 
        sym=bwmorph(BWSTR,'clean');%��������� 
        sym=imresize(sym,[58 22]);%ģ���һ�� 
        shadow=(sum(sym,2))';%����ͶӰ 