clc;
close all;
clear all;
% To calculate no. of levels.
n = input('Enter n value for n bit PCM system :');
% To calculate the sampling frequency.
n1=input('Enter frequency n for resampling ( fs = f * f/n ):');
% Calculating no. of level.
L=2^n;
% Read audio file.
[ipfile, F] = audioread(PATHNAME);
% ipfile is the signal matrix, F is the frequency of the audio signal.
% Removing the 2nd channel.
ipfile(:,2) = [];
% Sampling.
sp = resample(ipfile , F , n1);
% sampled at a rate of (F * F/n1), if n1 is too large, then it becomes undersampled, if n1 is too small,
then it becomes oversampled.

% Display the original signal.
figure('Name','Sampling & Quantization','NumberTitle','off');
subplot(3,1,1)
stem(ipfile);
grid on;
title('Original Signal');
ylabel('Amplitude--->');
xlabel('Time--->');

% Display the Sampled Signal.
subplot(3,1,2)
stem(sp);
grid on;
title('Sampled Sinal'); 
ylabel('Amplitude--->'); 
xlabel('Time--->');

% Quantization Process.
vmax=max(sp);
% Vmax shows the maximum amplitude value of the sampled signal.
vmin=min(sp);
del=(vmax-vmin)/L;
% Calculates delta.
part=vmin:del:vmax;
% Levels are between vmin and vmax with a difference of del.

code=vmin-(del/2):del:vmax+(del/2);
% Contains quantized values.
% Quantization process.
[ind,q]=quantiz(sp,part,code);
% ind contain index number and q contain quantized values.
l1=length(ind);
l2=length(q);
for i=1:l1
if(ind(i)~=0) % To make index as binary decimal, so started from 0 to N.
ind(i)=ind(i)-1;
end
i=i+1;
end
for i=1:l2
if(q(i)==vmin-(del/2)) % To make quantize value in between the levels.
q(i)=vmin+(del/2);
end
end
for i=1:l2
if(q(i)==vmax+(del/2)) % To make quantize value in between the levels.
q(i)=vmax-(del/2);
end
end

%Display the Quantized Signal.
subplot(3,1,3);
stem(q);
grid on;
title('Quantized Signal');
ylabel('Amplitude--->');
xlabel('Time--->');
 
%Encoding Process.
figure('Name','Encoding','NumberTitle','off');
% Convert the decimal to binary
code=de2bi(ind,'left-msb');
k=1;
for i=1:l1
for j=1:n
coded(k)=code(i,j); % Convert code matrix into a coded row vector.
j=j+1;
k=k+1;
end
i=i+1;
end

% Display the encoded signal.
subplot(1,1,1);
grid on;
stairs(coded);
axis([0 100 -2 3]);title('Encoded Signal');
ylabel('Amplitude--->');
xlabel('Time--->');
 
%Demodulation Of PCM signal.
qunt = reshape(coded, length(coded)/n, n);
% Getback the index in decimal form.
index = bi2de(qunt, ‘left-msb');
% Getback quantized values.
q=del*index+vmin+(del/2);
%Display Demodulated Signal.
figure('Name','Reconstructed Signal','NumberTitle','off');
subplot(1,1,1);
stem(q);
title('Reconstructed Signal');
ylabel('Amplitude--->');
xlabel('Time--->');
 
%Passing the Demodulated Signal through a Low Pass Filter.
g = lowpass(q, 0.4);
% 0.4*pi radian per sample is the cutoff frequency.
figure('Name','Output Signal','NumberTitle','off');
subplot(1,1,1);
grid on;
plot(g);
title('Output Signal');
ylabel('Amplitude--->');
xlabel('Time--->');
