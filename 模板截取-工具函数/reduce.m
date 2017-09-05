function str=reduce(bwstr);
%去除干扰边缘信息
[m,n]=size(bwstr);
temp=ones(m,n);
num=1;
for j=1:n
    count=0;
    for i=1:m
        if bwstr(i,j)==0;					%线条不连续
            count=0;continue;
        else
            count=count+1;					%连续不跳变点数增加
            if count>=m/3;					%连续不跳变长度超过1/3边长
                break;
            end
        end
    end
    if count>=m/3
        line(num)=j;
        num=num+1;							%记录扫描到线条位置
    end
end
for i=1:num-1								%清除干扰边缘
    for j=1:m
        temp(j,line(i))=0;
    end
end
str=logical(double(bwstr).*temp);