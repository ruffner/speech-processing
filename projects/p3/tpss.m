function S=tpss(s,fs,ts,ps)
% function to perform simulataneous time scaling and pitch shifting
% s:  input signal
% fs: sample rate
% ts: scalar time scaling factor
% ps: 2 element vector of pitch shifting curve
%     [initial_pitch_shift, end_pitch_shift]
%
% uses the voicebox toolbox


% get gottal opening and closing instances
[gci,goi]=v_dypsa(s,fs);

figure(1)
plot(gci,goi)

S=s;


end