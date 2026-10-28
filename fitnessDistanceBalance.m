function index = fitnessDistanceBalance(population, fitness)
% Select the candidate with the largest normalized fitness-distance score.
% This is equivalent in ranking to equal weights w = 0.5 in the FDB score.

fitness = fitness(:)';
populationSize = size(population, 1);
[~, bestIndex] = min(fitness);
best = population(bestIndex, :);
distances = sum(abs(population - best), 2)';

fitnessRange = max(fitness) - min(fitness);
distanceRange = max(distances) - min(distances);
if fitnessRange == 0 || distanceRange == 0
    index = randi(populationSize);
    return;
end

normalizedFitness = 1 - (fitness - min(fitness)) ./ fitnessRange;
normalizedDistance = (distances - min(distances)) ./ distanceRange;
score = normalizedFitness + normalizedDistance;
[~, index] = max(score);
end
