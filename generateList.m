% Generate permutation list
function p = generateList
nPegs = ('123456')';   % number of colors
nSpaces = 4;           % word length 
p = cell(nSpaces,1);
m = numel(nPegs);
for ii = 1:nSpaces
    p{ii} = repmat(repelem(nPegs,m^(nSpaces-ii),1),m^(ii-1),1);
end
p =[p{:}];
end