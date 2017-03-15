clc;clear;
sim_params;

SNRs = 0:3:30;  % 信噪比范围
Frames = 10;     % 仿真帧数

MSE         =zeros(length(SNRs),1);
MSE_ideal   =zeros(length(SNRs),1);
BER         =zeros(length(SNRs),1);

recover_algorithm = 'LS';  % LS, OMP
interp_method='linear';       % 内插方式 linear, spline, dft

delta_K = 4; % 导频占比
Len_pilot = K*L/delta_K;
iter_th = 60;

output = zeros(length(SNRs),3);
output(:,1) = SNRs;

the_date = clock;
output_filename = sprintf('%s_%s_%dkm_%dframes_%.3f_%04d%02d%02d_%02d%02d%02d',...
    recover_algorithm,...
    interp_method,...
    3.6*user_speed,...
    Frames,...
    Len_pilot/(K*L),...
    the_date(1),...      % Date: year
    the_date(2),...      % Date: month
    the_date(3),...      % Date: day
    the_date(4),...      % Date: hour
    the_date(5),...      % Date: minutes
    floor(the_date(6)));   % Date: seconds;

for SNR_index=1:length(SNRs)
    snr = SNRs(SNR_index);
    MSE_temp=0;
    BER_temp=0;    
    tic;
    for frame_index = 1:Frames
        x_M         = uint8(randi([0,1],K*2,L));
        x_QPSK      = qammod(x_M,4,'InputType','bit','UnitAveragePower',true);
        X_OFDM      = ifft(x_QPSK,K);
        x_tr = zeros(N,L);
        for l=1:L
            x_tr(:,l)=[X_OFDM(K+1-Lcp:K,l); X_OFDM(:,l)];%add CP
        end        
        y_faded = filter(chan,reshape(x_tr,N*L,1));
        
        h_all=chan.PathGains*chan.channelFilter.AlphaMatrix;%size of h vary with tau
        h = zeros(12,14);
        for i=1:12
            h(i,:) = mean(h_all((i-1)*N+1:i*N,:));
        end
        h = h.';
%         h=[mean(h_all(1:N,:));mean(h_all(N+1:2*N,:))].';
        H=fft(h,K);
        
        y_rxsig=ch_add_noise(y_faded,snr);
        Y_OFDM = zeros(K,L);
        for l=1:L
            index=(l*N-K+1):l*N;
            Y_OFDM(1:K,l)=fft(y_rxsig(index));
        end        
        
        switch recover_algorithm   
            case 'LS'
                H_est=zeros(K,L); 
                h_temp = zeros(K,L);
                for l=1:L
                    % compute the channel frequency response 
                    % use m to choose the estimation method
                    H_est_temp =OFDM_CE_LS(Y_OFDM(:,l),x_QPSK(:,l),delta_K,interp_method);
                    H_est(:,l)=H_est_temp;
                    h_temp=ifft(H_est);
                    h_est=h_temp(1:Lcp,:);                    
                end                
            case 'OMP'
                 H=Y_OFDM./x_QPSK;
                 H_reshaped=reshape(H,K*L,1);  %2个符号一起处理，信道变为一列
                 position_pilot=sort(randperm(K*L,Len_pilot));% random pilot position
                 U_P=U(position_pilot,:);                                       %% U 选取恢复矩阵
                 alpha=OFDM_CE_OMP(H_reshaped(position_pilot),U_P,iter_th);      %iter_th
                 H_est=reshape(U*alpha,K,L);
                 h_temp=ifft(H_est);
                 h_est=h_temp(1:Lcp,:);                 
        end
        
        %% MSE
        [row,col]=size(h);
        if row>Lcp
            h=h(1:Lcp,:);
        else
            h=cat(1,h,zeros(Lcp-row+1,col));
        end
%                 figure;stem(abs(h(:,1)),'*r');hold on;stem(abs(h_est(:,1)),'ob');
        MSE_temp=MSE_temp+sum(sum(abs(h-h_est).^2));        
        
        y_QPSK=Y_OFDM./H_est;
        y_M=uint8(qamdemod(y_QPSK,4,'bin','OutputType','bit'));
        
        BER_temp=BER_temp+length(find(x_M-y_M)~=0)/(K*L);        
    end
    MSE(SNR_index)=MSE_temp/Frames;
    BER(SNR_index)=BER_temp/Frames;
    SNR_index
    toc;
end
output(:,2) = MSE;
output(:,3) = BER;

save(strcat(output_filename,'.mat'), 'output');
