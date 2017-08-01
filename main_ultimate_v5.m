 clear;
warning off;
folder = uigetdir;
wavfiles = dir(fullfile(folder,'*.wav'));
wf=[];
len=length(wavfiles);
pre={}; 
addpath 'C:\Users\KHOMESH\Desktop\New folder\audio';
cnt=1;pro = 0;
 addpath 'D:\code'
 decision_factor={};
for ind=1:len
    [pathstr,name,ext]=fileparts(wavfiles(ind).name);
    [fname]=wavfiles(ind).name;
    [wf]=fullfile(folder, fname);
    clear signal;clear limit;
    [signal,fs]=audioread(wf);
	fn = wf;
    disp(fname);
    
    signal = signal(:,1);
    addpath 'D:\code'
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
            k=k+1;
        end
    end
    disp(length(seg));
    addpath 'C:\Users\KHOMESH\Desktop\New folder\rastamat';
    for i=1:length(seg)
            [plp2{i}, spec2{i}] = rastaplp(seg{1,i}, fs, 0, 12);
            plp2{i} = plp2{i}.';
            [mm{i},aspc{i}] = melfcc(seg{1,i}*3.3752, fs, 'maxfreq', 8000, 'numcep', 13, 'nbands', 22, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
            mm{i} = mm{i}.';
    end
    flag=0;flag2=0;
    k=1;l=1;
    for i=1:length(seg)-1
        for j=i+1:i+1       %% for more number of repetition increse the value of loop to require number
            if  dtw(mm{1,i},mm{1,j}) < 13 && dtw(plp2{1,i},plp2{1,j}) < 16% && abs(alpha{1,i}-alpha{1,i+1}) < 0.5  && abs(dist_rpd(1,i)-dist_rpd(1,i+1)) < 0.0001  && ( abs(dist_f(1,i)-dist_f(1,i+1)) < 1000  ||    abs(dist_af(1,i)-dist_af(1,i+1)) < 1200 )              
                 rep1{k,1} = i;
                 rep1{k,2} = j;
                 k=k+1; flag=1;
%             elseif dtw(mm{1,i},mm{1,j}) < 9 && dtw(plp2{1,i},plp2{1,j}) < 10
%                 rep2{l,1} = i;
%                 rep2{l,2} = j;
%                 l=l+1; flag2=1;
            end
            if i+2 > length(seg)
                break;
            end
         end

    end    
        if flag == 1
        flag=0;
        disp('confirm repetition');
        disp(rep1);
        end
disp("done");
    rmpath 'C:\Users\KHOMESH\Desktop\New folder\rastamat'
    clear dist_mfcc;clear dist_plp;clear rep1;clear seg;%C:\Users\KHOMESH\Desktop\project\audio\Arthur\Repetitions\Arthur
end
