% Neural Network-Based Scheduling for 6G Multi-User Network

% Add src/ to the path relative to this file's own location, not the
% current working directory -- so this runs correctly regardless of where
% MATLAB's cwd happens to be, not just when launched from the project root.
addpath(fullfile(fileparts(mfilename('fullpath')), 'src'));

rng(42); % Set once here (not inside individual functions) so the whole run is reproducible

% Parameters
numUsers = 10;
numTimeSlots = 100;
numTrainingSamples = 1000;
bandwidth = 100e6; % 100 MHz
txPower = 0.1; % 0.1 W
noisePower = 1e-9; % 1 nW

% Simulate channels
channelGains = simulate_channel(numUsers, numTimeSlots);

% Train neural network scheduler
net = train_neural_scheduler(numUsers, numTrainingSamples);

% Round-Robin scheduler
[rrSchedule, rrThroughput, rrEnergy] = round_robin_scheduler(channelGains, bandwidth, txPower, noisePower);

% Neural network scheduler
[nnSchedule, nnThroughput, nnEnergy] = evaluate_schedulers(net, channelGains, bandwidth, txPower, noisePower);

% Compute performance metrics
rrAvgThroughput = mean(rrThroughput);
rrAvgEnergy = mean(rrEnergy);
nnAvgThroughput = mean(nnThroughput);
nnAvgEnergy = mean(nnEnergy);
throughputGain = ((nnAvgThroughput - rrAvgThroughput) / rrAvgThroughput) * 100;
rrThroughputVariance = var(rrThroughput) / 1e12;
nnThroughputVariance = var(nnThroughput) / 1e12;

% Display results
fprintf('Throughput Gain: %.2f%%\n', throughputGain);
fprintf('NN Avg Throughput: %.2f Gbps\n', nnAvgThroughput/1e9);
fprintf('RR Avg Throughput: %.2f Gbps\n', rrAvgThroughput/1e9);
fprintf('Round-Robin Throughput Variance: %.2f (Mbps^2)\n', rrThroughputVariance);
fprintf('Neural Network Throughput Variance: %.2f (Mbps^2)\n', nnThroughputVariance);

% Visualize results
visualize_results(rrThroughput, nnThroughput, rrEnergy, nnEnergy, numTimeSlots);