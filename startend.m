function rep11 = startend(rep10)

i=1;j=1;
while i <= size(rep10,1)
    
    beg = rep10{i,1};
    last = rep10{i,2};
    k=i+1;
    if k <= size(rep10,1)
        
        while last == rep10{k,1}
            last = rep10{k,2};
            k=k+1;
        end
    end
    rep11(j,1)=beg;
    rep11(j,2)=last;
    i=k;j=j+1;
end

end