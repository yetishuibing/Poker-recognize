function str=reduce(bwstr);
%ȥ�����ű�Ե��Ϣ
[m,n]=size(bwstr);
temp=ones(m,n);
num=1;
for j=1:n
    count=0;
    for i=1:m
        if bwstr(i,j)==0;					%����������
            count=0;continue;
        else
            count=count+1;					%�����������������
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
str=logical(double(bwstr).*temp);