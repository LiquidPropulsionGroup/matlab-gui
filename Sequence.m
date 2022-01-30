classdef Sequence
    %SEQUENCE Summary of this class goes here
    %   import json sequence
    %   implement matlab.timer to run sequence (hold able)
    %   write json state -> State object
    %   execute State.post()
    
    
    properties
        sequence; % struct containing imported json
    end
    
    methods
        function obj = Sequence(import_json)
            %SEQUENCE Construct an instance of this class
            
            obj.sequence = jsondecode(import_json)
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

