%% EE 107: Communication Systems, Fall 2017 - Final Project
clear all, close all
%% Image Pre-processing (from hw7)
qbits = 8;  % quantization bits
[Ztres,r,c,m,n,minval,maxval]=ImagePreProcess_gray('image_example.png',qbits);
% m is image number of rows 
% n is image number of columns
% minval, maxval to reverse linear scaling

%% Conversion to bit stream
% Transmit DCT blocks in groups of size N
N = m*n/64; %number of blocks to group together

% Convert to 3D array to the bitstream
stream = convertToBitStream(Ztres, N);

% Plot the frequency and time of the half sine and SRRC

% Half sine
T = 1;
numSamples = 32;
t = linspace(0,T,numSamples);
pulse_HS = sin(t*pi/T);

% Square root raised cosine
a = 0.5; % Roll off
K = 2; % Truncation Factor
t2 = linspace(-K*T,K*T,2*numSamples*K); % New time vector
x = SRRC_x(a,t2,T); % x vals for SRRC
A = sqrt(sum(pulse_HS.^2)/sum(x.^2)); % Amplitude correction factor
pulse_SRRC = A*x; % SRRC pulse

%% Q1 Plot the pulse shaping functions and their frequency responses
figure
plot(t,pulse_HS);
title('Half Sine Wave vs Time')
xlabel('time(s)')
ylabel('Half Sine Wave')

figure
freqz(pulse_HS);
title('Half Sine Wave Frequency Response')

figure
plot(t2,pulse_SRRC);
title('SRRC vs Time')
xlabel('time(s)')
ylabel('SRRC')

figure
freqz(pulse_SRRC);
title('SRRC Frequency Response')

%% Q2&Q3 Modulate a 10-bit random vector of bits with both pulses
% Plot modulated signals and their frequency responses
b = round(rand(10,1));

PS_HS = bitStreamModulation(pulse_HS,b,t,1,K);
PS_SRRC = bitStreamModulation(pulse_SRRC,b,t2,0,K);

figure
t3 = linspace(0,length(b)*T,length(PS_HS));
plot(t3, PS_HS)
title('Half Sine Modulated Bit Stream')
ylabel('Modulated Signal')
xlabel('Time')

figure
freqz(PS_HS)
title('Frequency Response of Half Sine Modulated Bit Stream')

figure
t4 = linspace(-K*T,length(b)*T + K*T, length(PS_SRRC));
plot(t4, PS_SRRC);
title('SRRC Modulated Bit Stream')
ylabel('Modulated Signal')
xlabel('Time')

figure
freqz(PS_SRRC);
title('Frequency Response of SRRC Modulated Bit Stream')

%% Q4 Plot the transmit eye diagram for both pulses

% eye diagram for half sine modulated signal
eyediagram(PS_HS,numSamples-1,T,numSamples/2)
title('Eye diagram for half sine modulated signal')

eyediagram(PS_SRRC,(numSamples*(2*K)),T,K*T)

%% Channel
space = zeros(numSamples-1, 1);
h = [1 space 1/2 space 3/4 space -2/7];