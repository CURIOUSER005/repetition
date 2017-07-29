 function C = REnergy(y,Fs)
%[y,Fs,bits]=wavread('C:\Users\KHOMESH\Desktop\New folder\sample audio\New folder\M_0077_11y2m_1nr5.wav');
%[y,Fs,bits]=wavread('C:\Users\KHOMESH\Desktop\test\onlyrep\HariQ3_15_haudu.wav');
Frame_size = 25;
%Frame_size = 30;
%Frame_size = 50;
%Frame_size = 100;

Frame_shift = 10;
%Frame_shift = Frame_size/2;
Frame_Size = Frame_size/1000;
Frame_Shift = Frame_shift/1000;

%Compute length of Audio Signal
t=(1/Fs:1/Fs:(length(y)/Fs));
%t_1 = [0:length(y)-1]/Fs;

%Plot a waveform of Audio Signal  
% subplot(2,1,1);
% plot(t,y); axis tight;
% title('Input Signal');
% xlabel('Time (s)');
% ylabel('Amplitude (dB)');

%Compute Window Length and Sample Shift of Signal Frame
window_length = Frame_Size*Fs;
sample_shift = Frame_Shift*Fs;

%Window Length
%w = rectwin(window_length);
w = hamming(window_length);
%w = hann(window_length);
%w = hanning(window_length);

Total_Frames = floor(length(y)/sample_shift);
No_of_Sample_Shift_per_Frame = ceil(window_length/sample_shift);
c = Total_Frames -No_of_Sample_Shift_per_Frame;
jj = 1;
Sum = 0; Energy = 0;

for i=1:c-1;
    for j= ((i-1)*sample_shift+1):((i-1)*sample_shift+window_length)
        y1 = y(j)*w(jj);
        ++jj;
        yy = y1*y1;
        Sum = Sum + yy;
    end;
    Energy(i) = Sum;
    jj=1; Sum = 0;  
end;

%w = 0;
C = Energy;
delay = (window_length - 1)/2;
% M = t(delay+1:end - delay);
% plot(t(delay+1:end - delay), C);

tt = 1/Fs:(Frame_shift/1000):(length(Energy)*(Frame_shift/1000));

padval = 0;
figure();
plot(tt,C); axis tight;
title('Input Signal');
xlabel('Time (s)');
ylabel('Amplitude (dB)');

 end
