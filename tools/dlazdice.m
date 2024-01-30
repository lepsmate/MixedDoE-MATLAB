%% Author: Matej Leps
% 12/2023, CTU in Prague, Czech Republic
% 
% Displays N-dimensional DoE as 2D tiles
%
% X : is DoE
% group : id of a group that will be collored differently
%
function dlazdice(X,group)

nP = size(X,1);
dim = size(X,2);

if nargin < 2
    group=zeros(nP,1) ; 
end

if (length(group) == 1)
    if (mod(nP,group) ~= 0)
        error('X should be divid-able by group') ;
    end
    count = nP/group ;
    group = reshape(repmat([1:group]', 1,count)', 1, []) ;
elseif (length(group) ~= nP)
    error('group should have size either 1 or nP') ;
else
end

[dummy, ~, ic] = unique(group) ;
nColors = length(dummy) ;

c = jet(nColors);

% figure('Position',[0 0 600 600])

for i=1:dim-1
    for j=(i+1):dim
        subplot(dim-1,dim-1,(i-1)*(dim-1)+j-1)
        for k=1:nColors
            scatter(X(ic==k,i),X(ic==k,j),"ColorVariable",c(k,:)); hold on ;
        end
    end
end
end
