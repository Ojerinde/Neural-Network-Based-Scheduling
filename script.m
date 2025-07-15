% Neural Network-Based Scheduling for 6G Multi-User Network

% Parameters
numUsers = 10;
numTimeSlots = 100;
bandwidth = 100e6;
noisePower = 1e-9;
txPower = 0.1;
rng(42);

% Channel gains (Rayleigh fading)
channelGains = zeros(numUsers, numTimeSlots);
for t = 1:numTimeSlots
    channelGains(:, t) = abs((randn(numUsers, 1) + 1i*randn(numUsers, 1))/sqrt(2)).^2;
end

% Round-Robin Scheduler
rrSchedule = mod((0:numTimeSlots-1), numUsers) + 1;
rrThroughput = zeros(1, numTimeSlots);
rrEnergy = zeros(1, numTimeSlots);
for t = 1:numTimeSlots
    user = rrSchedule(t);
    snr = channelGains(user, t) * txPower / noisePower;
    rrThroughput(t) = bandwidth * log2(1 + snr);
    rrEnergy(t) = txPower;
end
rrAvgThroughput = mean(rrThroughput);
rrAvgEnergy = mean(rrEnergy);

% Training Data: Best user per fading instance
numTrainingSamples = 1000;
X_train = zeros(numTrainingSamples, numUsers);
Y_train = zeros(numTrainingSamples, 1);
for i = 1:numTrainingSamples
    h = abs((randn(numUsers, 1) + 1i*randn(numUsers, 1))/sqrt(2)).^2;
    X_train(i, :) = h';
    [~, Y_train(i)] = max(h);
end

% Neural Network Architecture
layers = [
    featureInputLayer(numUsers)
    fullyConnectedLayer(64)
    reluLayer
    fullyConnectedLayer(numUsers)
    softmaxLayer
    classificationLayer
];

% Training Options
options = trainingOptions('adam', ...
    'MaxEpochs', 50, ...
    'MiniBatchSize', 32, ...
    'Verbose', 1, ...
    'Plots', 'training-progress');

% Train Network
net = trainNetwork(X_train, categorical(Y_train), layers, options);

% Neural Network Scheduler
nnSchedule = zeros(1, numTimeSlots);
nnThroughput = zeros(1, numTimeSlots);
nnEnergy = zeros(1, numTimeSlots);
for t = 1:numTimeSlots
    scores = predict(net, channelGains(:, t)')';
    [~, nnSchedule(t)] = max(scores);
    snr = channelGains(nnSchedule(t), t) * txPower / noisePower;
    nnThroughput(t) = bandwidth * log2(1 + snr);
    nnEnergy(t) = txPower;
end
nnAvgThroughput = mean(nnThroughput);
nnAvgEnergy = mean(nnEnergy);

% Performance Metrics
throughputGain = ((nnAvgThroughput - rrAvgThroughput) / rrAvgThroughput) * 100;
rrThroughputVariance = var(rrThroughput) / 1e12;
nnThroughputVariance = var(nnThroughput) / 1e12;

% Display Results
fprintf('Throughput Gain: %.2f%%\n', throughputGain);
fprintf('NN Avg Throughput: %.2f Gbps\n', nnAvgThroughput/1e9);
fprintf('RR Avg Throughput: %.2f Gbps\n', rrAvgThroughput/1e9);
fprintf('Round-Robin Throughput Variance: %.2f (Mbps^2)\n', rrThroughputVariance);
fprintf('Neural Network Throughput Variance: %.2f (Mbps^2)\n', nnThroughputVariance);

% Plot Results
figure;
subplot(2,1,1);
plot(1:numTimeSlots, rrThroughput/1e6, 'b-', 'DisplayName', 'Round-Robin');
hold on;
plot(1:numTimeSlots, nnThroughput/1e6, 'r-', 'DisplayName', 'Neural Network');
xlabel('Time Slot'); ylabel('Throughput (Mbps)');
title('Throughput Comparison'); legend; grid on;

subplot(2,1,2);
plot(1:numTimeSlots, rrEnergy*1000, 'b-', 'DisplayName', 'Round-Robin');
hold on;
plot(1:numTimeSlots, nnEnergy*1000, 'r-', 'DisplayName', 'Neural Network');
xlabel('Time Slot'); ylabel('Energy (mW)');
title('Energy Comparison'); legend; grid on;

% Save Plot
saveas(gcf, 'throughput-comparison.png');
