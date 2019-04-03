%% Project 3 main script
% EE699 Speech Processing
% Spring 2019

[sigin,fs] = audioread('dig.wav');

% function for eventual work
%s = tpss(sig,fs,1,[1 1]);

% set frame size in seconds
framesize=0.020;
% calculate frame size in samples from audio sample rate
winlen=framesize*fs;

% define constant timescale
ts=1.2;

% define pitch shift to interpolate through
ps=[1 2];

% create output vector based on timescale
sigout=zeros(ceil(length(sigin)*ts),1);

% number of fixed frames
nfixedframes=floor(length(sigin)/winlen);

% get goi the glottal opening indexes in sigin signal
[gci,goi]=v_dypsa(sigin,fs);

% create vector indicating which frames are unvoiced
sigunv=zeros(1,nfixedframes);

% create fixed sized frames
Ff=[sigin(1:winlen)];
for i=1:nfixedframes-1
    Ff(:,i)=sigin(i*winlen:(i+1)*winlen-1);
end

% calculate zero crossing rate
for i=1:size(Ff,2)
    a=Ff(:,i);
    sigunv(i)=sum(abs(sign(a(2:winlen))-sign(a(1:winlen-1))));
end

% create chunks representing frames based on glottal openings
chunks=cell(1,length(goi));
for i=1:length(goi) 
    % center window around GOI
    frame_start=0;
    frame_end=0;
    
    if i==1
        frame_start=1;
        frame_end=round((goi(2)-goi(1))/2+goi(1));
    elseif i<length(goi)
        frame_start=round(goi(i)-(goi(i)-goi(i-1)/2));
        frame_end=round((goi(i+1)-goi(i))/2+goi(i));
    else
        frame_start=round(goi(i)-(goi(i)-goi(i-1)/2));
        frame_end=length(sigin);
    end
    
    % fill array with pitch synchronus chunk
    chunks{i}=sigin(frame_start:frame_end);
end

