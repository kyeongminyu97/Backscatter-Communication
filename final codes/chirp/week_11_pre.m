%% parameter settings
% select signal type:
% 1: chirp, 2: random binary
s_type = 1;
filt_op= 0;
filt_op_mf= 1; %filter option for 2nd filter: 0- none, 1:remove all higher order, 2:remove 2nd harmonic

%params for chirp: comment out to run simulation:
CS = 1;        %signal Chirp sign: '+1' for up-chirp and '-1' for 'down-chirp'
CS_mf= -1; %matched filter chirp sign: down or up chirp 



%common parameters:
BW  = 250e3;     %Bandwidth, [Hz]
offset=3e6; %offset
fs = 6.5e7 ;  
snr=10;
f_1_order= 4; 
f_2_order= 10; % for higher harmoinic removal
tf = 1e-4;      %Pulse duration, [s].
Fc = 1e9;      %Carrier Frequency, [Hz].

%% main function 
[x,x_mf,t,t2,NoS,f2,f1,f1_mf,f2_mf]=gen_signal(s_type,tf,offset,BW,CS,CS_mf,fs);
%plot_chirp(t,x)
%plot_chirp(t,x_mf)
%plot_spec_zoom(x_mf,fs);

%% lpf 1
x_f= filt_1(x,f_1_order,f1,f2,fs,CS);
x_mf_f=filt_1(x_mf,f_1_order,f1_mf,f2_mf,fs,CS_mf);
%plot_lpf_1(t,x,x_f);
%plot_spec_zoom(x_mf,fs);
%% filter 2 removes higher order harmonics
x_ff= filt_2(filt_op,x_f,f_2_order,f1,f2,BW,fs,CS);
x_mf_ff= filt_2(filt_op_mf,x_mf_f,f_2_order,f1_mf,f2_mf,BW,fs,CS_mf);
%plot_lpf_1(t,x,x_ff);
%plot_spec(x_mf_ff,fs);
%%
%produce signal copy for filter coeff:
down_mf=x_mf_ff
%%

save('saved_chirp_2_half_harmonics','down_mf')
%%
function [x,x_mf,t,t2,NoS,f2,f1,f1_mf,f2_mf]=gen_signal(s_type,tf,offset,BW,CS,CS_mf,fs)
if s_type == 1  
    if CS==1   
        f1=offset;
        f2=offset+BW;
        Ts = 1/fs;      %Sampling Time, [s].
        t = 0:1/fs:tf-1/fs; 
        t2 = 0:1/fs:tf*3-1/fs; %for zero padding
        NoS = length(t);
        %make chirp
        x = chirp(t,f1,tf,f2);
        x=sign(x);
    elseif CS==-1
        f2=offset;
        f1= offset+BW;
        Ts = 1/fs;      %Sampling Time, [s].
        t = 0:1/fs:tf-1/fs; 
        t2 = 0:1/fs:tf*3-1/fs; %for zero padding
        NoS = length(t);
        %make chirp
        x = chirp(t,f1,tf,f2);
        x=sign(x);
    end
    if CS_mf==1
        f1_mf=offset;
        f2_mf=offset+BW;
        Ts = 1/fs;      %Sampling Time, [s].
        t = 0:1/fs:tf-1/fs; 
        t2 = 0:1/fs:tf*3-1/fs; %for zero padding
        NoS = length(t);
        %make chirp
        x_mf = chirp(t,f1_mf,tf,f2_mf);
        x_mf=sign(x_mf);
    elseif CS_mf==-1
        f2_mf=offset;
        f1_mf= offset+BW;
        Ts = 1/fs;      %Sampling Time, [s].
        t = 0:1/fs:tf-1/fs; 
        t2 = 0:1/fs:tf*3-1/fs; %for zero padding
        NoS = length(t);
        %make chirp
        x_mf = chirp(t,f1_mf,tf,f2_mf);
        x_mf=sign(x_mf);
    end

