% /////////////////////////////////////////////////////////////////////////
% // filename: ch_add_noise.m
% // function illustration: add baseband channel effect for ATSC-T system
% // input:
% //       txData - transmitted baseband symbol data stream
% //       chSNR - signal to noise ratio, (0, 40), dB
% //       test - default 0, means no display
% // output:
% //       rxDataNoise - received baseband symbol data stream with AWGN noise
% // topmodule filename: ch_atsc_channel.m
% // submodule filename:
% // author: Gong Fengkui(27-03-2006)
% // modifier: Gong Fengkui (28-04-2006)
% // version 1.1

function [rxDataNoise,noisePow]= ch_add_noise(txData, chSNR, test);
% test is a parameter of controling display
if nargin<3
    test = 0;
end

% input txData'a format
[row col] = size(txData);

% remove the DC pilot energy
dcPilot = mean(txData);

% calculate input signal's power
sigPow = mean(abs(txData-dcPilot).^2);

% calculate the noise power
% 10log10(sigPow/noisePow) = chSNR
noisePow = sigPow*10^(-chSNR/10);

% create AWGN noise with power equals to noisePow
noise = sqrt(noisePow/2)*(randn(row,col)+j*randn(row,col));

% ////////////////////////////////////////////
if test
   testedNoisePow = mean(abs(noise).^2);
   testedSNR = 10*log10(sigPow/testedNoisePow);
   str = sprintf('Tested channel parameter: noise power = %f, SNR = %f dB', testedNoisePow, testedSNR);
   disp(str);
   clear testedNoisePow testedSNR str;
end
% /////////////////////////////////////////////

% output
rxDataNoise = txData + noise;

% clear temporatory variable
clear row cl sigPow noise;

