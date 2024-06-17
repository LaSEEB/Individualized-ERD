% plot_erd() - Plots the individual ERD vs time.
%
% Usage:
%   >> plot_erd(EEG,times,mean(individual_erd,1));
%
% Inputs:
%  EEG            - EEGLAB dataset
%  times          - time vector, corresponding to the individual_erd
%                   vector.
%  individual_erd - vector of the individual erd values, computed from the
%                   pop_individual_erd function, across time.
% 
% Author: Madalena Valente

function plot_erd(EEG,times,individual_erd)

figure;
plot(times,individual_erd)
xline(0,'--k');
yline(0,'--k');
xlim([EEG.xmin*1000 + 500,EEG.xmax*1000 - 500]); % need to adapt this to any signal 
ylim([-100,100]);
xlabel('Time (ms)');
ylabel('ERD (%)');
title('Individual ERD');