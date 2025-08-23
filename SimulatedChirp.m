%% connect to serial port, only needs to be done once after the arduino is programmed

s=serialport('/dev/cu.usbmodem141101',2000000)  %check command window, make sure baud rate is correct
%% run this section once reset button on arduino has been pressed

flush(s)    %clear the serial port receiving the data
q=read(s,41377,'uint8');  %read the data, 43194 samples for a sampling duration of 1 second
%% 
dc=127; %DC offset
p=q-dc; %using the DC offset to bring the samples around 0 and then to normalize the samples
p=p./dc; %originally the DC offset was 507, but we had to convert to an 8 bit number to maximize the serial baud rate

%% simulation using cross-correlation theory
sr = 50000;
cl=0.5; %chirplength in seconds
sf=500; %start frequency of the chirp
ef=10000; %end frequency of the chirp
t=0:1/(sr-1):1; %time we are listening for the chirp
f=(t.^2*(ef-sf)/cl/2)+(t.*sf); %frequency linearly increasing (frequency is the derivative of this wrt t)
ref=sin(f.*2*pi); %reference chirp signal
ref(1001:sr)=0; %setting the rest of the reference signal to 0, because our t is a total of 1 sec, but our chirp is only 0.5 sec
sig=zeros(1,sr);

% Define a delay in seconds
delta_t = 0.01;  % 10 ms delay
delta_samples = round(delta_t * sr);

% Shift ref by delta_samples and add noise
sig = zeros(size(ref));
if delta_samples < length(ref)
    sig(delta_samples+1:end) = ref(1:end-delta_samples);
end

% Add Gaussian noise
noise_level = 0.05;  % adjust amplitude of noise
sig = sig + noise_level * randn(size(sig));

% Now you can continue with your cross-correlation
X = fft(ref);
Y = fft(sig);
Z = Y .* conj(X);
z = ifft(Z);

% Time vector for correlation (same as t)
t_corr = t;

% Plot everything together
figure;
subplot(3,1,1)
plot(t(1:4000), ref(1:4000))
xlabel('Time (s)')
ylabel('Amplitude')
title('Reference Chirp')

subplot(3,1,2)
plot(t(1:4000), sig(1:4000))
xlabel('Time (s)')
ylabel('Amplitude')
title('Delayed & Noisy Signal')

subplot(3,1,3)
plot(t_corr(1:4000), abs(z(1:4000)))  % absolute value for clarity
xlabel('Time (s)')
ylabel('Correlation')
title('Cross-correlation Result')
%% 

tt=0:1/(sr-1):199/(sr-1);
l=zeros(1,1000);
l(:,1:200)=sin(1500*2*pi*tt);
figure
plot(l)
title('ref')

w=zeros(1,1000);
w(:,201:400)=p(:,101:300);
figure
plot(w);
title('sampled')

X=fft(l);
Y=fft(w);
Z=Y.*conj(X); %always use the conjugate of the reference signal fft
z=ifft(Z);
figure
plot(z)
%% 
plot(p(:,1:100))
%% 
mean(q)

