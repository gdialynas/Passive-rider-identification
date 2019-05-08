function [wcoh] = calc_coherence(u,y,nfft,fs)

row_length  = (nfft/2)+1;
[~,col]     = size(u);
wcoh        = NaN(row_length,col);

for i = 1:col
    wcoh_sub = mscohere(u(:,i),y(:,i),hann(nfft),[],nfft,fs);  % coherence
    wcoh(:,i) = wcoh_sub;
end