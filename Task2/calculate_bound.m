function bound = calculate_bound(spec, EbN0)
    % Convert Eb/N0 from dB to linear scale
    EbN0_lin = 10.^(EbN0/10);
    
    % Code rate
    Rc = 1/2;
    
    % Initialize bound array
    bound = zeros(size(EbN0));
    
    % Calculate bound for each Eb/N0 point
    for i = 1:length(EbN0_lin)
        sum = 0;
        for j = 1:length(spec.weight)
            d = spec.dfree + j - 1;  % Distance spectrum
            % Calculate Q function term
            q_term = qfunc(sqrt(2*d*Rc*EbN0_lin(i)));
            % Add term to sum
            sum = sum + spec.weight(j) * q_term;
        end
        
        % Limit the bound to be at most 0.5
        bound(i) = min(0.5, sum);
    end
end
