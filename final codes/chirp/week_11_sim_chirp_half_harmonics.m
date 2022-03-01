%signal has harmonics, mf has removed harmnics
load('saved_chirp_half_harmonics')
load('saved_chirp_2_half_harmonics')

n_sim=300
num_inter=10
start_snr=-19.6
results=zeros(1,num_inter)
snr_results= linspace(-19.7,-20.6,num_inter);
for i=1:num_inter
    snr=start_snr-(0.1*i)
    correct_vals=zeros(1,n_sim); %'vals' is where i will store each val
    wrong_vals=zeros(1,n_sim);
    for c = 1:n_sim %store each val in correct_vals
        [x_noise, x_padded]= add_noise(x_ff,NoS,snr);
        [filter,y,val,ind]=mf_apply(up_mf,x_noise); 
        correct_vals(c)=val;
        [filter2,y2,val2,ind2]=mf_apply(down_mf,x_noise);
        wrong_vals(c)=val2;
    end
    
    error_index=sign(correct_vals-wrong_vals);
    num_error=length(find(error_index<0));
    BER= num_error/n_sim;
    results(i)=BER;
    save('chirp_results_half_harmonics','results','snr_results')
end
%%
figure
plot(snr_results,results)
title(['num simulation=',num2str(n_sim)])
xlabel('SNR (dB)')
ylabel('BER')
%%

function [x_noise,x_padded] =add_noise(x,NoS,snr)
x_padded=zeros(1,NoS*3);% pulse embedded in blank signal
x_padded(NoS+1:NoS+length(x))=x;%zero-padded x
%add noise
x_noise=awgn(x_padded,snr);
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

function [x_mf,y,max_abs_y,ind]=mf_apply(x,x_noise)
x_mf=conj(fliplr(x));%time reversed conj complex copy of signal, conj not necessarily needed for real x
y=filter(x_mf,1,x_noise);%pass the noisy signal to the filter, gives output
y=abs(y);
[max_abs_y,ind]=max(y);%x and y coordinates of max output
end

function plot_spec_zoom(x,fs)
figure
    pspectrum(x,fs,'spectrogram', 'Leakage',0,...
    'MinThreshold',-7, 'FrequencyLimits',[2.8E6, 3.4E6],'FrequencyResolution',0.2e6)

end
