function guess = strategyRandom(list,guess_curr)
list_size = size(list,1);
if list_size == 0
    guess = guess_curr;
elseif list_size == 1
    guess = list;
else
    guess = list(randi(size(list,1)),:);
end 
end