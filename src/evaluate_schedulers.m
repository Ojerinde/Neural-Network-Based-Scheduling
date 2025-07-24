function [nnSchedule, nnThroughput, nnEnergy] = evaluate_schedulers(net, channelGains, bandwidth, txPower, noisePower)
    % Evaluates neural network scheduler
    % Inputs:
    %   net - Trained neural network
    %   channelGains - Matrix of channel gains (numUsers x numTimeSlots)
    %   bandwidth - System bandwidth (Hz)
    %   txPower - Transmit power (Watts)
    %   noisePower - Noise power (Watts)
    % Outputs:
    %   nnSchedule - User schedule (1 x numTimeSlots)
    %   nnThroughput - Throughput per time slot (bps)
    %   nnEnergy - Energy consumption per time slot (Watts)
    
    numTimeSlots = size(channelGains, 2);
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
end