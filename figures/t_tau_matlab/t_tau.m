pathGain1 = zeros(201,1000);
for i=1:1000
    y = interp1(tau,pathGain(:,i),tau1,'linear');
    y(abs(y)<0) = 0;
    pathGain1(:,i) = y;
end