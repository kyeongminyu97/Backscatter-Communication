# Backscatter-Communication
Masters Research at Universtiy of Cambridge Engineering Department

Exploration of different coding schemes (DS-SS/CSS) and harmonic content using backscatter technique, aiming to maximise RF communincation range

- Driven driven by recent advancements in consumer electronics such as 5G technologies, and the demand for research on IoT communication systems is growing. Existing active radio technologies are known to provide reliable long ranges but consume a lot of power. 
- Backscatter communications (BackCom) which relies on passive reflection and modulation of incident RF waves is often effective in addressing this energy efficiency problem. However, backscatter systems are known to be limited to short transmission ranges. 

- In this project, two investigations were conducted to improve the communication range of backscatter.
- In the first part of the project, noise reduction schemes were applied to limit the phase noise created by the Local oscillator (LO) which is a dominant range-limiting factor in backscatter systems. The two methods investigated via spreadsheet modelling are: Range Correlation Effect (RCE) and Harmonic Backscatter. It was found that RCE outperforms Harmonic Backscatter by almost doubling the achievable communication range at a typical minimum receiver SNR required of 6dB.
- Chirp-Spread spectrum (CSS) and Direct-sequence Spread spectrum (DS-SS) are widely used Spread-spectrum modulation techniques in radio technologies which is known to be resistive to interference and noise in detection. These spread-spectrum techniques are also known to easily enable multi-user access with good security. CSS uses modulation using a linear chirp which increases continually in frequency over a specified bandwidth. DS-SS uses a long pseudo-random binary sequence to encode each symbol. By Exploiting backscatter in employing these two modulation schemes, signal architectures can be simplified, and power consumptions can be lowered. In the second part of the project, these two backscatter coding schemes were simulated using MATLAB, and their performances were compared. It was found that the DS-SS backscatter coding scheme outperformed CSS by an increase in communication range by a factor of 1.12, which is considered significant given difficulty in increasing the range in backscatter systems.
<img width="500" alt="Screenshot 2022-03-24 at 22 18 02" src="https://user-images.githubusercontent.com/71874390/160041582-d493af81-4ff6-4210-a7e4-8d778090f96d.png">
<img width="500" alt="Screenshot 2022-03-24 at 22 17 53" src="https://user-images.githubusercontent.com/71874390/160041636-c8d297c7-49d4-48c9-b880-6865b5fc4ce6.png">

-To investigate the effect of filtering out the higher order harmonic content in the modulated signals created by rapid backscatter switching, a low-pass filter was implemented at the receiver. The effect of filtering the harmonic content was evaluated for both coding schemes. It was found that for both coding schemes, filtering out the harmonic content improved BER performance compared to systems simulated with signals which contained higher order harmonics. The DS-SS backscatter system had a higher susceptibility to harmonics, as the effect of filtering was more significant than in CSS backscatter. For DS-SS, a decrease in almost 2dB SNR (for the same BER of 10#$) was achieved by filtering, which amounts to a significant improvement in communication range.
<img width="500" alt="Screenshot 2022-03-24 at 22 17 10" src="https://user-images.githubusercontent.com/71874390/160041680-fea96eaf-a5ab-49c0-bd81-6795901c06f1.png">



-An ultimate backscatter communication design was proposed combining the architectures found optimal in both parts of the project. A pseudo-random binary sequence encoded backscatter system, which exploits RCE is presented. An approximate achievable range of 280m was calculated using the combined design.
