function [ h, H ] = ideal_ce( chan, tau,  chanSRate)
sampIdx = round(tau/(1/chanSRate)) + 1;
% sampIdx = [1 1 1 2 2 2 3 4 6];
chPathG = chan.PathGains;
g = complex(zeros(12, 9));
for i = 1:12
    g(i,:) = mean(chPathG((i-1)*138+1:i*138,:),1);
end

hImp = complex(zeros(12, 128));

for i=1:length(sampIdx)
    idx = sampIdx(i);
    hImp(:,idx)  =  hImp(:,idx) + g(:,i);
end
h = hImp.';
H = fft(h);

end

