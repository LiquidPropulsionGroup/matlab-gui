clc, clear;
% Grab references to all existing timers
dump = timerfindall
% Delete the old timers
delete(dump)

% Duration of each sequence
SequenceDurations = [2,1,2,1,3];
j = 1;

% % Create one timer per sequence item
% for i = 1:length(SequenceDurations)
%     Timers(i) = timer( ...
%         'ExecutionMode', 'singleShot', ...
%         'StartDelay', SequenceDurations(i), ...
%         'TimerFcn', 'disp(j), tic, start(Timers(j+1)), pause(SequenceDurations(j)), toc, j=j+1;');
%         % Timer fires once
%         % After SequenceDurations(i) seconds
%         % And executes a line of code
% end
% 
% disp([Timers.startdelay])
% 
% % Start the cascade
% start(Timers(j))
% 
% % Execute the timers sequentially
% % for j = 1:length(SequenceDurations)
% %     disp('next timer')
% %     start(Timers(j))
% %     pause(SequenceDurations(j))
% %     len = toc
% %     fprintf('Timer %1.0f fired after %1.0f seconds.\n',j,len)    
% % end

% Timer as a string
% TimerString = sprintf('timer(''ExecutionMode'',''SingleShot'',''StartDelay'',''%1.0f'',''TimerFcn'',''toc, sprintf(''Timer %s fired.\n'',j), j=j+1; stop(SequenceTimer), SequenceTimer.Period=SequenceDurations(j);disp(SequenceTimer.StartDelay), start(SequenceTimer); tic,',SequenceDurations(j),'%1.0f');
% TimerString = sprintf('stop(SequenceTimer), j=j+1,SequenceTimer.Period=SequenceDurations(j),SequenceTimer.StartDelay=SequenceDurations(j),start(SequenceTimer),toc')
% 
% disp(TimerString)
% % Self editing timer
% SequenceTimer = timer( ...
%     'ExecutionMode', 'fixedSpacing', ...
%     'Period', SequenceDurations(j), ...
%     'TasksToExecute', inf, ...
%     'StartDelay', SequenceDurations(j), ...
%     'TimerFcn', TimerString );
% 
% 
% tic
% disp(SequenceDurations)
% disp(j)
% start(SequenceTimer);

% Build all timers first
for i = 1:length(SequenceDurations)
    Timers(i) = timer( ...
        'ExecutionMode', 'singleShot', ...
        'StartDelay', SequenceDurations(i), ...
        'TimerFcn', 'toc, j=j+1, tic, start(Timers(j))');
end

tic
disp(SequenceDurations)
start(Timers(j))




















