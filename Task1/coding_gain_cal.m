BER_E2_QPSK_soft = [    0.1883    0.1139    0.0520    0.0183    0.0049    0.0010    0.0002    0         0         0];
BER_E2_QPSK_hard = [    0.2873    0.2264    0.1578    0.0940    0.0449    0.0163    0.0043    0.0010    0.0002    0];
uncoded_BER      = [    0.1036    0.0785    0.0564    0.0377    0.0238    0.0125    0.0059    0.0024    0.0008    0.0002];

[unique_soft, idx_soft] = unique(BER_E2_QPSK_soft, 'stable');
[unique_hard, idx_hard] = unique(BER_E2_QPSK_hard, 'stable');
[unique_uncoded, idx_uncoded] = unique(uncoded_BER, 'stable');

EbN0_soft_valid = EbN0(idx_soft);
EbN0_hard_valid = EbN0(idx_hard);
EbN0_uncoded_valid = EbN0(idx_uncoded);

% Check EbN0 in BER=1e-4
target_BER = 1e-4;
EbN0_soft_interp = interp1(unique_soft, EbN0_soft_valid, target_BER, 'linear', 'extrap');
EbN0_hard_interp = interp1(unique_hard, EbN0_hard_valid, target_BER, 'linear', 'extrap');
EbN0_uncoded_interp = interp1(unique_uncoded, EbN0_uncoded_valid, target_BER, 'linear', 'extrap');

% Calculate coding gain
coding_gain_soft = EbN0_uncoded_interp - EbN0_soft_interp;
coding_gain_hard = EbN0_uncoded_interp - EbN0_hard_interp;

fprintf('Soft Decoding Coding Gain: %.2f dB\n', coding_gain_soft);
fprintf('Hard Decoding Coding Gain: %.2f dB\n', coding_gain_hard);