
port = "COM10";
baud = 115200;
nSamples = 4000;
s = serialport(port,baud);
configureTerminator(s,"CR");
flush(s);


data = nan(nSamples, 1);

for k = 1:nSamples
    line = readline(s);           % blocks until a full line arrives
    data(k) = str2double(line);
  end

clear s                   % closes the port
plot(data); xlabel('Sample'); ylabel('ADC value');

save("test3.mat", "data")