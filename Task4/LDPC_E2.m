% Simulation Options
N = 1e5;
EbN0 = 0:0.25:2.5; 
maxNumErrs = 100;
maxNum = 1e6;

% First simulate System 2 (E2 with QPSK)
fprintf('Simulating E2 system...\n');
idx_enc = 2;    % E2 encoder
idx_mod = 1;    % QPSK
idx_rec = 2;    % soft receiver
BER_E2 = zeros(1, length(EbN0));

for i = 1:length(EbN0)
    fprintf('E2: Processing Eb/N0 = %.2f dB\n', EbN0(i));
    totErr = 0;
    num = 0;

    while((totErr < maxNumErrs) && (num < maxNum))
        bits = randsrc(1,N,[0 1]);
        [bits_enc, x_soft] = encoder(bits, idx_enc);
        symb = mapper(bits_enc, idx_mod);
        y = awgn_test(symb, EbN0(i), idx_enc, idx_mod);
        bits_dec = soft_new(y, x_soft, idx_enc, idx_mod);
        
        bitErr = sum(bits_dec ~= bits);
        totErr = totErr + bitErr;
        num = num + N;
    end

    BER_E2(i) = totErr/num;
    fprintf('E2: BER = %.2e\n', BER_E2(i));
end

% Now simulate LDPC system
fprintf('\nSimulating LDPC system...\n');
BER_ldpc = simulate_ldpc_system(N, EbN0);

% Plot results with improved formatting
figure;
semilogy(EbN0, BER_E2, '-d', 'DisplayName', 'E2 with QPSK (Soft)');
hold on;
semilogy(EbN0, BER_ldpc, '-s', 'DisplayName', 'LDPC with QPSK', 'Color', [0.850, 0.325, 0.098]);
grid on;
xlabel('Eb/N0 [dB]');
ylabel('BER');
%title('Performance Comparison of E2 and LDPC Systems', 'FontSize', 14);
legend('show');
ylim([1e-6 1]);

t = text(2, 0.5, {'LDPC Parameters:', ...
                '• Rate: 1/2', ...
                '• Length: 64800 bits', ...
                '• DVB-S.2 Standard'}, ...
     'FontSize', 9, ...
     'BackgroundColor', [1 1 1 0.8], ...  
     'EdgeColor', 'k', ...                 
     'Margin', 3, ...                      
     'VerticalAlignment', 'bottom', ...
     'HorizontalAlignment', 'left');

plotedit on;  

fprintf('\nSimulation complete!\n');
fprintf('Minimum BER achieved - E2: %.2e, LDPC: %.2e\n', min(BER_E2), min(BER_ldpc));