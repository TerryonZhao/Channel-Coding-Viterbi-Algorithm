function symb = mapper(bits, idx_mod)

  switch idx_mod
      case 0 %BPSK

        % BPSK = [-1 1];
        symb = 2*bits-1;


      case 1 %QPSK

        QPSK = [(1 + 1i), (1 - 1i), (-1 +1i), (-1 - 1i)]/sqrt(2); %Normalized energy
        
        %bits = reshape(bits, length(bits)/2 ,2);
        bits = buffer(bits, 2)';
        const_idx = bi2de(bits, 'left-msb')'+1;                    
        symb = QPSK(const_idx);

      case 2 %AMPM
        
        AMPM = [(1 + -1i) (-3 + 3i) (1 +  3i) (-3 - 1i) (3 - 3i) (-1 + 1i) (+3 + 1i) (-1 - 3i)]/sqrt(10);
        % Reshape bits into pairs and calculate symbol indices
        bits = buffer(bits, 3)';
        const_idx = bi2de(bits, 'left-msb')' + 1;                    
        symb = AMPM(const_idx);    

 end
