function [hyp2, meanfunc, covfunc, likfunc] = rbd_mean (training_PHI_BETA_mean, test_PHI_BETA_mean, training_trajectories, test_trajectories, training_output)
   
    meanfunc = [];                    % No mean
    covfunc = @covSEiso;              % Squared Exponental covariance function
    likfunc = @likGauss;              % Gaussian likelihood
    
    hyp = struct('mean',[], 'cov', [5.27 8.876] , 'lik', -1.4);
    
    hyp2 = minimize(hyp, @gp, -5000, @infGaussLik, meanfunc, covfunc, likfunc, training_trajectories, training_output);
    disp('calculated hyperparameters using optimizing marginal likelihood');    

disp('calculated hyperparameters');
%     f = [mu+2*sqrt(s2); flipdim(mu-2*sqrt(s2),1)];
%     fill([test_trajectories; flipdim(test_trajectories,1)], f, [7 7 7]/8)
%     hold on; plot(test_trajectories, mu); plot(training_trajectories, training_output, '+')
%     predictions = mu;
