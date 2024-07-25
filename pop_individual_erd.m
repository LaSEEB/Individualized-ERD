% pop_individual_erd() - Returns the individual ERD (Event-related
%                      Desynchronization) values, for a specific channel, 
%                      and the frequency band it chose for this computation.
%
% Usage:
%   >> pop_individual_erd(EEG); % pop up window asking users to select the
%                                 inputs
%   >> pop_individual_erd(EEG, electrode, frequency_band, wave_cycles); 
%                                   % does not pop up a window
%
% Inputs:
%  EEG - EEGLAB dataset
% 
% Optional inputs:
%  'electrode'      - [edit box] number of the electrode/channel to perform 
%                   ersp computation and individual erd selection.
%  'frequency_band' - [edit box] extended (alpha/beta) band, corresponding 
%                   to the frequency area where the algorithm analyses and 
%                   choses the individual erd.
%  'wave_cycles'    - [edit box] indicates the number of cycles for the 
%                   time-frequency decomposition {default: 0}
%                   If 0, use FFTs and Hanning window tapering.  
%                   If [real positive scalar], the number of cycles in each 
%                       Morlet wavelet, held constant across frequencies.
%                   If [cycles cycles(2)] wavelet cycles increase with 
%                       frequency beginning at cycles(1) and, if cycles(2) > 1, 
%                       increasing to cycles(2) at the upper frequency.
%                   If cycles(2) = 0, use same window size for all frequencies 
%                       (similar to FFT when cycles(1) = 1).
%                   If cycles(2) = 1, cycles do not increase (same as giving
%                        only one value for 'cycles'). This corresponds to 
%                        a pure wavelet decomposition, same number of cycles
%                        at each frequency.
%                    If 0 < cycles(2) < 1, cycles increase linearly with 
%                        frequency: from 0 --> FFT (same window width at 
%                        all frequencies) to 1 --> wavelet (same number of 
%                        cycles at all frequencies).
%                    The exact number of cycles in the highest frequency 
%                    window is indicated in the command line output. 
%                    Typical value: 'cycles', [3 0.5]
%
% Output:
%  'inidividual_erd'    - erd values across time, and frequency (in %).
%  'times'              - vector of time values, correspondent to the erd 
%                       matrix
%  'freq_range'         - frequency band chosen.
%
% Author: Madalena Valente
%
% Example:
%   pop_individual_erd(EEG); % pop up window asking users to select the
%                            electrode and frequency band for the analysis.
%   pop_individual_erd(EEG, 'electrode', 8, 'frequency_band', [6 14],
%                      'wave_cycles', 0); % does not pop up a window


function [individual_erd, times, freq_range] = pop_individual_erd(EEG,...
   electrode, frequency_band, wave_cycles)

% if only one argument is provided, this means that the function is being
% called from an EEGLAB menu
if nargin < 4
    % obtain user inputs
    cb_electrode = ['if get(gcbo, ''value''), ' ...
        'set(findobj(gcbf, ''userdata'', ''electrode''),''enable'', ''on'');' ...
        ' else set(findobj(gcbf, ''userdata'', ''electrode''),''enable'',' ...
        ' ''off'',''value'', 0); end'];

    cb_freq_band = ['if get(gcbo, ''value''), set(findobj(gcbf, ''userdata'',' ...
        ' ''frequency_band''),''enable'', ''on''); else set(findobj(gcbf,' ...
        ' ''userdata'', ''frequency_band''),''enable'', ''off'', ''value'', 0); end'];

    cb_wave_cycles = ['if get(gcbo, ''value''), set(findobj(gcbf, ''userdata'',' ...
        ' ''wave_cycles''),''enable'', ''on''); else set(findobj(gcbf,' ...
        ' ''userdata'', ''wave_cycles''),''enable'', ''off'', ''value'', 0); end'];

    % allow user to select the 
    geometry = { [1 0.3] [1 0.3] [1 0.3]};
    uilist = { ...
      { 'Style', 'text', 'string', 'Channel number', 'fontweight', 'bold'  } ...
      { 'Style', 'edit', 'string', '1' 'tag' 'electrode','callback',cb_electrode} ...
      ...
      { 'Style', 'text', 'string', 'Frequency band (Hz)', 'fontweight', 'bold' } ...
      { 'Style', 'edit', 'string', ' ' 'tag' 'frequency_band','callback',cb_freq_band  } ...
      ...
      { 'Style', 'text', 'string', 'Wavelet cycles [min max/fact] or sequence', ...
        'fontweight', 'bold' } ...
      { 'Style', 'edit', 'string', '3 0.5' 'tag' 'wave_cycles','callback',...
        'wave_cycles', 'callback', cb_wave_cycles } ...
      };

      [~,~,~,outs] = inputgui( 'geometry',geometry, 'uilist', uilist, ...
           'helpcom', 'pophelp(''pop_individual_erd'')','title', 'Individual ERD');

      electrode = str2num(outs.electrode);
      frequency_band = str2num(outs.frequency_band);
      wave_cycles =  str2num(outs.wave_cycles);
      
% else
    % electrode = varargin{'electrode'};
    % frequency_band = varargin{'frequency_band'};
    % wave_cycles = varargin{'wave_cycles'};

end

% Compute ersp
[ersp, ~, ~, times, frequencies] = newtimef( EEG.data(electrode,:,:), EEG.pnts,...
        [EEG.xmin EEG.xmax]*1000, EEG.srate, wave_cycles , 'elocs', EEG.chanlocs,...
        'chaninfo', EEG.chaninfo,'baseline',0, 'freqs', [1 40], 'plotersp',...
        'off', 'plotitc' , 'off', 'plotphase', 'off', 'padratio', 1);
% for help on this part see the newtimef help message

% Calculate the individual frequency band
erd_each_fwindow = [];
freqs = [];
time = find(times(:,:)>0);
for f=frequency_band(1):0.5:frequency_band(2)-1
    finish = false;
    for l = 1:0.5:abs(frequency_band(2)-frequency_band(1))
        freq_min = f;
        if f + l == frequency_band(2)
            freq_max = frequency_band(2);
            finish = true;
        else
            freq_max = f + l;
        end
        freq_range = [freq_min freq_max];

        freq = find(frequencies(:,:)>=freq_range(1) & ...
            frequencies(:,:)<=freq_range(2));
        if length(freq) == 1
            erd = ersp(freq,time);
        else
            erd = mean(ersp(freq,time));
        end

        erd_each_fwindow = [erd_each_fwindow; erd];
        freqs = [freqs; freq_range];
        if finish == true
            break;
        end
    end
end

mean_erd = mean(erd_each_fwindow,2);
[~, indx] = min(mean_erd);
freq_range = freqs(indx,:);

% Individual ERD
individual_freq = find(frequencies(:,:)>=freq_range(1) & ...
            frequencies(:,:)<=freq_range(2));
individual_ersp = ersp(individual_freq,:);

% transform the values from dB to percentage
individual_erd = (10.^(individual_ersp/10)-1)*100;
end
