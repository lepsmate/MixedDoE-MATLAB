%% Author: Matej Leps
% 02/2013, CTU in Prague, Czech Republic
%
%   Transforms a DoE from old bounds to new one
%
% DoE : Design of Experiments
% oldmin, oldmax, newmin, newmax : old and new bounds for the DoE
% can be scalar as well as vectors
%
% Examples: for any size: mytransform( DoE, 0, 1, -1, 1) 
% e.g. for 2D mixed: mytransform( DoE, 0, 1, [0, 0], [2,5]) 
% e.g. for 2D vectors: mytransform( DoE, [-1,-1], [1,1], [0, 0], [2,5]) 
%
function [ Out ] = mytransform( DoE, oldmin, oldmax, newmin, newmax )

    [ np, dim ] = size( DoE ) ;

    if (length(oldmin) == 1) && (length(oldmax) == 1)
        Omin = oldmin*ones(1,dim) ;
        Omax = oldmax*ones(1,dim) ;
    elseif (length(oldmin) ~= dim) || (length(oldmax) ~= dim)
        error('old bounds must have dim 1 or dim') ;
    else
        Omin = oldmin ;
        Omax = oldmax ;
    end
    
    if (length(newmin) == 1) && (length(newmax) == 1)
        Nmin = newmin*ones(1,dim) ;
        Nmax = newmax*ones(1,dim) ;
    elseif (length(newmin) ~= dim) || (length(newmax) ~= dim)
        error('new bounds must have dim 1 or dim') ;
    else
        Nmin = newmin ;
        Nmax = newmax ;
    end

    % % linear transformation to another interval
    % % h' = (h-old_min)(new_max-new_min)/(old_max-old_min) + new_min
   
    k = (Nmax-Nmin)./(Omax-Omin) ; % slope

    Out=((DoE-kron(ones(np,1),Omin)).*kron(ones(np,1),k) ) + kron(ones(np,1),Nmin);
    
    if any((Omax-Omin) == 0)
        error('One or more bounds have similar values for their lower and upper values.');
%        error('One or more bounds have similar values for their lower and upper values, transformation contains Inf! Changing Inf to 0.5.');        
%       ind0 = find(oldmax-oldmin == 0);
%      Out(:,(oldmax-oldmin == 0)) = 0.5;
    end
    if any((Nmax-Nmin) == 0)
        error('One or more bounds have similar values for their lower and upper values.');
    end

    
end
