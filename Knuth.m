function guess1 = Knuth(pnew,p1)
scoreF = cell(1296,14);
plist=[0 0;1 0;1 1;1 2;1 3;2 0;2 1;2 2;3 0;0 1;0 2;0 3;0 4;4 0];
for cc=1:size(p1,1)
    for nn = 1:size(plist,1)
        blackP = plist(nn,1);
        whiteP = plist(nn,2);
        guess1 = p1(cc,:);
        try
            gH = pre_elim(blackP,whiteP,guess1);
            ptest = Elimfun(blackP,whiteP,guess1,gH,pnew);
            scoreF{cc,nn}=size(ptest,1);
        catch
            continue
        end
    end
end
try
    scoreF(cellfun('isempty',scoreF))={0};
    scoreF = cell2mat(scoreF);
    scoreF(scoreF==0)=nan;
    Max=max(scoreF,[],2);
    guess1 = p1(find(Max==min(Max),1,'first'),:);
    blackP = [];
catch
    guess1 = pnew;
end
end   