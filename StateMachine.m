classdef StateMachine < matlab.DiscreteEventSystem
    properties
        FUEL_Press;
        LOX_Press;
        FUEL_Vent;
        LOX_Vent;
        MAIN;
        FUEL_Purge;
        LOX_Purge;
        IGNITE;
        LOXLVL;
        WATER_Flow;
        ip;
        sequence;
        timers;
        n;
        KeyList;
        app;
    end
    
    methods
        % Default constructor
        function obj = StateMachine(app)
            obj.FUEL_Press = false;
            obj.LOX_Press = false;
            obj.FUEL_Vent = true;
            obj.LOX_Vent = true;
            obj.MAIN = false;
            obj.FUEL_Purge = false;
            obj.LOX_Purge = false;
            obj.IGNITE = false;
            obj.LOXLVL = 0;
            obj.WATER_Flow = false;
            
            obj.n = 1;
            
            obj.KeyList = {
                    'FUEL_Press',
                    'LOX_Press',
                    'FUEL_Vent',
                    'LOX_Vent',
                    'MAIN',
                    'FUEL_Purge',
                    'LOX_Purge',
                    'IGNITE',
                    'WATER_Flow'
                };

            obj.app = app;
            % debug parse
%             parseSequence(obj, "sequence.json")
%             tic
%             start(obj.timers(1))
            
        end
        
        function out = stateToMessage(obj)
           
            A = [   obj.FUEL_Press;
                    obj.LOX_Press;
                    obj.FUEL_Vent;
                    obj.LOX_Vent;
                    obj.MAIN;
                    obj.FUEL_Purge;
                    obj.LOX_Purge;
                    obj.IGNITE;
                    obj.WATER_Flow;
                ];
            
            out = jsonencode(containers.Map(obj.KeyList,A));
%             disp(out)
            
        end
        
        function responseParsed = poll(obj)
            % Request a valve status update from the stand
            url = strcat('http://',obj.ip,':3003/serial/valve/update');
            options = weboptions;
            options.RequestMethod = 'get';
            options.Timeout = 1;
            try
                response = webread(url,options);
                responseParsed = parseResponse(response);
%                 disp(response)
            catch ME
%                 disp(ME)
                if (strcmp(ME.identifier,'MATLAB:webservices:Timeout')) 
                    disp('=== TIMEOUT ON VALVE POLL ===')
                end
            end
            
        end
        
        % Deprecated
        function responseParsed = pollLOX(obj)
            % Request a LOXLVL value update from the stand
            % Enable auxiliary data collection
%             url = strcat('http://',obj.ip,'3004')
%             disp('polling LOX...')
            url = strcat('http://',obj.ip,':3004/serial/auxdata/update');
            options = weboptions;
            options.RequestMethod = 'get';
            options.Timeout = 1;
            try
                response = webread(url,options);
%                 disp('WEBREAD RESPONSE:')
%                 disp(response)
                responseParsed = response.LOXLVL;
%                 disp('EXTRACTED VALUE:')
%                 disp(responseParsed)
            catch ME
                disp(ME)
                if (strcmp(ME.identifier,'MATLAB:webservices:Timeout')) 
                    disp('=== TIMEOUT ON LOXLVL POLL ===')
                end
            end
        end

        function responseParsed = post(obj)
            % Post a valve state to the stand
            url = strcat('http://',obj.ip,':3003/serial/valve/update');
            options = weboptions;
            options.Timeout = 1;
            disp(stateToMessage(obj))
            try
                response = webwrite(url, stateToMessage(obj));
                responseParsed = parseResponse(response);
            catch ME
%                 disp(ME)
                if (strcmp(ME.identifier,'MATLAB:webservices:ConnectionRefused'))
                    disp('=== POST REFUSED ===')
                elseif (strcmp(ME.identifier,'MATLAB:webservices:Timeout')) 
                    disp('=== POST TIMEOUT ===')
                end
            end
        end
        
        function parseSequence(obj, list)
           
            file = fopen(list, 'r');
