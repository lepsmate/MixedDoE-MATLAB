%% Generates Halton quasi-random sequence
% Recommended by Matlab Help
% Scrambling increases randomness but distorts fill-in-'gness
%
% InputVar:     np...number of points
%               dim...dimension
% OutVar:       X...resulting sequence
%
function X = halton(np,dim)

p = haltonset(dim,'Skip',round(rand(1,1)*10000));
%
% The order can be randomized by uncommenting followung line,
% but this is unwanted in sliced designs
% p = scramble(p,'RR2');
X = net(p,np);
end