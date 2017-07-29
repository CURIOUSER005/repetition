clear;
warning off;
tic;
%% READ AUDIO SIGNAL

[signal, fs]=audioread('C:\Users\KHOMESH\Desktop\project\audio\Arthur\Repetitions\Arthur\M_0053_10y2m_1nrthe.wav');
signal = signal(:,1);
addpath 'D:\code'
%% SEGMENTING A AUDIO SIGNAL 
[syllables,FS,S,F,T,P] = SyllableSeg(signal,fs,882,441,1024,20);
for i=1:size(syllables,2)-1
    for j=i+1:size(syllables,2)
        if syllables(i).segments(1) > syllables(j).segments(1)
            temp = syllables(i);
            syllables(i) = syllables(j);
            syllables(j) = temp;
        end
    end
end
k=1;
for i=1:size(syllables,2)
    %s1 = signal(limit(i,1):limit(i,2));
    if length(syllables(i).signal) > 5000  
        seg{1,k} = syllables(i).signal; %(limit(i,1):limit(i,2));
        time(k,1)=min(syllables(i).times);
        time(k,2)=max(syllables(i).times);
        k=k+1;
    end
end

%% EXTRACT MFCC & PLP FEATURE OF SEGMENTS

addpath 'C:\Users\KHOMESH\Desktop\New folder\rastamat';
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
% 
%   disp(dist_plp);
%   disp(dist_mfcc);

%% FINDING REPETITION USING DYNAMIC TIME WRAPING

flag=0;flag2=0;
k=1;l=1;
for i=1:length(seg)-1
    for j=i+1:i+1       %% for more number of repetition increse the value of loop to require number
        if  dtw(mm{1,i},mm{1,j}) < 13 && dtw(plp2{1,i},plp2{1,j}) < 16% && abs(alpha{1,i}-alpha{1,i+1}) < 0.5  && abs(dist_rpd(1,i)-dist_rpd(1,i+1)) < 0.0001  && ( abs(dist_f(1,i)-dist_f(1,i+1)) < 1000  ||    abs(dist_af(1,i)-dist_af(1,i+1)) < 1200 )              
             rep1{k,1} = i;
             rep1{k,2} = j;
             k=k+1; flag=1;
        elseif dtw(mm{1,i},mm{1,j}) < 18 && dtw(plp2{1,i},plp2{1,j}) < 19
             rep2{l,1} = i;
             rep2{l,2} = j;
             l=l+1; flag2=1;
        end
        if i+2 > length(seg)
            break;
        end
    end
end   

%% POST PROCESSING OF REPETITION

    if flag == 1
    flag=0;
    rep = startend(rep1);
%     disp('confirm repetition');
%     disp(rep);
        for i=1:size(rep,1)
        segment{i} = signal(time(rep(i,1),1)*fs:time(rep(i,2),2)*fs);
        end
    end
    if flag2 == 1
    flag2=0;
    repd = startend(rep2);
        for i=1:size(repd,1)
        segment2{i} = signal(time(repd(i,1),1)*fs:time(repd(i,2),2)*fs);
        end
        plot(segments2{2});
    end
rmpath 'C:\Users\KHOMESH\Desktop\New folder\rastamat';




%% PLOT OF REPETED SEGMENTS

figure();
Time = 0:1/fs:(length(signal)-1) / fs;
hold on;
p1 = plot(Time,signal,'y');axis tight;
    
    %for (i=1:length(segment))
        for (j=1:length(segment))
     %       if (i~=j)
                timeTemp = time(rep(j,1),1):1/fs:time(rep(j,2),2);
                if length(segment{j}) < length(timeTemp)
                    timeTemp = timeTemp(1:length(timeTemp)-1);
                    P = plot(timeTemp, segment{j},'r');
                else
                    P = plot(timeTemp, segment{j},'r');
                end
                title('Segmented Output');
      %       end
        end
    %end
hold off;
toc;

