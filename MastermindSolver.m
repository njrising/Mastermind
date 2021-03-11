function guessPath = MastermindSolver(Solution,guess,k)
n = 1;                                      % current index
[blackP,whiteP] = score(guess,Solution);    % Score initial guess
list = generateList;                        % Generate list of possible guesses (npegs^length = 6^4 = 1296)
% Main loop continues until black score equals 4
% indicating the solution was found
while blackP ~= 4
    guessPath{n} = guess;               % Add guesses to guess path
    scorePath{n} = [blackP whiteP];     % Add scores to score path 
    
    %gH = preEliminate(blackP,whiteP,guess);
    %list = Elimfun(blackP,whiteP,guess,gH,list,guessPath);
    list = eliminateList(guess,list,blackP,whiteP);
    %if size(list,1)==1
   %     guess = list;
    %else
    switch k
        case 1
            guess = strategyRandom(list,guess);
        case 2
            guess = strategyTwo(list,guessPath);           
        case 3
            guess = strategyThree(list,Guesspath);
        case 4
            guess = Knuth(list,p1);
    end
    %end
    [blackP,whiteP] = score(guess,Solution);
    n = n + 1;
end
guessPath{n} = guess;
end