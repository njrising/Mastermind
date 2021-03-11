function list = eliminateList(guess,list,blackP,whiteP)
aa = 1;
for ii = 1:size(list,1)
    [b,w] = score(list(aa,:),guess);
    if (b~=blackP) || (w~=whiteP) 
        list(aa,:) = [];
        aa = aa - 1;
    end
    aa = aa + 1;
end
end