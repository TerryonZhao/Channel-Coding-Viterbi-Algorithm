% Data for BERs and uncoded BERs
BPSK_uncoded = [0.1052    0.0794    0.0564    0.0384    0.0223    0.0120    0.0057    0.0025    0.0007    0.0002];
QPSK_uncoded = [0.1045    0.0776    0.0569    0.0377    0.0226    0.0121    0.0062    0.0027    0.0007    0.0002];
AMPM_uncoded = [0.1994    0.1697    0.1392    0.1081    0.0799    0.0549    0.0348    0.0190    0.0098    0.0038];

BER_E3_BPSK = [0.2243    0.1269    0.0492    0.0129    0.0020    0.0003    0.0000         0         0         0];
BER_E3_QPSK = [0.2042    0.1130    0.0390    0.0091    0.0013    0.0002    0.0000         0         0         0];
BER_E4_AMPM = [0.2161    0.1754    0.1288    0.0776    0.0321    0.0103    0.0018    0.0002    0.0000    0.0000];

% Ensure uniqueness for interpolation
[unique_BPSK, idx_BPSK] = unique(BER_E3_BPSK, 'stable');
[unique_QPSK, idx_QPSK] = unique(BER_E3_QPSK, 'stable');
[unique_AMPM, idx_AMPM] = unique(BER_E4_AMPM, 'stable');

[unique_uncoded_BPSK, idx_uncoded_BPSK] = unique(BPSK_uncoded, 'stable');
[unique_uncoded_QPSK, idx_uncoded_QPSK] = unique(QPSK_uncoded, 'stable');
[unique_uncoded_AMPM, idx_uncoded_AMPM] = unique(AMPM_uncoded, 'stable');

EbN0 = -1:8; % Example Eb/N0 values

EbN0_BPSK = EbN0(idx_BPSK);
EbN0_QPSK = EbN0(idx_QPSK);
EbN0_AMPM = EbN0(idx_AMPM);

EbN0_uncoded_BPSK = EbN0(idx_uncoded_BPSK);
EbN0_uncoded_QPSK = EbN0(idx_uncoded_QPSK);
EbN0_uncoded_AMPM = EbN0(idx_uncoded_AMPM);

% Target BER for comparison
target_BER = 1e-4;

% Interpolation to find corresponding Eb/N0
EbN0_BPSK_interp = interp1(unique_BPSK, EbN0_BPSK, target_BER, 'linear', 'extrap')
EbN0_QPSK_interp = interp1(unique_QPSK, EbN0_QPSK, target_BER, 'linear', 'extrap')
EbN0_AMPM_interp = interp1(unique_AMPM, EbN0_AMPM, target_BER, 'linear', 'extrap')

EbN0_uncoded_BPSK_interp = interp1(unique_uncoded_BPSK, EbN0_uncoded_BPSK, target_BER, 'linear', 'extrap')
EbN0_uncoded_QPSK_interp = interp1(unique_uncoded_QPSK, EbN0_uncoded_QPSK, target_BER, 'linear', 'extrap')
EbN0_uncoded_AMPM_interp = interp1(unique_uncoded_AMPM, EbN0_uncoded_AMPM, target_BER, 'linear', 'extrap')
