%% Author: Matej Leps
% 12/2023, CTU in Prague, Czech Republic
%
% open and read JSON output file
%
function openOut(name)

%% open and read input file
%
if nargin<1
    error('Input needed') ;
    % for working with the same file repeatedly
    % fname = './Examples/velmi-maly.out.json';
else 
     fname =name ;
end


fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
value = jsondecode(str) ;

Design = value.Experiments ;

%% graphical output
% 
dlazdice(Design(:,:))