%             jsonObj = char(fread(file));
            jsonObj = fread(file,'*char');
            obj.sequence = jsondecode(jsonObj');
%             disp(obj.sequence)
            fclose(file);
            
            % create timer array
            obj.n = 1;
            
            % parse the durations and names
            sequenceDurations = [];
            sequenceNames = {};
            struct_names = fieldnames(obj.sequence);
%             disp(struct_names)
%             disp(length(struct_names))
            
            for i = 1:length(struct_names)
                sequenceDurations(i) = getfield(obj.sequence, struct_names{i}).Duration;
                sequenceNames{i} = getfield(obj.sequence, struct_names{i}).Name;
            end
%             disp(sequenceDurations)
%             disp(sequenceNames)

            % generate timers
            obj.timers = timer.empty(length(sequenceDurations),0);
            for i = 1:length(sequenceDurations)
                
%                 disp(i)
%                 A = sprintf('obj.timerReadPost({%d})', i)
                obj.timers(i) = timer( ...
                    'Tag','StandInstruction', ...
                    'Name', sequenceNames{i}, ...
                    'ExecutionMode', 'singleShot', ...
                    'StartDelay', sequenceDurations(i));
                obj.timers(i).StartFcn = @(~,~)obj.timerReadPost;
                obj.timers(i).TimerFcn = @(~,~)obj.timerNext;
            end
            
        end
        
        % executes event
        function timerReadPost(obj)
%             disp(num2str(i))
            % Mark the previous node as expired
            try
                obj.app.colorizeTreeNode(obj.n-1,'expired')
            catch ME
                % Do nothing
            end
            % Mark the current node as running
            obj.app.colorizeTreeNode(obj.n,'running')
            % Mark the next node as waiting
            try
                obj.app.colorizeTreeNode(obj.n+1,'waiting')
            catch ME
                % Do nothing
            end

            tic
            struct_names = fieldnames(obj.sequence);
            state = getfield(obj.sequence, struct_names{obj.n}).State;
            
            obj.FUEL_Press = getfield(state, obj.KeyList{1});
            obj.LOX_Press = getfield(state, obj.KeyList{2});
            obj.FUEL_Vent = getfield(state, obj.KeyList{3});
            obj.LOX_Vent = getfield(state, obj.KeyList{4});
            obj.MAIN = getfield(state, obj.KeyList{5});
            obj.FUEL_Purge = getfield(state, obj.KeyList{6});
            obj.LOX_Purge = getfield(state, obj.KeyList{7}); % weird fix
            obj.IGNITE = getfield(state, obj.KeyList{8});
            obj.WATER_Flow = getfield(state, obj.KeyList{9});
            
            obj.post();
            
        end
        
        function timerNext(obj)
            toc;
            obj.n = obj.n+1;
            
%             start(obj.timers(obj.n));
%             MException.last
            
            try
                start(obj.timers(obj.n));
            catch ME
                if strcmp( ME.identifier, "MATLAB:badsubscript")
%                     disp(ME.identifier);
                    stop(obj.timers);
                    delete(obj.timers);
                    disp("Done");
                else
                    disp("Different Error");
                    rethrow( ME );
                end 
            end
           % start(obj.timers(obj.n)); 
        end  
        
        function stopTimer(obj)
            stop(obj.timers);
            disp("Timer Stopped. Next timer:");
            disp(obj.n);
        end

        function abortTimer(obj)
            disp("ABORTING . . .")
            TimerTempArray = timerfind('Tag','StandInstruction');
%             disp('Before delete:')
%             disp('timer temp array:')
%             disp(TimerTempArray)
%             disp('timer findall array:')
%             disp(timerfindall)
%             disp('timer obj array:')
%             disp(obj.timers)
            if (~isempty(TimerTempArray))
                stop(TimerTempArray);
                disp("TIMERS ABORTED");
%                 disp(obj.n);
                for j = 1:length(obj.timers)
                    obj.app.colorizeTreeNode(j,'aborted');
                end
                delete(TimerTempArray)
                disp("TIMERS DELETED")
            else
                disp("NO TIMERS IN MEMORY")
            end
%             disp('After delete:')
%             disp('timer temp array:')
%             disp(TimerTempArray)
%             disp('timer findall array:')
%             disp(timerfindall)
%             disp('timer obj array:')
%             disp(obj.timers)
        end
        
        function responseParsed = safe(obj)
            disp("SAFING SYSTEM . . .")
            % hardcode safe state (same as constructor)
            obj.FUEL_Press = false;
            obj.LOX_Press = false;
            obj.FUEL_Vent = false;
            obj.LOX_Vent = false;
            obj.MAIN = false;
            obj.FUEL_Purge = false;
            obj.LOX_Purge = false;
            obj.IGNITE = false;
            obj.WATER_Flow = false;
            
%             stop(obj.timers);
%             delete(obj.timers);
            responseParsed = obj.post();
        end
    end
end