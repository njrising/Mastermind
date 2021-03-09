% Score guess input against the solution
% black = right color right index
% white = right color wrong index
function [blackP,whiteP] = score(guess1,solution)
equal = bsxfun(@eq,solution,guess1);                    % index of equal elements ex.(1234==1111)
neq   = bsxfun(@ne,solution,guess1);                    % index of unequal elements ex.(1234!=1111)
blackP = sum(equal,2);                                  % number of black pegs
var1 = sum(ismember(guess1(neq),solution(neq)),2);      % determine min of shared elements 
var2 = sum(ismember(solution(neq),guess1(neq)),2); 
whiteP = min(var1,var2);                                % number of white pegs
end