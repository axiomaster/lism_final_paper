fc = 2.0e9;
light_speed = 299792458;
BW = '1.4M';
over_sample = 1;           % 过采样
chanSRate = 1.92e6*over_sample;
deltaF = 15000;
K = 128;
L = 12;
Lcp = 16;
N = K+Lcp;

tau = [0 3 7 14 21 26 34 56 74]/chanSRate;
% tau = [0,30,150,310,370,710,1090,1730,2510]*1e-9; %信道延迟, 5个符号 
pdp = [0,-1.5,-1.4,-3.6,-0.6,-9.1,-7,-12,-16.9];  %信道增益 [0,-1.5,-1.4,-3.6,-0.6,-9.1,-7,-12,-16.9]
user_speed = 1000/3.6;
fd = user_speed/light_speed*fc;
v_max = fd/deltaF;                %500km/h = 0.0618;

chan = rayleighchan(1/chanSRate,fd,tau,pdp);
chan.StoreHistory = 1;
chan.StorePathGains=1;
chan.ResetBeforeFiltering=1;

m=repmat([0:K-1]',1,L);
i=repmat([0:L-1],K,1);
U=zeros(K*L,K*L);
index=1;
for l=0:L-1
    for k=0:K-1
        U(index,:)=reshape( (1/sqrt(L*K)).*exp(-1i*2*pi*(k*m/K-l*i/L)),1,K*L);
        index=index+1;
    end
end