%% JSON WRITER FOR ROCKET COMMAND SEQUENCING
% Prompt user to fill fields for state commands until done entering

% There are 3 fields, one of which contains 7 sub-fields
% { <numID>: {
%       "Name": <name>,
%       "Duration": <duration>,
%       "State": {
%            "FUEL_Press": <bool>,
%            "LOX_Press": <bool>,
%            "FUEL_Vent": <bool>,
%            "LOX_Vent": <bool>,
%            "MAIN": <bool>,
%            "FUEL_Purge": <bool>,
%            "LOX_Purge": <bool>
%       }
%  }, ...

% CurrentSequenceStep
clc, clear

% Start the loop
ID = [];
loopControl = true;
n = 1;
FullSequence = [];
while loopControl == true
    % Prompts the user
    fprintf("Creating a new state in the sequence...\nYou may discard at end of entry...\n")
    % Ask for the state name
    CurrentSequenceStep.Name = input( ...
        "State name? :", "s" );
    % Ask for the state duration
    CurrentSequenceStep.Duration = input ( ...
        "State duration? :", "s" );
    % Ask for FUEL_Press desired state
    state = '';
    while ~any(strcmp(state,{'OPEN','open','CLOSED','closed'}))
        prompt = fprintf("FUEL_Press is? ('OPEN'/'open'/'CLOSED'/'closed') :");
        state = input ( "", "s" );
        CurrentSequenceStep.State.FUEL_Press = state;
        if ~strcmp(state,{'OPEN','open','CLOSED','closed'})
            fprintf(repmat('\b', 1, (prompt+length(state)+1)));
        end
    end
    % Ask for LOX_Press desired state
    state = '';
    while ~any(strcmp(state,{'OPEN','open','CLOSED','closed'}))
        prompt = fprintf("LOX_Press is? ('OPEN'/'open'/'CLOSED'/'closed') :");
        state = input ( "", "s" );
        CurrentSequenceStep.State.LOX_Press = state;
        if ~strcmp(state,{'OPEN','open','CLOSED','closed'})
            fprintf(repmat('\b', 1, (prompt+length(state)+1)));
        end
    end
    % Ask for FUEL_Vent desired state
    state = '';
    while ~any(strcmp(state,{'OPEN','open','CLOSED','closed'}))
        prompt = fprintf("FUEL_Vent is? ('OPEN'/'open'/'CLOSED'/'closed') :");
        state = input ( "", "s" );
        CurrentSequenceStep.State.FUEL_Vent = state;
        if ~strcmp(state,{'OPEN','open','CLOSED','closed'})
            fprintf(repmat('\b', 1, (prompt+length(state)+1)));
        end
    end
    % Ask for LOX_Vent desired state
    state = '';
    while ~any(strcmp(state,{'OPEN','open','CLOSED','closed'}))
        prompt = fprintf("LOX_Vent is? ('OPEN'/'open'/'CLOSED'/'closed') :");
        state = input ( "", "s" );
        CurrentSequenceStep.State.LOX_Vent = state;
        if ~strcmp(state,{'OPEN','open','CLOSED','closed'})
            fprintf(repmat('\b', 1, (prompt+length(state)+1)));
        end
    end
    % Ask for MAIN desired state
    state = '';
    while ~any(strcmp(state,{'OPEN','open','CLOSED','closed'}))
        prompt = fprintf("MAIN is? ('OPEN'/'open'/'CLOSED'/'closed') :");
        state = input ( "", "s" );
        CurrentSequenceStep.State.MAIN = state;
        if ~any(strcmp(state,{'OPEN','open','CLOSED','closed'}))
            fprintf(repmat('\b', 1, (prompt+length(state)+1)));
        end
    end
    % Ask for FUEL_Purge desired state
    state = '';
    while ~any(strcmp(state,{'OPEN','open','CLOSED','closed'}))
        prompt = fprintf("FUEL_Purge is? ('OPEN'/'open'/'CLOSED'/'closed') :");
        state = input ( "", "s" );
        CurrentSequenceStep.State.FUEL_Purge = state;
        if ~any(strcmp(state,{'OPEN','open','CLOSED','closed'}))
            fprintf(repmat('\b', 1, (prompt+length(state)+1)));
        end
    end
    % Ask for LOX_Purge desired state
    state = '';
    while ~any(strcmp(state,{'OPEN','open','CLOSED','closed'}))
        prompt = fprintf("LOX_Purge is? ('OPEN'/'open'/'CLOSED'/'closed') :");
        state = input ( "", "s" );
        CurrentSequenceStep.State.LOX_Purge = state;
        if ~any(strcmp(state,{'OPEN','open','CLOSED','closed'}))
            fprintf(repmat('\b', 1, (prompt+length(state)+1)));
        end
    end
    
    % Build the struct
    ID = [ID sprintf("x%d",n)];
    FullSequence = [FullSequence CurrentSequenceStep];
    n = n + 1;
    
    % Ask if finished
    request = '';
    while ~any(strcmp(request,{'Y','y','N','n'}))
        prompt = fprintf("Make another entry in the sequence? ('Y'/'y'/'N'/'n') :");
        request = input ( "", "s" );
        if ~any(strcmp(request,{'Y','y','N','n'}))
            fprintf(repmat('\b',1, (prompt+length(request)+1)));
        end
    end
    % If done, break the loop
    if any(strcmp(request,{'N','n'}))
        disp('Breaking...')
        loopControl = false;
    else
        disp('Loop')
    end
    
end

% Convert the entries from strings to the proper types 
for j = 1:length(ID)
    % Fix duration string to int
    FullSequence(j).Duration = str2double(FullSequence(j).Duration);
    % Fix the state strings to booleans
    if any(strcmp(FullSequence(j).State.FUEL_Press,{'OPEN','open'}))
        FullSequence(j).State.FUEL_Press = true;
    else
        FullSequence(j).State.FUEL_Press = false;
    end
    if any(strcmp(FullSequence(j).State.LOX_Press,{'OPEN','open'}))
        FullSequence(j).State.LOX_Press = true;
    else
        FullSequence(j).State.LOX_Press = false;
    end
    if any(strcmp(FullSequence(j).State.FUEL_Vent,{'CLOSED','closed'}))
        FullSequence(j).State.FUEL_Vent = true;
    else
        FullSequence(j).State.FUEL_Vent = false;
    end
    if any(strcmp(FullSequence(j).State.LOX_Vent,{'CLOSED','closed'}))
        FullSequence(j).State.LOX_Vent = true;
    else
        FullSequence(j).State.LOX_Vent = false;
    end
    if any(strcmp(FullSequence(j).State.MAIN,{'OPEN','open'}))
        FullSequence(j).State.MAIN = true;
    else
        FullSequence(j).State.MAIN = false;
    end
    if any(strcmp(FullSequence(j).State.FUEL_Purge,{'OPEN','open'}))
        FullSequence(j).State.FUEL_Purge = true;
    else
        FullSequence(j).State.FUEL_Purge = false;
    end
    if any(strcmp(FullSequence(j).State.LOX_Purge,{'OPEN','open'}))
        FullSequence(j).State.LOX_Purge = true;
    else
        FullSequence(j).State.LOX_Purge = false;
    end
end

% Label each state
for k = 1:length(ID)
    % TFW Dynamic variables is the only reasonable answer
    LabelSequence.(ID(k)) = FullSequence(k);
end

json = jsonencode(LabelSequence, PrettyPrint=true);
disp(json)

fileName = input("Save filename as:","s");
fid = fopen(fileName, 'w');
fprintf(fid,json);
