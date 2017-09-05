function level=ostu(IMAGE)
%最大类间方差ostu算法,求最佳阈值
[m,n,s]=size(IMAGE);
if s==1
    image=IMAGE;
end
if s==3
    image=RGB2gray(IMAGE);
end
ranks=256;
counts=imhist(image,ranks);
p=counts/sum(counts);omega=cumsum(p);
mu=cumsum(p.*(0:ranks-1)');mu_t = mu(end);
sigma2=0;										%otsu类间方差
T=0;											%原始阈值
h=0;
Hmax=0;
w0=0;w1=0;
u0=0;u1=0;
HStore=zeros(1,256);
for i=1:ranks
    if (omega(i)==0)|((1-omega(i))==0)
        continue;
    end;
    w0=omega(i);w1=1-w0;
    u0=mu(i)/w0;u1=(mu_t-mu(i))/w1;
    sigma2=w0*(u0-mu_t).^2+w1*(u1-mu_t).^2;
    h=sigma2;HStore(i)=h;
end
Hmax = max(HStore);
isfinite_maxval = isfinite(Hmax);
if isfinite_maxval
    idx = mean(find(HStore == Hmax));
    level = (idx - 1) / (ranks - 1);
else
    level = 0.0;
end