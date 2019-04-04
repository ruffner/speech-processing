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
ts=2.0;

% define pitch shift to interpolate through
ps=[2.0 1];

% number of fixed frames
nffinput=floor(length(sigin)/winlen);

% number of fixed frames in output
nffoutput=floor(length(sigin)*ts/winlen);

% create output vector based on timescale
sigout=zeros(winlen*nffoutput,1);

% get goi the glottal opening indexes in sigin signal
[gci,goi]=v_dypsa(sigin,fs);

% create pitch scaling access 
psax=linspace(ps(1),ps(2),length(goi));

% create vector indicating which frames are unvoiced
sigunv=zeros(1,nffinput);

% create fixed sized frames
Ff=[sigin(1:winlen)];
for i=1:nffinput-1
    if (i+1)*winlen-1 > length(sigin)
        Ff(:,i+1)=[sigin(i*winlen:length(sigin)); zeros(length(sigin)-i*winlen,1)];
    else
        Ff(:,i+1)=sigin(i*winlen:(i+1)*winlen-1);
    end
end

% calculate zero crossing rate
for i=1:size(Ff,2)
    a=Ff(:,i);
    sigunv(i)=sum(abs(sign(a(2:winlen))-sign(a(1:winlen-1))));
end

% create chunks representing frames based on glottal openings
chunks=cell(1,length(goi));
psout=zeros(length(sigin),1);
psout(1:goi(1))=sigin(1:goi(1));
lastend=goi(1);
lastframe=0;
for i=2:length(goi)-1
    % center window around GOI
    frame_start=0;
    frame_end=0;
    
    if i==1
        %frame_start=1;
        %frame_end=round((goi(2)-goi(1))/2+goi(1));
        frame_start=1;
        frame_end=goi(2);
    elseif i<length(goi)
        %frame_start=round(goi(i)-((goi(i)-goi(i-1))/2));
        %frame_end=round((goi(i+1)-goi(i))/2+goi(i));
        frame_start=goi(i-1);
        frame_end=goi(i+1);
    else
        %frame_start=round(goi(i)-((goi(i)-goi(i-1))/2));
        %frame_end=length(sigin);
        frame_start=goi(i-1);
        frame_end=length(sigin);
    end
    
    % fill array with pitch synchronus chunk
    chunks{i}=sigin(frame_start:frame_end);
    
    % window chunk for overlap and add
    win=hanning(frame_end-frame_start+1);
    winfr=chunks{i}.*win;
    
    % current pitch period
    curper=goi(i)-goi(i-1);
    curdur=frame_end-frame_start;
    
    % new shifted period
    newper=round(curper*psax(i));            
    pshift=newper-curper;
    lastend=lastend+pshift;
    
    % fix edge cases
    if frame_start<1
        frame_start=1;
    end
    if frame_end>length(sigin)
        frame_end=length(sigin);
    end
    
    % if we need to fill an an extra pitch shifted to make up time
    if frame_start-lastend < curper 
        % if so then lay down the previous frame starting at lastend        
        psout(lastend:lastend+length(lastframe)-1)=psout(lastend:lastend+length(lastframe)-1)+lastframe(:);
        lastend=lastend+curper;
    else
        % lay down the current chunk
        psout(frame_start:frame_end)=psout(frame_start:frame_end)+winfr(1:frame_end-frame_start+1);
    end

    % save last frame for filling in gapsplot
    lastframe=winfr(1:curdur+1);
end

% do unvoiced plot to help understand
vsigout=[];
for i=1:length(chunks)
    
end

% create lpc chunks
% testing the pitch shifting
nchunks=length(chunks);
noutchunks=ceil(length(chunks)*ts);
sigout2=[];
for i=1:noutchunks
    
    origchunkidx=round(i/ts);
    
    if origchunkidx==0
        origchunkidx=1;
    end
    
    
    
    
end

sigout3=zeros(length(sigin),1);
for i=1:nchunks
    
    curfridx=goi(i);
    
    curfrlen=length(chunks{i});
    win=hanning(curfrlen);
    curfr=chunks{i}.*win;
    
    if i==1
       sigout3(1:curfrlen)=curfr;
    end
end


% iterate in new time scale
% index into old time scale position in glottal chunks
% do time scaling first
for i=1:nffoutput-1
    % index into old time scale
    ifidx=round(i/ts);
   
    if ifidx==0
        ifidx=1;
    elseif ifidx>nffinput
        ifidx=nffinput;
    end
    
    if i==1
       sigout(1:winlen)=Ff(:,ifidx);
    else
       sigout((i-1)*winlen:i*winlen-1)=Ff(:,ifidx);
    end
end