elseif s_type == 2 
    if CS==CS_mf
        f2= offset+BW;
        f1=f2;
        f1_mf=f1;
        f2_mf=f2;
        t = 0:1/fs:tf-1/fs; 
        T=1/f2;%cycle period/bit rate
        num_cyc=tf/T; %number of cycles/bits
        t2 = 0:1/fs:tf*3-1/fs;
        NoS = length(t);
        sq=square(2*pi*f2*t);% create square wave from -1 to 1

        A=randi([0 1],1,num_cyc);%random 0 1 amplitude

        A1=repelem(A,(NoS/num_cyc));%extend A to match bit cycle size
        x=(2*abs(A1.*sq))-1;%change from 0->1 to -1->1
        x_mf=x;
    elseif CS~=CS_mf
        f2= offset+BW;
        f1=f2;
        f1_mf=f1;
        f2_mf=f2;
        t = 0:1/fs:tf-1/fs; 
        T=1/f2;%cycle period/bit rate
        num_cyc=tf/T; %number of cycles/bits
        t2 = 0:1/fs:tf*3-1/fs;
        NoS = length(t);
        sq=square(2*pi*f2*t);% create square wave from -1 to 1

        A=randi([0 1],1,num_cyc);%random 0 1 amplitude

        A1=repelem(A,(NoS/num_cyc));%extend A to match bit cycle size
        x=(2*abs(A1.*sq))-1;%change from 0->1 to -1->1
        x_mf= x*-1;

    end
end
end

function y=filt_1(x,f_1_order,f1,f2,fs,CS)
if CS==1 
    d= designfilt('lowpassfir','FilterOrder',f_1_order, 'CutoffFrequency',f2,'SampleRate', fs);
    y= filtfilt(d, x); %filtfilt removes phase
elseif CS==-1 
d= designfilt('lowpassfir','FilterOrder',f_1_order, 'CutoffFrequency',f1,'SampleRate', fs);
y= filtfilt(d, x); %filtfilt removes phase
%y= detrend(y); % center at zero
end
end

function y=filt_2(filt_op,x,f_2_order,f1,f2,BW,fs,CS)
if filt_op == 0 %no filter
    y=x;
elseif filt_op ==1 % remove all harmonics
    if CS==1 
        d= designfilt('bandpassfir','FilterOrder',f_2_order, 'CutoffFrequency1',f1,'CutoffFrequency2',f2+BW,'SampleRate', fs);
        y= filtfilt(d, x); 
    elseif CS==-1 
        d= designfilt('bandpassfir','FilterOrder',f_2_order, 'CutoffFrequency1',f2,'CutoffFrequency2',f1+BW,'SampleRate', fs);
        y= filtfilt(d, x); 
    end
elseif filt_op ==2 % remove second harmonic
    d= designfilt('bandstopfir','FilterOrder',f_2_order, 'CutoffFrequency1',f1*2,'CutoffFrequency2',f1*3,'SampleRate', fs);
    y= filtfilt(d, x); 
end
end

function plot_chirp(t,x)
figure
plot(t,x)
axis([0 1e-5 -1.2 1.2])
xlabel('Time (sec)')
ylabel('Amplitude')
end

function plot_lpf_1(t,x,x_lpf)
figure
plot(t,x) ;
axis([0 1e-5 -1.2 1.2])
xlabel('Time (sec)')
ylabel('Amplitude')
hold on;
plot(t,x_lpf) ;
end

function plot_spec(x,fs)
figure
pspectrum(x,fs,'spectrogram', 'Leakage',0,...
    'MinThreshold',-50, 'FrequencyLimits',[-20E6, 20E6],'FrequencyResolution',0.8e6)
end

function plot_spec_zoom(x,fs)
figure
    pspectrum(x,fs,'spectrogram', 'Leakage',0,...
    'MinThreshold',-7, 'FrequencyLimits',[2.8E6, 3.4E6],'FrequencyResolution',0.2e6)

end


function plot_mf_output(t2,y,snr,s_type)
figure
    if s_type==1
        plot(t2,y);
        xlabel('Time (sec)')
        ylabel('abs(output)')
        title(['SNR=',num2str(snr)])
    elseif s_type==2
        plot(t2,y);
        xlabel('Time (sec)')
        ylabel('output')
    end

end

function plot_all(t2,x,x_noise,y,snr)
figure
subplot(3,1,1);
plot(t2,x); 
subplot(3,1,2);
plot(t2,x_noise); 
subplot(3,1,3);
plot(t2,y);
xlabel('Time (sec)')
ylabel('output')
title(['SNR=',num2str(snr)])
end