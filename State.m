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
            obj.FUEL_Press = False;
            obj.LOX_Press = False;
            obj.FUEL_Vent = True;
            obj.LOX_Vent = True;
            obj.MAIN = False;
            obj.FUEL_Purge = False;
            obj.LOX_Purge = False;
        end
        
        
        
    end