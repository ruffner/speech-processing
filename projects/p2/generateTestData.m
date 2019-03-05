%% PROJECT 2 
% Matt Ruffner
% EE699 Speech Processing
% March 4th, 2019

% path to SUSAS data
audiopath = 'audio/';
% creates cell arrays of each file type
% break, eight, eighty, destination and zero
%   1      2       3          4          5
wavs = dir(audiopath);
filenames = {};
testnames = {'BREAK.*.wav','DESTIN.*.wav','EIGHT\d.*.wav','EIGHTY.*.wav','ZERO.*.wav'};
for x=3:size(wavs)
    filenames{x-2}={wavs(x).name, wavs(x).bytes};
end
% iterate through filenames and separate by word spoken
wavs=cell(1,5);
for x=1:5
    for y=1:length(filenames)
        if ~isempty( regexpi(filenames{y}{1},testnames{x}, 'match') )
            wavs{x}{end+1}=filenames{y};
        end
    end
end
% sort according to file size and take median
fileSizes=zeros(length(wavs{1}),5);
for x=1:5
    for y=1:length(wavs{x})
        fileSizes(y,x)=wavs{x}{y}{2};
    end
end
testWavs={}
