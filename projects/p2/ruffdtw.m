function [dist,path]=ruffdtw(X,Y)
% matt ruffner
% spring 2019 
% speech processing
% this function does dynamic time warping between matricies x and y
% where the columns represent the features therefor x and y must have the
% same number of columns

assert(size(X,2)==size(Y,2));

I=size(X,1); % rows in X
J=size(Y,1); % rows in Y

% local distance matrix
d=zeros(I,J);
% compute local distances
for i=1:I
   for j=1:J
       d(i,j)=(X(i)-Y(j))^2;
   end
end

% global distance matrix
D=zeros(size(d));
D(1,1)=d(1,1);

for i=2:I
    D(i,1)=d(i,1)+D(i-1,1);
end
for j=2:J
    D(1,j)=d(1,j)+D(1,j-1);
end
for i=2:I
    for j=2:J
        D(i,j)=d(i,j)+min([D(i-1,j),D(i-1,j-1),D(i,j-1)]);
    end
end

% unnormalized distance
dist=D(I,J);

% set staring point
i=1;
j=1;

% take first step
path(1,:)=[1 1];

% number of steps (for normalization)
k=1;

% while we haven't finished, calculate the path
while i+j<=I+J
    % check edge cases
    if i==I
        j=j+1;
    elseif j==J
        i=i+1;
    else
        % find min step distance and corresponding direction
        [values,number]=min([D(i+1,j),D(i,j+1),D(i+1,j+1)]);
        switch number
        case 1
            i=i+1;
        case 2
            j=j+1;
        case 3
            i=i+1;
            j=j+1;
        end
        
        % add this step to the path and increment path length
        k=k+1;
        path=cat(1,path,[i,j]);
    end
end

% nomalize distance
dist=dist/k;

return