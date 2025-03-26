function trellis = trellis_ub(idx_enc)
    % BUILD_TRELLIS Creates a trellis structure for convolutional encoders
    %
    % trellis = build_trellis(idx_enc)
    %
    % Input:
    %   idx_enc: Encoder selection
    %            1 - E1: Rate-1/2, G = (1 + D^2, 1 + D + D^2)
    %            2 - E2: Rate-1/2, G = (1 + D^2 + D^3 + D^4, 1 + D^2 + D^3)
    %            3 - E3: Rate-1/2, G = (1 + D^3 + D^4, 1 + D + D^3 + D^4)
    %
    % Output:
    %   trellis: Structure containing trellis information compatible with distspec
    
    switch idx_enc
        case 1 % E1
            numStates = 4;  % 2^2 states
            nextStates = zeros(numStates, 2);
            outputs = zeros(numStates, 2);
            
            for currentState = 0:numStates-1
                for input = 0:1
                    % Get state bits [s1 s2]
                    stateBits = bitget(currentState, 2:-1:1);
                    
                    % Calculate outputs
                    % G1 = 1 + D^2: input + s2
                    % G2 = 1 + D + D^2: input + s1 + s2
                    c1 = mod(input + stateBits(2), 2);
                    c2 = mod(input + stateBits(1) + stateBits(2), 2);
                    output = bi2de([c1 c2], 'left-msb');
                    
                    % Calculate next state [input s1]
                    nextStateBits = [input, stateBits(1)];
                    nextState = bi2de(nextStateBits, 'left-msb');
                    
                    nextStates(currentState+1, input+1) = nextState;
                    outputs(currentState+1, input+1) = output;
                end
            end
            
        case 2 % E2
            numStates = 16; % 2^4 states
            nextStates = zeros(numStates, 2);
            outputs = zeros(numStates, 2);
            
            for currentState = 0:numStates-1
                for input = 0:1
                    % Get state bits [s1 s2 s3 s4]
                    stateBits = bitget(currentState, 4:-1:1);
                    
                    % Calculate outputs exactly as in original code
                    c1 = mod(input + stateBits(2) + stateBits(3) + stateBits(4), 2);
                    c2 = mod(input + stateBits(2) + stateBits(3), 2);
                    output = bi2de([c1 c2], 'left-msb');
                    
                    % Calculate next state [input s1 s2 s3]
                    nextStateBits = [input, stateBits(1:3)];
                    nextState = bi2de(nextStateBits, 'left-msb');
                    
                    nextStates(currentState+1, input+1) = nextState;
                    outputs(currentState+1, input+1) = output;
                end
            end
            
        case 3 % E3
            numStates = 16; % 2^4 states
            nextStates = zeros(numStates, 2);
            outputs = zeros(numStates, 2);
            
            for currentState = 0:numStates-1
                for input = 0:1
                    % Get state bits [s1 s2 s3 s4]
                    stateBits = bitget(currentState, 4:-1:1);
                    
                    % Calculate outputs
                    % G1 = 1 + D^3 + D^4: input + s3 + s4
                    % G2 = 1 + D + D^3 + D^4: input + s1 + s3 + s4
                    c1 = mod(input + stateBits(3) + stateBits(4), 2);
                    c2 = mod(input + stateBits(1) + stateBits(3) + stateBits(4), 2);
                    output = bi2de([c1 c2], 'left-msb');
                    
                    % Calculate next state [input s1 s2 s3]
                    nextStateBits = [input, stateBits(1:3)];
                    nextState = bi2de(nextStateBits, 'left-msb');
                    
                    nextStates(currentState+1, input+1) = nextState;
                    outputs(currentState+1, input+1) = output;
                end
            end
            
        otherwise
            error('Invalid encoder index');
    end
    
    % Create trellis structure
    trellis.numInputSymbols = 2;
    trellis.numOutputSymbols = 4;
    trellis.numStates = numStates;
    trellis.nextStates = nextStates;
    trellis.outputs = outputs;
end