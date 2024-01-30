%% Author: Matej Leps
% 12/2023, CTU in Prague, Czech Republic
%
% Orthogonal array for different levels
%
function TGB = OA(LEVELS)
% needs code for Least common multiple and regular Orthogonal array 
addpath('lcms')
addpath('TaguchiArray')
if nargin<1
    % Examples
    % LEVELS = [2 4 3];
    % 1.span 2.height 3.slope 4. snow 5.wind 6.life
    LEVELS = [128 64 16 8 16 2];
end

vars = size(LEVELS,2);

% Just for size comparison uncomment following line
%DESIGN = fullfact(LEVELS);

maxlevel = lcms(LEVELS) ;

TG = TaguchiArray(maxlevel,vars) ;

for i=1:vars
    TG (:,i)=mod(TG (:,i),LEVELS(i)) ;
end

TGB = unique(TG,'rows') ;

TGB = TGB+1 ;
end
