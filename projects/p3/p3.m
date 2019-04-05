%% Project 3 main script
% EE699 Speech Processing
% Spring 2019


[sigin,fs] = audioread('jordan.wav');

% define constant timescale
ts=1;

% define pitch shift to interpolate through
ps=[2.0 0.5];

% perform the scaling and shifting
sigout = tpss(sigin(:,1),fs,ts,ps);
