% Simple demonstration: NGO and MNGO on the Sphere function.
clear; clc;
rng(1);                         % Reproducible random initialization

objective = @Fnk01;             % Sphere: sum(x.^2)
lowerBound = -100;
upperBound = 100;
iterations = 250;
populationSize = 30;
dimension = 30;

resultNGO = Opt53NGO(objective, lowerBound, upperBound, ...
    iterations, populationSize, dimension);
resultMNGO = Opt56MNGO(objective, lowerBound, upperBound, ...
    iterations, populationSize, dimension);

fprintf('NGO  best Sphere value: %.6e\n', resultNGO.yBest);
fprintf('MNGO best Sphere value: %.6e\n', resultMNGO.yBest);
