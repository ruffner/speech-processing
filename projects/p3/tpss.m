function sigout=tpss(sigin,fs,ts,ps)
% function to perform  Time Scaling and Pitch Shifting (TPSS)
% sigin:  input signal
% fs: sample rate
% ts: scalar time scaling factor
% ps: 2 element vector of pitch shifting curve
%     [initial_pitch_shift, end_pitch_shift]
% 
% returns sigout: the shifted and/or scaled audio
%
% Matt Ruffner
% Spring 2019 
% Speech Processing UKY
%
% uses the voicebox toolbox and
% PSOLA algorithm adapted from 
% DAFX: Digital Audio Effects, Second Edition

% must be mono audio
assert(size(sigin,2)==1)

% get m the glottal opening indexes in sigin signal
% using voicebox toolbox v_dypsa
[~,m]=v_dypsa(sigin,fs);

% extract voiced/unvoiced estimate
% go through the glottal openings aka pitch markers
% and add 10ms marks for unvoiced speech
% doesn't work with real time functionality
%
%[~,~,pv,~]=v_fxpefac(sigin,fs,0.01);
% sampinc=round(0.01*fs);
% idx=1;
% for isVoiced=pv
%     if isVoiced<0.8
%         spos=idx*sampinc;
%         lastp=max(find(m<spos));
%         m=[m(1:lastp); spos; m(lastp+1:end)];
%     end
%     ixd=idx+1;
% end


% create pitch scaling axis 
psax=linspace(ps(1),ps(2),length(m));

% get pitch periods
P=diff(m);

% remove first pitch mark
if m(1)<=P(1)
    m=m(2:length(m));
    P=P(2:length(P));
end

% remove last pitch mark
if m(length(m))+P(length(P))>length(sigin)
    m=m(1:length(m)-1);
else
    P=[P P(length(P))];
end

Lout=ceil(length(sigin)*ts);
sigout=zeros(1,Lout);

% output pitch marks
tk=P(1)+1;

% psola algorithm
while round(tk)<Lout
    % get current segment
    [~,i]=min(abs(ts*m-tk));
    
    % current pitch mark
    pit=P(i);
    
    % extract and window input sig
    gr=sigin(m(i)-pit:m(i)+pit).*hanning(2*pit+1);
    
    % output indicies
    iniGr=round(tk)-pit;
    endGr=round(tk)+pit;
    
    % termination condition
    if endGr>Lout
        break
    end
    
    % overlap new segment
    sigout(iniGr:endGr)=sigout(iniGr:endGr)+gr';
    
    % shift by current value of pitch shift axis
    % modified to support a linear pitch shift
    tk=tk+pit/psax(i);
end

% 20kHz lowpass filter added to improve audio quality
[bb,aa]=butter(5,20e3/fs/2,'low');
sigout=filter(bb,aa,sigout)';
% sigout=sigout';

end