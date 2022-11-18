function responseParsed = parseResponse(response)
    %% Manipulate Response data into boolean for Callback UI Updates
%     disp(response)
    responseParsed.FUEL_Press = tern(response.FUEL_Press, '49', 'CLOSED', '48', 'OPEN');
    responseParsed.FUEL_Purge = tern(response.FUEL_Purge, '49', 'CLOSED', '48', 'OPEN');
    responseParsed.FUEL_Vent  = tern(response.FUEL_Vent, '49', 'OPEN', '48', 'CLOSED');
    responseParsed.LOX_Press  = tern(response.LOX_Press, '49', 'CLOSED', '48', 'OPEN');
    responseParsed.LOX_Purge  = tern(response.LOX_Purge, '49', 'CLOSED', '48', 'OPEN');
    responseParsed.LOX_Vent   = tern(response.LOX_Vent, '49', 'OPEN', '48', 'CLOSED');
    responseParsed.MAIN       = tern(response.MAIN, '49', 'CLOSED', '48', 'OPEN');
    responseParsed.IGNITE     = tern(response.IGNITE, '49', 'FIRING', '48','OFF');
    responseParsed.WATER_Flow = tern(response.WATER_Flow, '49', 'CLOSED', '48', 'OPEN');
%     disp(responseParsed)
end