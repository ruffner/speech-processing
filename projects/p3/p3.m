%% Project 3 main script
% EE699 Speech Processing
% Spring 2019

[sig,fs] = audioread('ahhh.wav');

s = tpss(sig,fs,1,[1 1]);

%soundsc(s,fs)

[gci,goi]=v_dypsa(sig,fs);

figure(1)
plot(gci)

