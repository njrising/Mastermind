function guess1 = strategyThree(pnew,Guesspath)
    scoreF=cell(1296,14);
plist=[0 0;1 0;1 1;1 2;1 3;2 0;2 1;2 2;3 0;0 1;0 2;0 3;0 4;4 0];
for cc=1:size(pnew,1)
for nn=1:size(plist,1)
blackP=plist(nn,1);
whiteP=plist(nn,2);
guess1=pnew(cc,:);
try
gH=Test_Master2(blackP,whiteP,guess1);
ptest=Elimfun(blackP,whiteP,guess1,gH,pnew,Guesspath);
scoreF{cc,nn}=size(ptest,1);
catch
    continue
end
end
end
try
scoreF(cellfun('isempty',scoreF))={0};
scoreF=cell2mat(scoreF);%cellfun(@(scoreF)sum(scoreF),scoreF);
scoreF(scoreF==0)=nan;
Max=max(scoreF,[],2);
%Min=min(scoreF,[],2);
%for xx=1:size(Min,1)
 %   F(xx,1)=histc(scoreF(xx,:),Min(xx));
%end
%MinF=[Min,F];
%Min=min(Min);
%F=max(F);
%MinF(bsxfun(@ne,MinF(:,1),Min),:)=inf;
%MinF=bsxfun(@eq,MinF,[Min,F]);
%guess1=pnew(find(MinF(:,2)==1,1,'first'),:);
guess1=pnew(find(Max==min(Max),1,'first'),:);
blackP=[];
catch
    guess1=pnew;
end
end  