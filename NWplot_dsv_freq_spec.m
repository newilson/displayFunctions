GRY = dsv2timecourse;
GRY = single(GRY);
GRT = 10.0*1e-6; % 10 us->s
BW = single(1/GRT);
% time = uint16(GRT*(0:length(GRX)-1));
% freq = linspace(single(0),BW,length(GRY));
ind = round(length(GRY)/2);
GRYspec = abs(fft(GRY(1:ind)));

freq = linspace(single(0),BW,ind);
dispind = round(2000/freq(end)*ind); % display index
figure, plot(freq(1:dispind),GRYspec(1:dispind))
title('GRY')
load('TerraForbiddenFreq.mat');
line(forbfreq1,[0 0],'color','red','linewidth',2);
line(forbfreq2,[0 0],'color','red','linewidth',2);