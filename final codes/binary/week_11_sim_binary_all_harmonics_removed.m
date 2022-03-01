load('saved_binary_harmonics_removed')

n_sim=5000
num_inter=10
start_snr=-23
results=zeros(1,num_inter);
snr_results= linspace(-23.1,-24,num_inter);
error_index=zeros(1,n_sim); 
for i=1:num_inter
    snr=start_snr-(0.1*i)
    for c = 1:n_sim 
        [x_noise, x_padded]= add_noise(x_ff,NoS,snr);
        [max_y,min_y]=mf_apply(up_mf,x_noise); 
        error_index(c)=sign(abs(max_y)-abs(min_y));
    end


num_error=length(find(error_index<0));
BER= num_error/n_sim;
results(i)=BER
end
save('bin_results_harmonics_all','results','snr_results')
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

function [max_y,min_y]=mf_apply(x,x_noise)
x_mf=conj(fliplr(x));%time reversed conj complex copy of signal, conj not necessarily needed for real x
y=filter(x_mf,1,x_noise);%pass the noisy signal to the filter, gives output

[max_y,ind]=max(y);%x and y coordinates of max output
[min_y,ind2]=min(y);
end

function plot_spec_zoom(x,fs)
figure
    pspectrum(x,fs,'spectrogram', 'Leakage',0,...
    'MinThreshold',-7, 'FrequencyLimits',[2.8E6, 3.4E6],'FrequencyResolution',0.2e6)

end

