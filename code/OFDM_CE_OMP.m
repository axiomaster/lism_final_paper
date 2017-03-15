function h_est = OFDM_CE_OMP(H_sampled,F,iter_th)
% This function is to estimate H from H_sampled using OMP algorithm.
% without subsampling
% input:
%       H_sampled:  channnel frequency response in pilots,should be P*1
%       F:          FFT matrix
%       P:          indicate the sparsity
% output:
%       h_est:      estimated channnel impulse response,should be (M+1)*1
%       H_sampled=F*h_est;
%author:    fengkui gong 
%data:      20110521
[row,col]=size(F);
h_est = zeros(col,1);
mse_th=1e-2;
% iter_th=P*3;
rxSig = H_sampled;
bp = H_sampled;
A=F;
kp = 0;
iter = 0;
mse=10;
mse_history=zeros(iter_th,1);
searchCol = 1:col; % define a range for searching
idxSet = []; % the set of columns chosen at each iteration
while iter<iter_th && mse>mse_th
    alignmentVal = zeros(col,1);
    % first find the column in the matrix A, which is best aligned with signal
    % vector b0 = b and this is denoted as ak(1)
    for col = 1:length(searchCol)
            al = A(:, searchCol(col));
            % proj = al*al'/norm(al,2)^2; % NORM(V,P) = sum(abs(V).^P)^(1/P).
            alignmentVal(col) = abs(al'*bp)^2/norm(al,2)^2;
    end
    [tmp kpPos] = max(alignmentVal);
    kp = searchCol(kpPos);
    idxSet = [idxSet kp];
    % MP can be compared as
    % est_h(kp) =  akp'*bp/norm(akp,2)^2; 
    % OMP
    h_est(idxSet) = inv(A(:,idxSet)'* A(:,idxSet))* A(:,idxSet)'*rxSig;
    % then the projection of b0 along this direction is removed from b0 and the
    % residual b11 is obtained 
    % projection 
    bp = rxSig - A(:,idxSet)*h_est(idxSet);
     
     
     iter  = iter + 1;
     mse_history(iter)= norm(bp,2)^2;
     % update the searchCol, the column  selected should be
     % cancelled from next iteration
     searchCol(kpPos) = [];
end

end