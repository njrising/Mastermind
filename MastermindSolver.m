function Guesspath=MastermindSolver(Solution,guess1)
%profile on
tb=cputime;
%jK=PermList;
%for yt=1001:1296
%Solution='1234';%jK(yt,:);
%guess1='1122';%jK(randi(1296),:);
[blackP,whiteP] = Scorefun(guess1,Solution);
n = 1;
%blackP=0;
pnew = PermList;
p1 = pnew;
while blackP~=4
Guesspath{n}=guess1;
Responsepath{n}=[blackP whiteP];
gH=Test_Master2(blackP,whiteP,guess1);
pnew=Elimfun(blackP,whiteP,guess1,gH,pnew);
if size(pnew,1)==1
    guess1=pnew;
else
    %guess1=Genetic(p1,Responsepath,Guesspath);
guess1=pnew(randi(size(pnew,1)),:);
%guess1=KnuthScore(pnew);
%guess1=Strat2(pnew,Guesspath);            %guess1=KnuthScore(pnew);
%guess1=Strat3(pnew,Guesspath);
%guess1=Knuth(pnew,p1);
end
[blackP,whiteP]=Scorefun(guess1,Solution);
n=n+1;
end
Guesspath{n}=guess1;
%bg(yt)=size(pnew,1);
%gb(yt)=n;
%clearvars -except gb jK yt bg
%end
tc=cputime-tb;
%fprintf('%d \n',n);
%toc
% Declaring local functions
%--------------------------------------------------------------------------
%Gnuth Sort Search
function guess1=KnuthScore(pnew)
    scoreF=cell(1296,14);
plist=[0 0;1 0;1 1;1 2;1 3;2 0;2 1;2 2;3 0;0 1;0 2;0 3;0 4;4 0];
for cc=1:size(pnew,1)
for nn=1:size(plist,1)
blackP=plist(nn,1);
whiteP=plist(nn,2);
guess1=pnew(cc,:);
try
gH=Test_Master2(blackP,whiteP,guess1);
ptest=Elimfun(blackP,whiteP,guess1,gH,pnew);
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
%Max=max(scoreF,[],2);
Min=min(scoreF,[],2);
for xx=1:size(Min,1)
    F(xx,1)=histc(scoreF(xx,:),Min(xx));
end
MinF=[Min,F];
Min=min(Min);
F=max(F);
MinF(bsxfun(@ne,MinF(:,1),Min),:)=inf;
MinF=bsxfun(@eq,MinF,[Min,F]);
guess1=pnew(find(MinF(:,2)==1,1,'first'),:);
%guess1=pnew(find(Max==min(Max),1,'first'),:);
blackP=[];
catch
    guess1=pnew;
end
end   
%--------------------------------------------------------------------------
% Score guess input
function [blackP,whiteP]=Scorefun(guess1,Solution)
blackP=sum(bsxfun(@eq,Solution,guess1),2);
whiteP=bsxfun(@ne,Solution,guess1);
c1=intersect(Solution(whiteP),guess1(whiteP));
c5=zeros(1,length(c1));
if c1~=0
for gg=1:size(c1,2)
c3=  histc(Solution(whiteP),c1(gg));
c4=  histc(guess1(whiteP),c1(gg));
c5(1,gg)=min(c3,c4);
end
whiteP=sum(c5,2);
else
    whiteP=0;
end
end
%--------------------------------------------------------------------------
% Eliminate impossible guesses and output new perm list
    function pnew=Elimfun(blackP,whiteP,guess1,gH,pnew)
