% clear all;
num_training_samples = 1000;
num_test_samples = 1000;
offset = 100;
dir = 'all_data/Data_HighDeg/';

disp('here')

time = tdfread(strcat(dir,'dataTime.txt'));
t = time.dataTime;
% M = tdfread(strcat(dir,'dataM.txt'), 'tab');
% M = M.dataM;
% 
% disp('here')
% Cg = tdfread(strcat(dir,'dataCg.txt'), 'tab');
% Cg = Cg.dataCg;
% 
% torque_data = tdfread(strcat(dir,'dataTorque.txt'), '\t');
% torque_data = torque_data.dataTorque;
% 
% q_data = tdfread(strcat(dir,'dataQ.txt'), '\t');
% q_data = q_data.dataQ;
% size(q_data)
% 
% disp('here')
% dq_data = tdfread(strcat(dir,'dataQdot.txt'), '\t');
% dq_data = dq_data.dataQdot;
% 
% ddq_data = tdfread(strcat(dir, 'dataQdotdot.txt'), '\t');
% ddq_data = ddq_data.dataQdotdot;
% 
% % size('here')
% training_q = q_data(1+offset:offset + num_training_samples,:);
% test_q = q_data(offset + num_training_samples+1:offset + num_training_samples+num_test_samples,:);
% 
% training_dq = dq_data(1+offset:offset + num_training_samples,:);
% test_dq = dq_data(offset + num_training_samples+1:offset + num_training_samples+num_test_samples,:);
% 
% training_ddq = ddq_data(1+offset: offset + num_training_samples,:);
% test_ddq = ddq_data(offset + num_training_samples+1:offset + num_training_samples+num_test_samples,:);
% 
% training_torque = torque_data(1+offset: offset + num_training_samples,:);
% test_torque = torque_data(offset + num_training_samples+1:offset + num_training_samples+num_test_samples,:);
% 
% t_train = t(1+offset:offset + num_training_samples,:);
% t_test = t(offset + num_training_samples+1:offset + num_training_samples+num_test_samples,:);
% 
disp('here')
training_PHI_BETA_mean = zeros(num_training_samples,18);
training_trajectories = zeros(num_training_samples,54);
for i = 1:num_training_samples
         
    q_sample = training_q(i,:);
    dq_sample = training_dq(i,:);
    ddq_sample = training_ddq(i,:);
    
    b = horzcat(q_sample, dq_sample, ddq_sample);
    training_trajectories(i,:) = b;
    
    A=M((i-1)*18+1:(i-1)*18+18,:);
    
    training_PHI_BETA_mean(i,:) = (A*ddq_sample')'+Cg(i,:);
    
    
end
disp('created training input, output');

test_trajectories = zeros(num_test_samples, 54);
test_PHI_BETA_mean = zeros(num_test_samples, 18);
for i = 1:num_test_samples
         
    q_sample = test_q(i,:);
    dq_sample = test_dq(i,:);
    ddq_sample = test_ddq(i,:);

    b = horzcat(q_sample, dq_sample, ddq_sample);
    test_trajectories (i,:)=  b;
    
    A=M((i+num_training_samples-1)*18+1:(i+num_training_samples-1)*18+18,:);
    test_PHI_BETA_mean(i,:) = (A*ddq_sample')'+Cg(i,:);
end
disp('created testing input, output');

size(training_torque)
size(training_PHI_BETA_mean)
training_output = minus(training_torque, training_PHI_BETA_mean);


[hyp2, meanfunc, covfunc, likfunc] = rbd_mean(training_PHI_BETA_mean, test_PHI_BETA_mean, training_trajectories, test_trajectories, training_output);
predictions_train = rbd_mean_predict(hyp2, meanfunc, covfunc, likfunc, training_trajectories, training_output, training_trajectories,training_PHI_BETA_mean);
predictions_test = rbd_mean_predict(hyp2, meanfunc, covfunc, likfunc, training_trajectories, training_output, test_trajectories,test_PHI_BETA_mean);


rmse = evaluate_predictions(predictions_test, test_torque);
% size(t_test)
% size(predictions_test)
% size(test_torque)
% 
% size(t_train)
% size(predictions_train)
% size(training_torque)
figure,
for i=1:18
    subplot(5,5,i)
    plot(t_test,log(predictions_test(:,i)),t_test,log(test_torque(:,i)))
end
title('Test');


figure,
for i=1:18
    subplot(5,5,i)
    plot((t_train),log(predictions_train(:,i)),(t_train),log(training_torque(:,i)))
end
title('Train');

% size(test_torque)
avg_pct = evaluate_predictions(predictions_test, test_torque);
error_torque = training_torque - training_PHI_BETA_mean;
disp('Average percent error');
avg_pct
disp('Hyperparameters');
hyp2;
alpha = calc_alpha(hyp2, error_torque, training_trajectories);