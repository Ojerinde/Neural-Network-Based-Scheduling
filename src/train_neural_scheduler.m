function net = train_neural_scheduler(numUsers, numTrainingSamples)
%TRAIN_NEURAL_SCHEDULER Train a classifier to pick the best user to schedule.
%   net = TRAIN_NEURAL_SCHEDULER(numUsers, numTrainingSamples) generates
%   numTrainingSamples independent Rayleigh-fading channel-gain snapshots
%   (one numUsers-length gain vector per snapshot), labels each snapshot
%   with the index of the user that actually has the best gain, and
%   trains a feedforward network to predict that label from the gains.
%
%   The label rule (always pick the user with the strongest instantaneous
%   channel) is the theoretically throughput-optimal single-user-per-slot
%   policy -- the "multiuser diversity" scheduling gain literature (Tse &
%   Viswanath, Fundamentals of Wireless Communication, Ch. 6) formalizes
%   exactly this rule. That also means it has a closed form (argmax) and
%   doesn't strictly need a neural network to compute -- see the README's
%   Limitations section for what a genuinely learning-justified version
%   (e.g. proportional-fair scheduling) would need instead.
%
%   Does not set the random seed -- see the note in simulate_channel.m.
%   Called after main.m's evaluation channel gains are already generated,
%   so these training snapshots are independent draws from the same
%   overall reproducible run, not duplicates of the evaluation data.
    channelGains = abs((randn(numUsers, numTrainingSamples) + 1i*randn(numUsers, numTrainingSamples)) / sqrt(2)).^2;
    [~, bestUser] = max(channelGains, [], 1);
    labels = categorical(bestUser);

    layers = [
        featureInputLayer(numUsers)
        fullyConnectedLayer(64)
        reluLayer
        fullyConnectedLayer(numUsers)
        softmaxLayer
        classificationLayer];

    options = trainingOptions('adam', ...
        'MaxEpochs', 50, ...
        'MiniBatchSize', 32, ...
        'Verbose', false, ...
        'Plots', 'none');

    % trainNetwork expects numObservations-by-numFeatures rows, hence the
    % transpose -- channelGains is numUsers-by-numTrainingSamples.
    net = trainNetwork(channelGains', labels', layers, options);
end
