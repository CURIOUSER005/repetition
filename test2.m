%function rep1 = test2(signal,fs)
addpath 'D:\code'
E = REnergy(signal,fs);
no_seg=0;k=1;flag=0;seg={};
for i=1:length(E)
    if E(i) >= 0.02  && i ~= length(E) %&& pitch(i) ~= 0
        if flag == 0
            no_seg =no_seg + 1;
            limit(no_seg,1) = i*fs/100;
            flag=1;
            
        end
    
    elseif flag == 1 && i == length(E)    
        limit(no_seg,2) = i*fs/100;
        
    else    
        if flag == 1
            limit(no_seg,2) = i*fs/100;
            flag=0;
        end
    end
    
           % plot(signal(limit(1,i):limit(1,i+1)));
end
%plot(signal);
k=1;
for i=1:size(limit,1)
    s1 = signal(limit(i,1):limit(i,2));
    if length(s1) > 3000
    
        seg{k} = signal(limit(i,1):limit(i,2));
        audiowrite( 'a.wav',seg{k},fs);
        %audiowrite(strcat(num2str(k),'.wav'),seg{1,k},fs);
        k=k+1;
    end
end
for i=1:length(seg)
        [plp2{i}, spec2{i}] = rastaplp(seg{1,i}, fs, 0, 12);
        plp2{i} = plp2{i}.';
        [mm{i},aspc{i}] = melfcc(seg{1,i}*3.3752, fs, 'maxfreq', 8000, 'numcep', 13, 'nbands', 22, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
        mm{i} = mm{i}.';
end
for i=1:length(seg)-1
    dist_plp(i) = dtw(plp2{1,i},plp2{1,i+1});
    dist_mfcc(i) = dtw(mm{1,i},mm{1,i+1});
end
flag=0;
k=1;
for i=1:length(seg)-1
    for j=i+1:i+1
        if  dtw(mm{1,i},mm{1,j}) < 5 && dtw(plp2{1,i},plp2{1,j}) < 7% && abs(alpha{1,i}-alpha{1,i+1}) < 0.5  && abs(dist_rpd(1,i)-dist_rpd(1,i+1)) < 0.0001  && ( abs(dist_f(1,i)-dist_f(1,i+1)) < 1000  ||    abs(dist_af(1,i)-dist_af(1,i+1)) < 1200 )              
             flag=1;
        end
        if i+2 > length(seg)
            break;
        end
    end
end
    
    

%end