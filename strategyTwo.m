function guess = strategyTwo(list,guessPath)
scoreF = cell(1296,14);
scoreList = [0 0;1 0;1 1;1 2;1 3;2 0;2 1;2 2;3 0;0 1;0 2;0 3;0 4;4 0];
for ii = 1:size(list,1)
    for jj = 1:14
        blackP = scoreList(jj,1);
        whiteP = scoreList(jj,2);
        guess = list(ii,:);
        try
            gH = preEliminate(blackP,whiteP,guess);
            ptest = Elimfun(blackP,whiteP,guess,gH,list,guessPath);
            scoreF{ii,jj} = size(ptest,1);
        catch
            continue
        end
    end
end
try
    scoreF(cellfun('isempty',scoreF)) = {0};
    scoreF = cell2mat(scoreF);
    scoreF(scoreF==0)=nan;
    Min = min(scoreF,[],2);
for xx = 1:size(Min,1)
    F(xx,1) = histc(scoreF(xx,:),Min(xx));
end
MinF = [Min,F];
Min = min(Min);
F = max(F);
%MinF(bsxfun(@ne,MinF(:,1),Min),:)=inf;
MinF = bsxfun(@eq,MinF,[Min,F]);
guess = list(find(MinF(:,2)==1,1,'first'),:);
blackP = [];
catch
    guess = list;
end
end  