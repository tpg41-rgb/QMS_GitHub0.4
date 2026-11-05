%sample rate of 1000Hz, sample period of 1ms

samples = 4000;
Fs=1000;
time = (0:numel(data)-1)'/Fs;
Vout_prefilt = data .* (3.3/4095);

f_high = 80;
f_low = 0.01;
N = 4;
Wn = [f_low, f_high] / (Fs / 2);


[b, a] = butter(N, Wn, 'bandpass');
Vout = filter(b,a,Vout_prefilt);


Vout = Vout(:);

thr = 0.3 * max(Vout);                

%locate peaks
[pks, locs] = findpeaks(Vout, Fs, ...
    'MinPeakHeight',   thr, ...
    'MinPeakDistance', 0.25, ...      
    'MinPeakProminence', 0.4*max(Vout));




%detecting where there is contraction or relaxation of muscle using
%hysteresis. 

thrHi = 0.6;
thrLo = 0.3;

state = false(size(Vout));
on = false;
for k = 1:numel(Vout)
    if ~on && Vout(k) > thrHi
        on = true;
    elseif on && Vout(k) < thrLo
        on = false;
    end
    state(k) = on;
end

Vout = Vout(:);  state = state(:);

%shade in areas where contractions occur
d = diff([0; state; 0]);
onsets  = find(d == 1);
offsets = find(d == -1) - 1;

figure; hold on;
yl = [min(Vout) max(Vout)*1.1];

for i = 1:numel(onsets)
    x0 = time(onsets(i));
    x1 = time(offsets(i));
    patch([x0 x1 x1 x0], [yl(1) yl(1) yl(2) yl(2)], 'r', ...
        'FaceAlpha', 0.2, 'EdgeColor', 'none');
end

plot(time, Vout, 'b');
ylim(yl);
xlabel('Time (s)'); ylabel('Voltage (V)');
title('EMG Data showing location of peaks and duration of contractions');
hold on;
plot(locs, pks, 'rv', 'MarkerFaceColor', 'r');