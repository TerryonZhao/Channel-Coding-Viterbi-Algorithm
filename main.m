% Simulation Options
N = 1e5;
EbN0 = -1:8;
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated
BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results

idx_enc = 1;    %0: uncoded;
idx_mod = 1;    %0: BPSK; 1: QPSK; 2: AMPM
idx_rec = 1;    %0: uncoded; 1: hard; 2: soft

%-------------------------------------------------------------
% Comment this line if using soft receiver:
trellis = build_trellis(idx_enc);
%-------------------------------------------------------------

for i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
  totErr = 0;  % Number of errors observed
  num = 0; % Number of bits processed

  while((totErr < maxNumErrs) && (num < maxNum))
  % [SRC] generate N information bits 
  bits = randsrc(1,N,[0 1]);

  % [ENC] convolutional encoder
  [bits_enc, x_soft] = encoder(bits, idx_enc);

  % [MOD] symbol mapper
  symb = mapper(bits_enc, idx_mod);

  % [CHA] add Gaussian noise
  y = awgn(symb, EbN0(i), idx_enc, idx_mod);

  % Demapper(not used by soft receiver)
  if idx_rec == 0 || idx_rec == 1
      y_bar = demapper(y, idx_mod);
  elseif idx_rec == 2   %Soft rec doesn't need remapping
      y_bar = y;
  end

  % [HR] Hard Receiver & [SR] Soft Receiver
  if idx_rec == 0
      bits_dec = y_bar;  %uncoded
  elseif idx_rec == 1
      bits_dec = hard_decoder(y_bar, trellis);
      
      % matlab toolbox
      %bits_dec = vitdec(y_bar, trellis, 35, 'trunc', 'hard'); 
  elseif idx_rec == 2
      bits_dec = soft_new(y_bar, x_soft, idx_enc, idx_mod);
  end

  bitErr = sum(bits_dec ~= bits);
  totErr = totErr + bitErr;
  num = num + N;

  end

  BER(i) = totErr/num;

end


% Figure
% Fetch uncoded BER here
uncoded_BER = get_uncoded_BER(N, EbN0, idx_mod);
% Plot the theoretical BER
BER_theory = qfunc(sqrt(2*10.^(EbN0./10))); % Uncoded, QPSK

% Plot the BER for the given modulation, encoder and recevier ( Hard, Soft or Uncoded) 
semilogy(EbN0, BER, '-xb');
hold on;
semilogy(EbN0, BER_theory, '-r');
hold on;
semilogy(EbN0, uncoded_BER, 'or');

xlabel('Eb/N0 [dB]');
ylabel('BER');
grid on;
title('BER versus Eb/N0');
legend('Coded', 'Theoretical(QPSK)','Uncoded');
ylim([1e-4 1])

disp(BER);
disp(uncoded_BER);