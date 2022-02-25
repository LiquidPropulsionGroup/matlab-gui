classdef StateMachine < matlab.DiscreteEventSystem
    properties
        FUEL_Press;
        LOX_Press;
        FUEL_Vent;
        LOX_Vent;
        MAIN;
        FUEL_Purge;
        LOX_Purge;
        ip;
        sequence;
    end
    
    methods
        % Default constructor
        function obj = StateMachine()
            obj.FUEL_Press = false;
            obj.LOX_Press = false;
            obj.FUEL_Vent = true;
            obj.LOX_Vent = true;
            obj.MAIN = false;
            obj.FUEL_Purge = false;
            obj.LOX_Purge = false;
            
            % debug parse
            % parseSequence(obj, "sequence.json")
        end
        
        function out = stateToMessage(obj)
           
            A = [   obj.FUEL_Press;
                    obj.LOX_Press;
                    obj.FUEL_Vent;
                    obj.LOX_Vent;
                    obj.MAIN;
                    obj.FUEL_Purge;
                    obj.LOX_Purge;
                ];
            
            KeyList = {
                    'FUEL_Press',
                    'LOX_Press',
                    'FUEL_Vent',
                    'LOX_Vent',
                    'MAIN',
                    'FUEL_Purge',
                    'LOX_Purge'
                };
            
            out = jsonencode(containers.Map(KeyList,A));
            disp(out)
            
        end
        
        function post(obj)
            
            % message = stateToMessage(obj)
            url = strcat('http://',obj.ip,':3003/serial/valve/update');
%             url = 'http://httpbin.org/post';
            response = webwrite(url, stateToMessage(obj));
            disp(response)
            
        end
        
        function parseSequence(obj, list)
           
            file = fopen(list, 'r');
            jsonObj = char(fread(file));
            obj.sequence = jsondecode(jsonObj');
            fclose(file);
        end
        
    end
end
