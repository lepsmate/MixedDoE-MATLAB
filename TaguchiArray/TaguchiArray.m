% This algorithm provides the Orthogonal(Taguchi) Array with the inputs: 
% Q (the number of the levels) and N (the number of the factors).
% The output is an M*N array where M = Q^J, the rows of the Taguchi table and J meets the equation N= Q^(J-1) - 1)/(Q-1); 
% Reference: Leung, Y.-W.; Yuping Wang, "An orthogonal genetic algorithm 
% with quantization % for global numerical optimization," Evolutionary 
% Computation, IEEE Transactions on , vol.5, % no.1, pp.41,53, Feb 2001.
% Email: chixinxiao@gmail.com , Chixin Xiao, UoW ,AU , 23 May 2019

% Step 1:Construct the basic columns asfollows:
function [Ta] = TaguchiArray(Q , N)
% Q is the number of the levels;
% N is the  number of the factors (the columns);
% M = Q^J is the number of rows of the Taguchi array, where J meets the euqation N= Q^(J-1) - 1)/(Q-1);
% The Taguchi array can be denoted as L_M_(Q^N) = Ta(M*N).
if (nargin==0)
    Q=3;
    N=4;
end
%%
J = floor(log(N*(Q-1)+1)/log(Q));  % N = (Q^J - 1)/(Q-1);
if(N ~= ((Q^J - 1)/(Q-1)))      % To find the suitable J meeting the equation above;
    J=J+1;
end

Ta = [];
for k = 1:J
    j = (Q^(k-1) - 1)/(Q-1) + 1;
      for i= 1 : Q^J
          Ta(i,j) = mod(floor((i-1)/Q^(J-k)) ,Q);
      end
end
% Step 2:Construct the nonbasic columnsas follows
for k=2 :J 
    j =  (Q^(k-1) - 1)/(Q-1) + 1;
    for s = 1 : j-1
        for t = 1 : Q-1
            Ta(:,j+(s-1)*(Q-1)+t) = mod(Ta(:,s)*t+Ta(:,j),Q);           
        end
    end
end
%Step 3:Incrementby a(i,j) by one for all, i.e., 1<=i<=M, 1<=j<=M
Ta = Ta+1;

Ta = Ta(:,1:N);
end
