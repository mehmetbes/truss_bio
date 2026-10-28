function S = Opt56MNGO(objective, lowerBound, upperBound, iterations, populationSize, dimension)
% Basic modified NGO (MNGO) using FDB selection in Phase 2.

lb = ones(1, dimension) .* lowerBound;
ub = ones(1, dimension) .* upperBound;
X = lb + rand(populationSize, dimension) .* (ub - lb);
fitness = zeros(populationSize, 1);

for i = 1:populationSize
    fitness(i) = objective(X(i, :));
end
[bestFitness, bestIndex] = min(fitness);
bestPosition = X(bestIndex, :);
convergence = zeros(iterations, 1);

for t = 1:iterations
    % Select the FDB-guided individual once per iteration.
    fdbIndex = fitnessDistanceBalance(X, fitness);

    for i = 1:populationSize
        % Phase 1: exploration (same update as NGO)
        k = randi(populationSize);
        P = X(k, :);
        I = randi([1, 2]);

        if fitness(i) > fitness(k)
            candidate = X(i, :) + rand(1, dimension) .* (P - I .* X(i, :));
        else
            candidate = X(i, :) + rand(1, dimension) .* (X(i, :) - P);
        end
        candidate = min(max(candidate, lb), ub);
        candidateFitness = objective(candidate);
        if candidateFitness < fitness(i)
            X(i, :) = candidate;
            fitness(i) = candidateFitness;
        end

        % Phase 2: exploitation guided by the FDB-selected individual
        R = 0.02 * (1 - t / iterations);
        candidate = X(fdbIndex, :) + ...
            (-R + 2 * R .* rand(1, dimension)) .* X(i, :);
        candidate = min(max(candidate, lb), ub);
        candidateFitness = objective(candidate);
        if candidateFitness < fitness(i)
            X(i, :) = candidate;
            fitness(i) = candidateFitness;
        end
    end

    [iterationBest, bestIndex] = min(fitness);
    if iterationBest < bestFitness
        bestFitness = iterationBest;
        bestPosition = X(bestIndex, :);
    end
    convergence(t) = bestFitness;
end

S = struct('x', iterations, 'y', convergence, ...
    'xBest', bestPosition, 'yBest', bestFitness);
end
