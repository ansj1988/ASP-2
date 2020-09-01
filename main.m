% Minimizing jamming effects over GSM-R communications
% Developed by: Artur Nogueira de São José
% Graduate Program in Electrical Engineering - UFMG, Brazil

% Technique: ASP-2
% Current status: under review by a Ph.D. jury

% If you use this code, please cite this paper:

%  @INPROCEEDINGS{9163653,
%  author={A. N. d. S. {José} and V. {Deniau} and Ú. d. C. {Resende} and R. {Adriano}},
%  booktitle={2019 23rd International Conference on Applied Electromagnetics and Communications (ICECOM)}, 
%  title={Mitigating Intentional Electromagnetic Interferences over the GSM-R System with Adaptive Filters}, 
%  year={2019},
%  volume={},
%  number={},
%  pages={1-6},}

%% Step 1: initial configuration

clear
close all
clc

% Example of input signals
% signal: GSM-R burst corrupted by a jamming signal
% noise1 and noise2: two typical waveforms of jamming signals
% time: vector with time samples
load('iemi_gsmr2.mat')

% Initializing variables
copies = 10;             % Number of signal replicas for further data reuse
stepsize = 0.001;        % NLMS filter parameter
order = 20;              % NLMS filter parameter
N_seg = 500;             % Number of segments taken from the signals
L_seg = length(signal)/N_seg; % Length of each segment

%% Step 2: filtering process

% With this loop, small segments of the signals are filtered and
% concatenated in the time domain
for i=1:N_seg
    x = signal(i*L_seg-(L_seg-1):i*L_seg);        % Segment of the signal with length = L_seg
    y = circshift(x',1e6)';                       % Noise sample obtained by shifting the noisy GSM-R signal
    [x,y] = data_reuse(x,y,copies);               % Making replicas of the signal
    erro = nlms_evaluation(x,y,order,stepsize);   % Filtering the signal
    z(i*10000-9999:i*10000) = erro(end-9999:end); % Creating an output vector
end

%% Step 3: graphs

fft_size = length(z);

figure
hold on
plot(linspace(0,fft_size-1,fft_size).*(1/(fft_size*(time(2)-time(1)))),20*log10(abs(fft(d,fft_size))),'r')
plot(linspace(0,fft_size-1,fft_size).*(1/(fft_size*(time(2)-time(1)))),20*log10(abs(fft(z,fft_size))))
xlim([0.7e9 1e9])
hold off