b=pnew;
if blackP+whiteP==4
    %pnew=gH;
    pnew=intersect(pnew,gH,'rows');
    ElimG=cell2mat(Guesspath');
    for ww=1:size(ElimG,1)
    pnew(sum(bsxfun(@eq,pnew,ElimG(ww,:)),2)==4,:)=[];
    end
    return
elseif strcmp(gH,'0000')
    v1=unique(guess1);
    for tt=1:size(v1,2)
       b(sum(bsxfun(@eq,b,v1(tt)),2)>0,:)=[];
    end
    path.guess{1}=b;
else
for kk=1:size(gH,1)
b(sum(bsxfun(@eq,b,gH(kk,:)),2)<blackP+whiteP,:)=[];  
v=(gH(kk,:)=='0');                                    
b(sum(bsxfun(@eq,b(:,v),guess1(v)),2)>=1,:)=[];
v4=unique(guess1);
Fguess=histc(guess1,v4);
Fgh=histc(gH(kk,:),v4);
velim=v4(Fguess~=Fgh);
for ii=1:size(velim,2)
b(sum(bsxfun(@eq,b(:,v),velim(ii)),2)>=1,:)=[];
end
path.guess{kk,1}=b;
b=pnew;
end
end
%ElimG=cell2mat(Guesspath');
 %   for ww=1:size(ElimG,1)
 %   pnew(sum(bsxfun(@eq,pnew,ElimG(ww,:)),2)==4,:)=[];
  %  end
pnew=unique(cell2mat(path.guess),'rows');%%
    end
%--------------------------------------------------------------------------
% Generate permutation list
function p=PermList
nPegs=('123456')';
nSpaces=4;
p=cell(nSpaces,1);
m=numel(nPegs);
for ii=1:nSpaces
p{ii}=repmat(repelem(nPegs,m^(nSpaces-ii),1),m^(ii-1),1);
end
p =[p{:}];
end
%--------------------------------------------------------------------------
%Master Sort function outputs perm list for elimination.
function gH=Test_Master2(blackP,whiteP,guess1)
% Generating Base Input
Inputpp=[repmat('0',1,4-blackP),repmat('1',1,blackP)]; 
inputB=unique(perms(Inputpp),'rows');
%
if blackP==4
    gH=guess1;
    return
end
if blackP~=0
    fill_ones
end
if whiteP==0
    gH=inputB;
    return
end

% Generating Combination Input
q=finddiff(inputB);
inputC=cell(size(q,1),1);
for aa=1:size(q,1)
inputC{aa,1}=nchoosek(q(aa,:),whiteP);
end
inputC=cell2mat(inputC);
inputC=[repmat('0',size(inputC,1),4-whiteP),inputC];
%

if blackP==0
for ff=1:size(inputC,1)
inputb=inputC(ff,:);
b=unique(perms(inputb),'rows');
for col=1:size(b,2)
b(b(:,col)==guess1(col),:)=[];
end
gH{ff,1}=b;
end
else
    x1=1;
for ff=1:size(inputB,1)
for bb=1:size(nchoosek(1:(4-blackP),whiteP),1)
inputb=inputC(x1,:);
b=unique(perms(inputb),'rows');
b=del_Cop(b);
N=repelem(inputB(ff,:),size(b,1),1);
N=putbInP(N,b);
gH{x1,1}=N;
x1=x1+1;
end
end
end
gH=unique(cell2mat(gH),'rows');
%

    function N=putbInP(N,b)
b1=1;
for jj=1:size(b,1)
b2=1;
for ii=1:size(b,2)
if N(jj,ii)=='0'
    try
N(jj,ii)=b(b1,b2);
b2=b2+1;
    catch
    continue
    end
else
    b2=b2+1;
end
end
b1=b1+1;
end
    end

function fill_ones
[x,y]=find(inputB=='1');
for ii=1:size(x,1)
inputB(x(ii),y(ii))=guess1(y(ii));
end
end

function q=finddiff(inputp)
q=repmat(repmat('0',1,4-blackP),size(inputB,1),1);
for ii=1:size(inputp,1)
q(ii,:)=guess1(bsxfun(@ne,guess1,inputp(ii,:)));  
end
end

function b=del_Cop(b)
v=find(inputB(ff,:)~='0');
for col2=1:size(b,2)
b(b(:,col2)==guess1(col2),:)=[];
end
for col1=1:size(v,2)
b(b(:,v(col1))~='0',:)=[];
end
end
end
%--------------------------------------------------------------------------
%profile viewer
end
