classdef State
    properties
        FUEL_Press;
        LOX_Press;
        FUEL_Vent;
        LOX_Vent;
        MAIN;
        FUEL_Purge;
        LOX_Purge;
        ip;
    end
    
    methods
        % Default constructor
        function obj = State()
            obj.FUEL_Press = false;
            obj.LOX_Press = false;
            obj.FUEL_Vent = true;
            obj.LOX_Vent = true;
            obj.MAIN = false;
            obj.FUEL_Purge = false;
            obj.LOX_Purge = false;
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
            
            out = jsonencode(A);
            
        end
        
        function post(obj)
            
            % message = stateToMessage(obj)
            url = strcat(obj.ip,':3003/serial/valve/update');
            response = webwrite(url, stateToMessage(obj));
            
        end
        
    end