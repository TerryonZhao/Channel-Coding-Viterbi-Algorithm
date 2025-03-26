% Simulation Options
N = 1e5;
EbN0 = -1:8;
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated

% pre-allocate a vector for BER results
BER_E1 = zeros(1, length(EbN0));
BER_E2 = zeros(1, length(EbN0));
BER_E3 = zeros(1, length(EbN0));

trellis1 = trellis_ub(1);    % E1
trellis2 = trellis_ub(2);    % E2
trellis3 = trellis_ub(3);    % E3

% Get theoretical bounds with sufficient terms
spec1 = distspec(trellis1, 10);
spec2 = distspec(trellis2, 10);
spec3 = distspec(trellis3, 10);

ub1 = calculate_bound(spec1, EbN0);
ub2 = calculate_bound(spec2, EbN0);
ub3 = calculate_bound(spec3, EbN0);

idx_mod = 1;    %0: BPSK; 1: QPSK; 2: AMPM
idx_rec = 2;    %0: uncoded; 1: hard; 2: soft

for i = 1:length(EbN0) 
  idx_enc = 1;  
  totErr = 0; 
  num = 0;

  while((totErr < maxNumErrs) && (num < maxNum))
  
  bits = randsrc(1,N,[0 1]);
  [bits_enc, x_soft] = encoder(bits, idx_enc);
  symb = mapper(bits_enc, idx_mod);
  y = awgn(symb, EbN0(i), idx_enc, idx_mod);
  if idx_rec == 0 || idx_rec == 1
      y_bar = demapper(y, idx_mod);
  elseif idx_rec == 2
      y_bar = y;
  end


  bits_dec = soft_new(y_bar, x_soft, idx_enc, idx_mod);


  bitErr = sum(bits_dec ~= bits);
  totErr = totErr + bitErr;
  num = num + N;

  end

  BER_E1(i) = totErr/num;

end

for i = 1:length(EbN0) 
  idx_enc = 2;  
  totErr = 0; 
  num = 0;

  while((totErr < maxNumErrs) && (num < maxNum))
  
  bits = randsrc(1,N,[0 1]);
  [bits_enc, x_soft] = encoder(bits, idx_enc);
  symb = mapper(bits_enc, idx_mod);
  y = awgn(symb, EbN0(i), idx_enc, idx_mod);
  if idx_rec == 0 || idx_rec == 1
      y_bar = demapper(y, idx_mod);
  elseif idx_rec == 2
      y_bar = y;
  end


  bits_dec = soft_new(y_bar, x_soft, idx_enc, idx_mod);


  bitErr = sum(bits_dec ~= bits);
  totErr = totErr + bitErr;
  num = num + N;

  end

  BER_E2(i) = totErr/num;

end

for i = 1:length(EbN0) 
  idx_enc = 3;  
  totErr = 0; 
  num = 0;

  while((totErr < maxNumErrs) && (num < maxNum))
  
  bits = randsrc(1,N,[0 1]);
  [bits_enc, x_soft] = encoder(bits, idx_enc);
  symb = mapper(bits_enc, idx_mod);
  y = awgn(symb, EbN0(i), idx_enc, idx_mod);
  if idx_rec == 0 || idx_rec == 1
      y_bar = demapper(y, idx_mod);
  elseif idx_rec == 2
      y_bar = y;
  end


  bits_dec = soft_new(y_bar, x_soft, idx_enc, idx_mod);


  bitErr = sum(bits_dec ~= bits);
  totErr = totErr + bitErr;
  num = num + N;

  end

  BER_E3(i) = totErr/num;

end

% Figure
figure;
uncoded_BER = get_uncoded_BER(N, EbN0, idx_mod);
%BER_theory = qfunc(sqrt(2*10.^(EbN0./10))); % Uncoded, QPSK

semilogy(EbN0, ub1, '--', 'DisplayName', 'E1 Upperbound', 'Color', [0.466, 0.674, 0.188] );
hold on;
semilogy(EbN0, ub2, '--', 'DisplayName', 'E2 Upperbound', 'Color', [0.850, 0.325, 0.098] );
semilogy(EbN0, ub3, '--', 'DisplayName', 'E3 Upperbound', 'Color', [0.929, 0.694, 0.125] );
semilogy(EbN0, BER_E1, '-s', 'DisplayName', 'E1 Simulation', 'Color', [0.466, 0.674, 0.188]);
semilogy(EbN0, BER_E2, '-s', 'DisplayName', 'E2 Simulation', 'Color', [0.850, 0.325, 0.098]);
semilogy(EbN0, BER_E3, '-s', 'DisplayName', 'E3 Simulation', 'Color', [0.929, 0.694, 0.125]);
semilogy(EbN0, uncoded_BER, '-d', 'DisplayName', 'Uncoded', 'Color', [0, 0, 0] );

xlabel('EbN0 [dB])');
ylabel('BER');
title('BER versus Eb/N0');
grid on;
legend('show');
ylim([1e-4 1]);
