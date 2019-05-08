function [wtf,wfv] = my_welch_method(u,y,nfft,fs)

row_length  = (nfft/2)+1;
[~,col]     = size(u);
wtf         = NaN(row_length,col);
wfv         = NaN(row_length,col);

for i = 1:col
[wtf_sub,wfv_sub] = tfestimate(u(:,i),y(:,i),hann(nfft),[],nfft,fs);   % transfer function
wtf(:,i) = wtf_sub;
wfv(:,i) = wfv_sub; 
end



