% eegplugin_individualerd() - Plugin to compute the individual ERD of a 
%                         specific electrode. This function is called by 
%                         EEGLAB at startup to create a menu.
%
% Usage:
%   >> eegplugin_individualerd(fig, trystrs, catchstrs);
%
% Inputs:
%   fig            - [integer] eeglab figure.
%   try_strings    - [struct] "try" strings for menu callbacks.
%   catch_strings  - [struct] "catch" strings for menu callbacks.
%
% Authors: Madalena Valente

function vers = eegplugin_individualerd(fig, try_strings, catch_strings)

vers = 'iERD1.0'; % name of your plugin and version
if nargin < 3
    error('eegplugin_individualerd requires 3 arguments');
end

% add plugin folder to path
% -----------------------
if exist('pop_individual_erd.m','file')
    p = which('eegplugin_individualerd');
    p = p(1:strfind(p,'eegplugin_individualerd.m')-1);
    addpath(p);    
end

% find plot menu handle
plotmenu = findobj(fig,'tag','plot');

% ersp/erd + plot commands
cmd = '[individual_erd, times, individual_freq] = pop_individual_erd(EEG);';
cmd = [cmd 'plot_erd(EEG,times,mean(individual_erd,1));'];

% we create the menu below
uimenu( plotmenu, 'Label', 'Plot ERD', 'separator','on','tag',...
    'individualerd','CallBack', cmd);


