function result = tern(input, conditionOne, exprIfOne, conditionTwo, exprIfTwo)
    %% Error-catching ternary operator function
    % IF input matches conditionOne, return exprIfTrue
    % ELIF input matches conditionTwo, return exprIfFalse
    % ELSE throw an error
%     disp(input)
%     disp(conditionOne)
%     disp(conditionTwo)
    if ( input == conditionOne )
%         disp("Match cond 1")
        result = exprIfOne;
    elseif ( input == conditionTwo )
%         disp("Match cond 2")
        result = exprIfTwo;
    else
        ME = MException('tern:nonMatchingInput', ...
            'Input "%d" does not match either conditions', input);
        throw(ME)
    end
%     disp(result)
end