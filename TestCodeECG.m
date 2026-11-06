clear



%load signal
tic


%cutoff frequencies

Fs = 500; %sampling frequency of signal
N = 4; %filter order

% normalize cutoff frequencies to the Nyquist frequency
Wn = [f_low, f_high] / (Fs / 2);


% Butterworth filter
[b, a] = butter(N, Wn, 'bandpass');

Signal_filtered = filter(b,a,Signal);
Signal_smoothed = movmean(Signal_filtered,50);
RMS_envelope = sqrt(movmean(Signal_filtered.^2,20));
Signal_detrended = detrend(Signal_smoothed);

figure;

% Frequency response
freqz(b,a,2000,Fs);
title('Butterworth Filter Frequency Response');

% Original and filtered signals
figure;
plot(Time, Signal);
hold on;
plot(Time, Signal_filtered);

xlabel('Time (s)');
ylabel('Amplitude');
legend('Original Signal', 'Filtered Signal');
title('Original vs Filtered Signal');
grid on;

figure;
plot(Time, Signal_filtered);
hold on;
plot(Time, Signal_smoothed);
hold on;
%plot(Time,RMS_envelope)
%hold on;
%plot(Time, Signal_detrended);
%hold off;

xlabel('Time (s)');
ylabel('Amplitude');
legend('Filtered Signal', 'Smoothed Signal', 'RMS Envelope');
title('Filtered vs Smoothed Signal');
grid on;


toc