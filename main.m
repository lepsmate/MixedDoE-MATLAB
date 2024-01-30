%% Author: Matej Leps
% 12/2023, CTU in Prague, Czech Republic
%
% MixedDoE-MATLAB is a program that creates a Design of (computer) Experiments (DoE) 
% for cobination of discrete and/or continuous variables in Matlab. The descrete 
% part is composed either of full factorial or Taguchi-type Orthogonal array desings. 
% For each point in a descrete part, a sliced design (Qian, 2015) is created for continuous variables. 
% In this way, the continuous domain is uniformly covered but still, 
% for different discrete poits the continuous part is not overlapping. 
% Two procedures for contonuous part are available - 
% either Halton sequence, or the classical LHS design. 
% In the same way, the possibility of testing data generation is available.
%
function main(name)
addpath '../tools'

%% open and read input file
%
if nargin<1
    fname = './Examples/small.json';
else 
     fname =name ;
end
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
value = jsondecode(str) ;

%% inicialization
%
[Dim,~] = size(value.SetOfInputParameters) ;

nPoints = value.NumberOfContinuousPoints ;

if strcmp(value.TypeOfRequest, 'onlytrain')
    testPoints = 0 ;
    ttPoints = nPoints ;
elseif strcmp(value.TypeOfRequest, 'testtoo')
    testPoints = value.NumberOfContinuousTestPoints ;
    ttPoints = nPoints + testPoints ;
else
    error('Incorrect Type of request') ;
end

nDisc = 0 ;
nCont = 0;

positionDisc = [] ;
positionCont = [] ;

LEVELS = [] ;
OAsize = 0 ;

xMin = [] ;
xMax = [] ;

for i=1:Dim
    switch(value.SetOfInputParameters{i, 1}.OptimizationType)
        case 'discrete'
            nDisc = nDisc + 1 ;
            positionDisc = [positionDisc i] ;
            LEVELS = [LEVELS value.SetOfInputParameters{i, 1}.DiscreteValuesCount] ;
        case 'continuous'
            nCont = nCont + 1 ;
            positionCont = [positionCont i] ;
            xMin  = [xMin value.SetOfInputParameters{i, 1}.ContinuousMin] ;
            xMax  = [xMax value.SetOfInputParameters{i, 1}.ContinuousMax] ;
        otherwise
            error('Incorrect OptimizationType in input file of variable %d', i) ;
    end
end

%% DoE
%
switch(value.TypeOfOA)
    case 'fullfact'
        DESIGN = fullfact(LEVELS);
        [OAsize,~] = size(DESIGN) ;
        % randomization "to be sure", for bad LHS designs
        DESIGN = DESIGN(randperm(OAsize),:) ;
    case 'OA'
        DESIGN = OA(LEVELS);
        [OAsize,~] = size(DESIGN) ;
        % randomization "to be sure", for bad LHS designs
        DESIGN = DESIGN(randperm(OAsize),:) ;

    otherwise
        error('Incorrect OA type') ;
end


switch(value.TypeOfDoEs)
    case 'independent'
        error('Not implemented yet, but probably not needed.') ;
    case 'dependent'
        allPoints = OAsize*ttPoints ;
        trainPoints  =  OAsize*nPoints ;
    otherwise
        error('Incorrect DoEs type') ;
end

switch(value.TypeOfLHS)
    case 'halton'
       % XC = halton_LHS (allPoints,nCont) ;
       XC = halton (allPoints,nCont) ;
    case 'matlab'
        % not correct for overlapping, will be replaced in a new version
        XC = lhsdesign (allPoints,nCont) ;
    otherwise
        error('Incorrect LHS type') ;
end

%% transformation
XC = mytransform(XC,0,1,xMin,xMax) ;

%% unite
switch(value.TypeOfDoEs)
    case 'independent'
    case 'dependent'
        Design = zeros(allPoints,Dim) ;
        Design(:,positionCont) = XC ;
        % Design(:,positionDisc) = repmat(DESIGN,ttPoints,1) ;

        if strcmp(value.TypeOfRequest, 'onlytrain')
            Design(:,positionDisc) = reshape(repmat(DESIGN', nPoints, 1), size(DESIGN, 2), [])';
        elseif strcmp(value.TypeOfRequest, 'testtoo')

            Design(:,positionDisc) = ...
                [ reshape(repmat(DESIGN', nPoints, 1), size(DESIGN, 2), [])' ;
                reshape(repmat(DESIGN', testPoints, 1), size(DESIGN, 2), [])' ];
        else
            error('Incorrect Type of request') ;
        end
        
    otherwise
        error('Incorrect DoEs type') ;
end

%% write output
% 
fOUTname = strrep(fname, '.json', '.out.json');
fid = fopen(fOUTname,'w');
s = struct("Experiments", Design(1:trainPoints,:));
encodedJSON = jsonencode(s);
fprintf(fid, encodedJSON);
fclose(fid);

if strcmp(value.TypeOfRequest, 'testtoo')
    fOUTname = strrep(fname, '.json', '.test.json');
    fid = fopen(fOUTname,'w');
    s = struct("Experiments", Design(trainPoints+1:end,:));
    encodedJSON = jsonencode(s);
    fprintf(fid, encodedJSON);
    fclose(fid);
elseif strcmp(value.TypeOfRequest, 'onlytrain')
else
    error('Incorrect Type of request') ;
end

%% graphical output
% 
dlazdice(Design(:,:))
end

