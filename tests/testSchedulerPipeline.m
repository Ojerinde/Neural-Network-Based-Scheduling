classdef testSchedulerPipeline < matlab.unittest.TestCase
    %TESTSCHEDULERPIPELINE Unit tests for the 6G scheduler simulation pipeline.
    %   Run with (from the project root):
    %     addpath('src'); results = runtests('tests'); disp(results);

    methods (TestClassSetup)
        function addSourceToPath(testCase)
            projectRoot = fileparts(fileparts(mfilename('fullpath')));
            addpath(fullfile(projectRoot, 'src'));
        end
    end

    methods (Test)
        function testSimulateChannelShape(testCase)
            gains = simulate_channel(5, 20);
            testCase.verifySize(gains, [5, 20]);
            testCase.verifyGreaterThanOrEqual(gains, 0);  % power gains are non-negative
        end

        function testSimulateChannelDoesNotResetSeedInternally(testCase)
            % Regression test: an earlier version called rng(42) inside
            % simulate_channel itself, so two calls in the same run
            % produced identical results instead of independent samples.
            rng(1);
            first = simulate_channel(4, 10);
            second = simulate_channel(4, 10);
            testCase.verifyNotEqual(first, second);
        end

        function testTrainNeuralSchedulerReturnsAUsableNetwork(testCase)
            % Regression test for the specific historical bug: an earlier
            % version of this file was an accidental duplicate of
            % simulate_channel.m, so `net` was a plain numeric matrix, and
            % predict(net, ...) failed outright. A real network must
            % support predict() and return one score per user.
            numUsers = 4;
            net = train_neural_scheduler(numUsers, 50);  % small sample count, just for a fast test
            scores = predict(net, rand(1, numUsers));
            testCase.verifySize(scores, [1, numUsers]);
        end

        function testRoundRobinCyclesThroughAllUsers(testCase)
            numUsers = 3;
            numSlots = 9;
            gains = ones(numUsers, numSlots);  % equal gains -- isolates the scheduling pattern itself
            [schedule, ~, ~] = round_robin_scheduler(gains, 100e6, 0.1, 1e-9);
            testCase.verifyEqual(schedule, [1 2 3 1 2 3 1 2 3]);
        end

        function testRoundRobinThroughputMatchesShannonCapacity(testCase)
            bandwidth = 100e6;
            txPower = 0.1;
            noisePower = 1e-9;
            gains = 2.0;  % single user, single slot, a known fixed gain
            [~, throughput, energy] = round_robin_scheduler(gains, bandwidth, txPower, noisePower);

            expectedSnr = gains * txPower / noisePower;
            expectedThroughput = bandwidth * log2(1 + expectedSnr);
            testCase.verifyEqual(throughput, expectedThroughput, 'RelTol', 1e-10);
            testCase.verifyEqual(energy, txPower);
        end

        function testEvaluateSchedulersProducesValidUserIndices(testCase)
            numUsers = 4;
            numSlots = 15;
            rng(7);
            gains = simulate_channel(numUsers, numSlots);
            net = train_neural_scheduler(numUsers, 100);
            [schedule, throughput, energy] = evaluate_schedulers(net, gains, 100e6, 0.1, 1e-9);

            testCase.verifySize(schedule, [1, numSlots]);
            testCase.verifyGreaterThanOrEqual(schedule, 1);
            testCase.verifyLessThanOrEqual(schedule, numUsers);
            testCase.verifySize(throughput, [1, numSlots]);
            testCase.verifyGreaterThanOrEqual(throughput, 0);
            testCase.verifyEqual(energy, 0.1 * ones(1, numSlots));
        end

        function testNeuralSchedulerPrefersStrongerChannelOnObviousCase(testCase)
            % Sanity check on the learned policy itself: given a slot
            % where one user's channel is overwhelmingly stronger than
            % everyone else's, the scheduler should pick that user. This
            % doesn't prove the network is well-trained in general, but a
            % network that fails this on an unambiguous case is broken.
            numUsers = 4;
            net = train_neural_scheduler(numUsers, 500);

            obviousGains = [0.01, 0.01, 0.01, 5.0];  % user 4 is the clear best choice
            scores = predict(net, obviousGains);
            [~, chosen] = max(scores);
            testCase.verifyEqual(chosen, 4);
        end
    end
end
