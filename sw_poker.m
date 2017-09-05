function varargout = sw_poker(varargin)
% SW_POKER MATLAB code for sw_poker.fig
%      SW_POKER, by itself, creates a new SW_POKER or raises the existing
%      singleton*.
%
%      H = SW_POKER returns the handle to a new SW_POKER or the handle to
%      the existing singleton*.
%
%      SW_POKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SW_POKER.M with the given input arguments.
%
%      SW_POKER('Property','Value',...) creates a new SW_POKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sw_poker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sw_poker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sw_poker

% Last Modified by GUIDE v2.5 11-Dec-2016 17:17:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sw_poker_OpeningFcn, ...
                   'gui_OutputFcn',  @sw_poker_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before sw_poker is made visible.
function sw_poker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sw_poker (see VARARGIN)

% Choose default command line output for sw_poker
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sw_poker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sw_poker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IMAGE; 
global POKER; 
global GRAY; 
global BW; 
global BWSTR; 
 
name=0;
[name,path]=uigetfile({'*.bmp';'*.jpg';'*,tif'},'image\'); 
if name==0; 
    return;%û�д�ͼ�� 
end 
 
IMAGE=imread(strcat(path,name));%�ɹ���ͼ�� 
POKER=0;GRAY=0;BW=0;BWSTR=0;%����ͼ��λ 
 
subplot(1,1,1),imshow(IMAGE),title('�˿�ֽ��ͼ��');


% --------------------------------------------------------------------
function operate_Callback(hObject, eventdata, handles)
% hObject    handle to operate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function rectify_Callback(hObject, eventdata, handles)
% hObject    handle to rectify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IMAGE; 
global POKER; 
global GRAY;
if IMAGE==0;%δ��ͼ�� 
    msgbox('���ȴ�һ���˿�ͼ��','����','error'); 
    else 
    tic;%����У���붨λ��ʱ 
    POKER=rectify(IMAGE); 
    
    subplot(1,1,1),imshow(POKER),title('��ת��λ');
end


function poker=rectify(rgbimage) 
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
          ru=round(abs(i*cos(k*3.14/180)+j*sin(k*3.14/180))); %ȷ����¼�ۼ�����ֵ�ľ�����к�
          r(ru+1,k)=r(ru+1,k)+1;%�Ծ���������Ծ�����i��j��λ�õ����ص㲢��ˮƽ����н�Ϊk�ķ����ϵ����ؽ����ۼӣ�
        end 
      end 
    end 
end  
[m,n]=size(r); 
for i=1:m 
   for j=1:n 
      if r(i,j)>r(1,1) 
           r(1,1)=r(i,j);  
           c=j;%�Ѿ���Ԫ�����ֵ����Ӧ���������͸�c�������꼴Ϊ�ֱ����ˮƽ����ļнǡ�
      end 
   end 
end 
if c<=90  
  rot=-c; %ȷ����ת�Ƕȣ�c<90ʱ˳ʱ����תc��
else  
  rot=180-c; %c>90ʱ��ʱ����ת180-c��
end 
%------------------------------------------
bw=imrotate(bw,rot,'');
[m,n]=find(bw);
bw1=bw(min(m):max(m),min(n):max(n));
[m,n]=size(bw1);
if m<n%����˿�����ת֮����ˮƽ���õģ����˿�����ʱ����ת90��������ֱ����
    rot=rot+90;
end
%------------------------------------------------
poker=imrotate(rgbimage,rot,'crop'); %��ͼƬ������ת������ͼ��

% --------------------------------------------------------------------
function get_Callback(hObject, eventdata, handles)
% hObject    handle to get (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IMAGE; 
global POKER; 
global GRAY;

h=imrect;

%----------------------------------------
%ͼ�оͻ���ֿ����϶��Լ��ı��С�ľ��ο�ѡ��λ�ú�
%---------------------------------------- 
pos=getPosition(h);

%---------------------------------------- 
%pos���ĸ�ֵ���ֱ��Ǿ��ο�����½ǵ������ x y �� ��� ��Ⱥ͸߶�
%---------------------------------------- 

%---------------------------------------- 
%����ѡȡͼƬ
%---------------------------------------- 
POKER= imcrop(POKER, pos );
  subplot(1,1,1),imshow(POKER,[]),title('ֽ�ƽ�ȡͼ');








% --------------------------------------------------------------------
function grayy_Callback(hObject, eventdata, handles)
% hObject    handle to grayy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global IMAGE; 
global POKER; 
global GRAY; 
 
if IMAGE==0%δ��ͼ�� 
    msgbox('���ȴ�һ���˿�ͼ��','����','error'); 
elseif POKER==0%δ����ͼ��У�� 
    msgbox('���ȶ�ͼ�����У����λ','����','error'); 
else 
    GRAY=rgb2gray(POKER); 
    subplot(1,1,1),imshow(GRAY),title('ֽ�ƻҶȻ�'); 
end

% --------------------------------------------------------------------
function binary_Callback(hObject, eventdata, handles)
% hObject    handle to binary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IMAGE;										%ȫ�ֱ���
global POKER;
global GRAY;
global BW;

if IMAGE==0											%δ��ͼ��
    msgbox('���ȴ�һ���˿�ͼ��','����','error');
elseif POKER==0										%δ����ͼ��У��
    msgbox('���ȶ�ͼ�����У����λ','����','error');
elseif GRAY==0										%δ����ͼ��ҶȻ�
    msgbox('���ȶ�ͼ����лҶȻ�','����','error');
else
    bw=im2bw(GRAY,ostu(GRAY));						%�Զ��庯��ostu()%�����䷽�ostu()
    BW=logical(abs(double(bw)-1));%ȡ��ɫ
    subplot(1,1,1),imshow(BW),title('ֽ�ƶ�ֵ��');
end

%-----------------------------------------------------------------------
function level=ostu(IMAGE) 
%�����䷽��ostu�㷨,�������ֵ 

%fmax1=double(max(max(IMAGE)));%egray�����ֵ�����˫������
%fmin1=double(min(min(IMAGE)));%egray����Сֵ�����˫������
%level=(fmax1-(fmax1-fmin1)/3)/255;%��������ֵ

I=im2uint8(IMAGE(:));%��ͼƬ����ֵת����8λ���ͣ���0��255֮�䣩
depth=256;
counts=imhist(I,depth);%��¼I��256���Ҷȼ����ֵĴ���
w=cumsum(counts);%A=[1:5];B=cumsum(A);B=[1 3 6 10 15]
ut=counts .* (1:depth)';
u=cumsum(ut);
MAX=0;
level=0;
for t=1:depth
    u0=u(t,1)/w(t,1);
    u1=(u(depth,1)-u(t,1))/(w(depth,1)-w(t,1));
    w0=w(t,1);
    w1=w(depth,1)-w0;
    g=w0*w1*(u1-u0)*(u1-u0);
    if g > MAX
        MAX=g;
        level = t;
    end
end
level=level/256;

function str=reduce(bwstr);
%ȥ�����ű�Ե��Ϣ
[m,n]=size(bwstr);
temp=ones(m,n);
num=1;
for j=1:n
    count=0;
    for i=1:m
        if bwstr(i,j)==0;					%����������-----------------����Ϊ��
            count=0;
			
			continue;
        else
           count=count+1;	                %�����������������
           if count>=m/3;					%���������䳤�ȳ���1/3�߳�
               break;
           end
        end
    end
    if count>=m/3
        line(num)=j;
        num=num+1;							%��¼ɨ�赽����λ��
    end
end
for i=1:num-1								%������ű�Ե
    for j=1:m
        temp(j,line(i))=0;
    end
end
num1=1;
for i=1:m/20
    count=0;
    for j=1:n
        if bwstr(i,j)==0;					%����������-----------------����Ϊ��
            count=0;
			
			continue;
        else
           count=count+1;	                %�����������������
           if count>=n/110;					%���������䳤�ȳ���Ԥ������Ŀ��
               break;
           end
        end
    end
    if count>=n/110
        line(num)=i;
        num=num+1;							%��¼ɨ�赽����λ��
    end
end
for i=1:num-1								%������ű�Ե
    for j=1:n
        temp(line(i),j)=0;
    end
end
str=logical(double(bwstr).*temp);



% --------------------------------------------------------------------
function getsynstr_Callback(hObject, eventdata, handles)
% hObject    handle to getsynstr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IMAGE;
global POKER;
global GRAY;
global BW;
global BWSTR;

if IMAGE==0										%δ��ͼ��
    msgbox('���ȴ�һ���˿�ͼ��','����','error');
elseif POKER==0									%δ����ͼ��У��
    msgbox('���ȶ�ͼ�����У����λ','����','error');
elseif GRAY==0									%δ����ͼ��ҶȻ�
    msgbox('���ȶ�ͼ����лҶȻ�','����','error');
elseif BW==0									%δ����ͼ���ֵ��
    msgbox('���ȶ�ͼ����ж�ֵ��','����','error');
else   
    [m,n]=size(GRAY);
    pokerstr=GRAY(2:m/2,n/20:n/5.5);			%�ַ����Զ�λ
     %pokerstr=GRAY(1:m/2,1:n/5.5);	
    bw=im2bw(pokerstr,ostu(pokerstr));			            %�Զ��庯��ostu()
    bw1=bwmorph(bw,'clean');					%���������
    bw2=logical(abs(double(bw1)-1));			%��ֵͼ��ɫ
    bw3=reduce(bw2);							%�Զ��庯��reduce()
    [m,n]=size(bw3);
    temp=sum(bw3);								%����Ϊ���󣬶�ÿһ�����
	shadow(2:n+1)=temp;							%��temp��ÿһ�и���shadow��2��n+1��Ӧ��
	shadow(1)=0;
	shadow(n+2)=0;
    for i=2:n+1
        if shadow(i)~=0&shadow(i-1)==0&shadow(i+1)==0%���ֹ�������
            for j=1:m
                bw3(j,i-1)=0;					%ɾ������������
            end
        end
    end
    [m,n]=find(bw3);
    BWSTR=bw3(min(m):max(m),min(n):max(n));
    subplot(1,1,1),imshow(BWSTR),title('ֽ�������ַ�');
end

% --------------------------------------------------------------------
function recognition_Callback(hObject, eventdata, handles)
% hObject    handle to recognition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IMAGE;
global POKER;
global GRAY;
global BW;
global BWSTR

%ֽ���ַ�ģ��,34*22ͶӰ
str01=[2,6,4,5,7,6,7,7,9,7,9,8,9,7,9,8,7,9,13,14,12,9,9,6,12,16,17,12,0,0,0,0,0,0,0,0,1,2,2,6,6,7,11,13,13,18,20,20,17,17,13,9,8,8,5,4,4,2];%��ƬA
str02=[4,11,14,16,11,10,8,8,8,5,5,5,6,6,7,6,6,5,4,4,7,9,8,8,10,18,18,9,0,0,0,0,0,0,0,0,2,3,5,7,8,10,12,12,14,16,19,20,17,15,13,10,8,6,5,3,2,1];%��Ƭ2
str03=[10,17,17,14,9,9,9,9,6,8,9,12,7,5,5,4,4,3,3,3,7,8,9,11,14,11,9,0,0,0,0,0,0,0,0,0,2,3,5,6,8,9,11,13,15,17,17,16,13,12,10,8,7,5,5,3,3,1];%��Ƭ3
str04=[3,3,4,4,5,6,6,6,7,7,7,7,7,7,7,7,6,7,14,16,16,9,3,3,4,7,7,7,0,0,0,0,0,0,0,1,3,2,4,6,8,8,10,12,14,15,16,16,14,12,10,8,7,6,4,2,2,0];%��Ƭ4
str05=[14,16,16,7,4,4,4,8,14,15,12,9,5,4,5,4,4,4,4,4,6,9,11,13,14,12,7,2,0,0,0,0,0,0,0,0,0,2,4,6,8,10,12,15,17,19,20,19,16,13,11,10,9,7,6,4,3,2];%��Ƭ5
str06=[4,9,12,14,9,6,4,4,3,11,15,16,13,11,9,9,7,7,7,6,7,8,8,8,11,11,9,6,0,0,0,0,0,0,0,0,0,1,3,5,5,7,9,11,14,16,18,19,17,15,13,11,9,7,5,3,3,1];%��Ƭ6
str07=[14,17,19,13,9,9,5,4,3,3,4,4,5,4,4,4,4,3,4,4,4,4,4,4,4,3,3,2,0,0,0,0,0,0,0,0,0,1,3,5,7,6,8,11,14,15,17,19,19,17,15,11,10,9,6,5,3,2];%��Ƭ7
str08=[4,8,11,11,10,8,7,7,7,8,10,13,11,10,12,14,12,9,7,8,7,7,7,8,12,14,11,6,0,0,0,0,0,0,0,0,1,2,4,6,7,9,10,12,13,16,18,19,19,14,11,9,7,6,5,4,2,1];%��Ƭ8
str09=[2,8,11,13,10,10,9,9,8,10,8,10,10,9,12,12,15,17,13,7,4,4,4,8,8,12,10,7,0,0,0,0,0,0,0,0,1,3,5,5,8,9,10,13,16,17,19,20,15,14,12,10,6,6,6,3,2,1];%��Ƭ9
str10=[4,13,14,14,12,12,11,11,11,12,12,12,12,11,10,11,11,11,11,12,12,12,10,11,14,13,12,10,2,0,0,0,0,0,0,0,2,2,4,5,7,10,10,12,14,16,17,18,16,15,13,8,8,6,4,3,2,1];%��Ƭ10
str11=[5,5,6,7,7,7,8,9,7,7,6,7,5,5,6,5,6,6,6,12,12,13,7,5,6,8,12,15,15,7,0,0,0,0,0,0,0,5,8,8,9,10,9,8,9,13,17,19,20,20,19,18,13,9,3,4,5,1];%÷��A
str12=[6,10,13,14,9,8,8,7,7,5,4,4,5,5,5,6,6,5,5,5,4,4,7,7,7,6,7,16,16,17,0,0,0,0,0,0,0,0,6,8,9,9,9,9,8,14,18,18,20,20,20,19,17,13,6,2,3,4];%÷��2
str13=[8,18,17,13,8,10,9,5,4,5,7,10,12,7,4,4,4,4,4,4,3,3,5,7,9,11,14,14,12,5,0,0,0,0,0,0,0,1,5,7,8,10,9,9,7,9,16,17,18,20,20,19,17,14,8,2,3,3];%÷��3
str14=[3,4,5,5,6,6,7,7,8,7,7,9,7,6,7,6,6,6,7,8,8,16,21,12,4,4,4,4,6,9,8,0,0,0,0,0,0,0,4,6,8,9,10,10,10,9,13,15,20,21,22,22,22,18,14,11,3,3];%÷��4
str15=[3,14,14,9,4,3,3,3,4,10,14,13,7,5,3,4,4,3,3,5,4,3,4,6,10,8,12,12,10,9,1,0,0,0,0,0,0,0,5,5,9,9,9,9,9,7,14,18,19,20,20,21,20,16,12,4,3,4];%÷��5
str16=[4,10,12,10,9,5,3,3,3,9,9,14,14,11,9,9,7,7,7,7,6,7,6,7,7,9,11,10,6,6,0,0,0,0,0,0,0,0,5,8,9,9,9,7,10,15,17,19,19,19,19,18,15,12,2,2,4,2];%÷��6
str17=[9,17,17,14,10,8,7,5,3,3,4,5,4,5,5,5,5,5,5,4,4,4,3,5,4,4,4,4,3,2,0,0,0,0,0,0,0,2,8,9,9,9,9,8,8,16,18,19,19,21,21,20,17,11,8,3,5,2];%÷��7
str18=[8,12,9,7,8,6,7,7,7,6,8,8,11,9,10,12,8,8,7,7,6,6,6,5,7,9,12,14,10,8,0,0,0,0,0,0,0,0,4,7,8,8,8,8,8,6,16,18,20,20,20,20,20,17,14,2,3,4];%÷��8
str19=[5,8,11,11,11,8,9,8,7,8,8,8,8,7,8,9,12,16,15,13,5,3,4,4,7,9,12,15,11,4,0,0,0,0,0,0,0,0,7,9,10,10,11,10,9,13,18,20,21,21,22,21,18,14,9,4,5,5];%÷��9
str20=[5,12,13,13,12,12,11,12,9,12,11,13,10,12,9,11,11,10,11,13,13,12,11,12,9,12,14,13,13,11,3,0,0,0,0,0,0,4,7,7,9,9,9,9,9,14,19,21,21,21,19,19,15,13,6,3,4,2];%÷��10
str21=[5,5,6,6,6,7,8,7,7,8,8,8,7,7,6,7,7,9,13,13,12,9,9,8,8,11,18,18,7,0,0,0,0,0,0,0,1,3,5,5,7,9,11,12,15,15,17,17,19,19,19,18,14,13,3,4,4,7];
str22=[3,11,14,14,11,8,7,8,7,4,4,5,4,4,7,6,6,5,4,5,4,5,7,7,6,15,18,16,0,0,0,0,0,0,0,0,1,4,4,5,7,9,11,14,16,16,17,18,19,18,18,18,17,8,2,4,6,3];
str23=[5,19,19,17,10,10,10,8,4,6,8,12,9,7,4,4,4,4,4,4,4,7,9,9,13,15,13,10,0,0,0,0,0,0,0,2,2,3,4,6,8,9,12,13,14,16,17,18,18,19,16,16,14,4,3,4,5,2];
str24=[1,5,5,6,7,7,7,8,7,8,9,9,9,8,9,8,9,9,20,21,20,6,4,3,3,8,9,9,2,0,0,0,0,0,0,0,2,3,4,7,8,10,11,14,15,16,17,17,20,20,17,17,14,9,2,3,5,3];
str25=[16,17,16,4,4,4,4,12,16,18,12,9,9,6,4,5,4,4,4,5,4,8,10,11,14,15,11,7,1,0,0,0,0,0,0,0,1,3,4,7,8,11,12,14,16,17,19,19,20,20,19,15,16,7,3,3,5,3];
str26=[2,7,11,14,10,9,9,5,5,7,12,16,15,11,12,10,9,9,10,9,8,9,9,10,11,14,13,10,4,0,0,0,0,0,0,0,2,3,5,6,8,9,11,15,15,17,18,19,19,20,20,15,12,9,2,4,5,3];
str27=[13,20,21,19,10,12,5,6,5,5,5,5,5,5,5,4,4,4,5,6,5,5,5,6,5,5,5,5,2,0,0,0,0,0,0,0,1,3,5,6,8,10,13,14,16,17,19,20,20,20,20,19,13,10,2,4,5,6];
str28=[8,13,15,11,8,9,9,7,8,8,9,15,10,11,13,12,12,9,7,7,8,9,8,10,14,14,11,9,0,0,0,0,0,0,0,0,2,3,4,6,7,9,12,13,15,16,17,20,18,18,17,15,12,5,3,3,5,2];
str29=[2,10,14,12,9,10,8,7,8,8,9,10,10,12,11,12,16,17,14,6,4,4,7,8,11,14,12,5,0,0,0,0,0,0,0,0,2,2,4,6,8,11,12,13,17,18,17,17,18,19,19,15,13,8,3,3,6,2];
str30=[1,12,15,15,13,14,14,12,12,12,14,12,14,15,13,13,13,14,14,14,12,14,13,13,12,14,16,14,13,2,0,0,0,0,0,0,1,3,4,6,8,8,11,13,14,16,17,19,20,20,20,16,14,11,7,2,4,7];
str31=[4,5,6,6,6,7,7,6,7,8,8,6,6,7,8,8,8,8,9,13,13,15,15,8,7,7,11,18,18,18,0,0,0,0,0,0,1,12,16,18,19,20,19,19,19,17,17,15,14,12,11,9,7,6,5,3,1,1];
str32=[2,11,14,16,17,11,10,8,7,7,5,6,6,5,6,6,6,6,6,6,5,5,7,8,8,9,9,18,20,21,0,0,0,0,0,0,0,9,14,17,19,21,21,21,19,18,18,17,15,13,13,11,8,8,7,5,3,1];
str33=[2,14,19,19,12,9,10,9,10,5,8,10,13,10,7,5,5,4,4,3,4,4,5,7,10,11,13,16,13,10,1,0,0,0,0,0,0,7,12,15,16,18,19,18,17,17,16,15,14,12,12,10,8,8,6,5,3,1];
str34=[1,5,5,6,7,7,7,9,9,8,8,9,7,8,9,9,7,9,8,13,22,22,21,12,3,5,4,10,11,9,2,0,0,0,0,0,0,5,13,16,19,20,20,20,20,20,18,17,16,14,12,11,9,8,6,3,3,2];
str35=[14,17,17,10,4,5,5,6,10,17,17,13,13,7,4,4,5,4,3,3,3,4,7,10,13,10,13,13,11,4,0,0,0,0,0,0,6,14,18,19,21,21,20,20,20,18,18,17,15,14,11,11,8,6,5,4,2,1];
str36=[3,10,13,14,13,8,9,5,5,6,14,14,15,14,11,11,9,8,9,9,9,8,8,8,10,9,9,13,13,8,4,0,0,0,0,0,0,1,8,12,15,18,18,18,19,20,17,16,15,12,12,12,9,8,7,5,4,2];
str37=[9,18,19,14,11,10,9,5,4,4,5,5,5,3,4,4,4,5,4,4,5,4,3,4,5,4,4,4,5,3,1,0,0,0,0,0,0,2,12,16,19,18,18,18,19,19,18,16,15,13,10,10,9,7,6,6,4,1];
str38=[5,10,13,10,9,8,7,8,8,10,9,11,14,11,10,12,11,11,11,8,7,9,10,8,9,8,12,14,13,11,6,0,0,0,0,0,0,8,11,13,16,18,18,19,17,17,17,16,15,13,11,9,8,6,5,4,3,2];
str39=[6,9,11,13,10,9,9,9,10,10,10,10,10,10,11,11,13,19,18,16,8,5,4,5,6,8,11,16,14,9,0,0,0,0,0,0,0,0,10,16,18,19,20,20,20,20,18,18,16,15,13,12,10,9,7,6,5,2];
str40=[4,10,14,15,15,15,14,12,12,13,14,15,14,12,12,13,14,14,14,14,12,13,14,14,12,11,13,14,13,11,7,0,0,0,0,0,0,5,14,16,15,17,18,18,18,17,17,16,15,13,11,11,8,7,5,5,4,1];

STR=[str01;str02;str03;str04;str05;str06;str07;str08;str09;str10;str11;str12;str13;str14;str15;str16;str17;str18;str19;str20;str21;str22;str23;str24;str25;str26;str27;str28;str29;str30;str31;str32;str33;str34;str35;str36;str37;str38;str39;str40];


if IMAGE==0											%δ��ͼ��
    msgbox('���ȴ�һ���˿�ͼ��','����','error');
elseif POKER==0										%δ����ͼ��У��
    msgbox('���ȶ�ͼ�����У����λ','����','error');
elseif GRAY==0										%δ����ͼ��ҶȻ�
    msgbox('���ȶ�ͼ����лҶȻ�','����','error');
elseif BW==0										%δ����ͼ���ֵ��
    msgbox('���ȶ�ͼ����ж�ֵ��','����','error');
elseif  BWSTR==0									%δ��ȡ����
    msgbox('������ȡͼ���ַ�','����','error');
else
    sym=imclose(BWSTR,strel('disk',3));				%���Թ������������С
    shadow=sum(sym);
    if max(shadow)>=100								%���ع���ʶ��ΪΪJOKER
        result=strcat('ʶ����:','JOKER');
        msgbox(result,'��Ϣ','warn');
    else
        sym=bwmorph(BWSTR,'clean');					%���������
        shadow=(sum(sym,2))';						%����ͶӰ-------��ÿһ�����
        len=length(shadow);                          %���ж�����
        
        SYM1=sym(1:len ,:);						%���ַ���          
        [m,n]=find(SYM1);
        SYM1=SYM1(min(m):max(m),min(n):max(n));
        SYM1=imresize(SYM1,[58 22]);				%ģ���һ��
        shadow1=(sum(SYM1,2))';%ת�þ���
        
%�ַ�ƥ��
        errormean=50;sn1=0;
		minn=0;
		len1=length(STR);
        chazhi=zeros(2,1);
        for i=1:40									%�������ƥ���ģ��----------����13��ֽ���ַ�
	
            temp=STR(i,:);
            error=abs(shadow1-temp);                 %���ֵ�ҵ�����ϵ�ģ��
            error=mean(error,2);					%����Ծ���
			chazhi(i)=error;
			
        end
		chazhi=chazhi';
		chazhi_sort=sort(chazhi);
		sn1=strfind(chazhi,chazhi_sort(1));%�õ���ֵ��С��ֽ��ģ�����
       
      


        %����ӳ��
        switch sn1
            case 0
                result1='������ʶ����ַ�';
            case 1
                result1='��Ƭ-A';
            case 2
			     result1='��Ƭ-2';		%��Ӧ����ת���ַ���
            case 3
                result1='��Ƭ-3';
            case 4
			     result1='��Ƭ-4';		%��Ӧ����ת���ַ���
            case 5
                result1='��Ƭ-5';
            case 6
                result1='��Ƭ-6';
            case 7
			     result1='��Ƭ-7';		%��Ӧ����ת���ַ���
            case 8
                result1='��Ƭ-8';
            case 9
			     result1='��Ƭ-9';		%��Ӧ����ת���ַ���
            case 10
			     result1='��Ƭ-10';		%��Ӧ����ת���ַ���
            case 11
                result1='÷��-A';
            case 12
			     result1='÷��-2';		%��Ӧ����ת���ַ���
            case 13
                result1='÷��-3';
            case 14
			     result1='÷��-4';		%��Ӧ����ת���ַ���
            case 15
                result1='÷��-5';
            case 16
                result1='÷��-6';
            case 17
			     result1='÷��-7';		%��Ӧ����ת���ַ���
            case 18
                result1='÷��-8';
            case 19
			     result1='÷��-9';		%��Ӧ����ת���ַ���
            case 20
			     result1='÷��-10';		%��Ӧ����ת���ַ���
            case 21
                result1='����-A';
            case 22
                result1='����-2';
            case 23
			     result1='����-3';		%��Ӧ����ת���ַ���
            case 24
                result1='����-4';
            case 25
			     result1='����-5';		%��Ӧ����ת���ַ���
            case 26
                result1='����-6';
            case 27
                result1='����-7';
            case 28
			     result1='����-8';		%��Ӧ����ת���ַ���
            case 29
                result1='����-9';
            case 30
			     result1='����-10';		%��Ӧ����ת���ַ���
            case 31
                result1='����-A';
            case 32
			     result1='����-2';		%��Ӧ����ת���ַ���
            case 33
                result1='����-3';
            case 34
			     result1='����-4';		%��Ӧ����ת���ַ���
            case 35
                result1='����-5';
            case 36
                result1='����-6';
            case 37
			     result1='����-7';		%��Ӧ����ת���ַ���
            case 38
                result1='����-8';
            case 39
			     result1='����-9';		%��Ӧ����ת���ַ���
            case 40
			     result1='����-10';		%��Ӧ����ת���ַ���    
        end
        
        
       result=strcat('ʶ����:',result1);
       msgbox(result,'��Ϣ','warn');
    end
end
