clc 
close all
clear all
r=0.1:0.1:10;
r=r.';
Lw=50e-12;
A=2.9;
Qtheta=1;
Lp=(10*log10((Qtheta/(4*pi*(r.^2)))+(4/A)))
% Sampling

f=length(Lp);
r=0.1:0.1:10; %distance

% Plotting the Distance vs SPL data
figure;
plot(r,Lp, 'b', 'LineWidth', 1); 	

title('Distance vs Sound Pressure Level');
xlabel('Distance (metres)' );
ylabel('Sound Pressure Level (dB)');

% Plotting Sampled Signal
figure;
stem(Lp); 	

title('SAMPLED SIGNAL');
xlabel('Distance (metres)');
ylabel('Sound Pressure Level (dB)');

% Modulation done Using PCM
% Quantization
n1=8;                                                 % Number of bits used in Quantization and Modulation
L=2^n1;                                               % Defining number of Quantizatonion Levels
xmax=7;                                               % Maximum Value of the population data
xmin=0;                                               % Minimum Value of the population data
del=(xmax-xmin)/L;                                    % Initialising the delta step value based on the Quantization Levels
partition=xmin:del:xmax;                              % Defining decision lines
codebook=xmin-(del/2):del:xmax+(del/2);               % Defining representation levels
[index,quants]=quantiz(Lp,partition,codebook);        % gives rounded off values of the samples

% Plotting the Quanized Data
figure;
stem(quants);

title('QUANTIZED SIGNAL');
xlabel('Distance (metres)');
ylabel('Sound Pressure Level (dB)');


l1=length(index);     			                     % to convert 1 to n as 0 to n-1 indices
for i=1:l1
    if (index(i)~=0)
        index(i)=index(i)-1;
    end
end
l2=length(quants);
for i=1:l2 			                                 %  to convert the end representation levels within the range.
    if(quants(i)==xmin-(del/2))
        quants(i)=xmin+(del/2);
    end
    if(quants(i)==xmax+(del/2))
        quants(i)=xmax-(del/2);
    end
end

%  Encoding
Code=de2bi(index,'left-msb'); 	                     % Decimal to Binanry Conversion of Indicies
k=1;
for i=1:l1                                           % Converting column vector to row vector
    for j=1:n1
        Encoded_Data(k)=Code(i,j);
        j=j+1;
        k=k+1;
    end
    i=i+1;
end

% Plotting Digital Signal
figure;
stairs(Encoded_Data);

title('DIGITAL SIGNAL');
xlabel('Distance (metres)');
ylabel('Sound Pressure Level (dB)');
axis([0 200 -0.1 1.1])

% Demodulation
code1=reshape(Encoded_Data,n1,(length(Encoded_Data)/n1));
index1=bi2de(code1,'left-msb');
resignal=del*index+xmin+(del/2);

% Plotting Demodulated Signal
figure;
plot(resignal);

title('DEMODULATAED SIGNAL');
xlabel('Distance (metres)');
ylabel('Sound Pressure Level (dB)');