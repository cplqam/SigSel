function [result] = charge_exploration_diferences(file, filtered)
%This function provides the percetaje of the signals selected from files applaying the
%threshold retriction. The same charge should be selected for both file and
%filtered inputs

%INPUT
%file: result of 'charge_exploration.m'
%filtered: result of 'charge_exploration_filtered.m'

%OUTPUT
%result: an array with the percentaje of signals selected after applaying
%the threshold filter at each sample

result = [];
m = file{1,2};
m_f = filtered{1,2};
dif = (m_f/m)*100;
result = dif;
end

