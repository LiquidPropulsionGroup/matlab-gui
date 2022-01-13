classdef State
    properties
        FUEL_Press;
        LOX_Press;
        FUEL_Vent;
        LOX_Vent;
        MAIN;
        FUEL_Purge;
        LOX_Purge;
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
        
    methods (Static)
        
        function out = stateToMessage()
           
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
        
    end