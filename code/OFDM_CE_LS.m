function H_LS = OFDM_CE_LS(Y_OFDM,x_QPSK,delta_K,method)
%%
% LS channel estimation in OFDM systems
% Y_OFDM :   the received siganl afrer FFT,should be K*1 vector
% X_OFDM :   the sented signal before IFFT,should be K*1 vector
% H_LS   :   the estimated channel frequency response,should be K*1 vector
% Method:
%       pilot position: H_P=Y_OFDM/Y_OFDM
%       the other     : interpolate between the pilots
%%
%   my method---failed
%     K=length(Y_OFDM);
%     x_p = X_OFDM(1:delta_K:K);
%     y_p = Y_OFDM(1:delta_K:K);
%     w_p = W(1:4:K,:);
%     A   = diag(x_p)*w_p;
%     h=A\y_p;

%%
% The  mothod in ¡¶ MIMO-OFDM wireless communication with MATLAB ¡·
K         =     length(Y_OFDM);
H_sampled     =     Y_OFDM(1:delta_K:K)./x_QPSK(1:delta_K:K);
pilot_loc =     1:delta_K:K;
if strcmp(method, 'dft')
    H_LS=fft(ifft(H_sampled),K);return;
end
H_LS=interpolate(H_sampled',pilot_loc,K,method)';  %µ¼Æµ¹À¼Æ - 1-DÄÚ²å

end

