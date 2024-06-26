function label = collabel(n)

a = fix((n-1)/26);
b = mod((n-1),26);
if (a==0)
    label = char(64+n);
else
    label = [char(64+a) char(64+b+1)];
end