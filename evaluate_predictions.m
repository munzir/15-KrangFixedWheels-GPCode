function rmse = evaluate_predictions(predictions, test_torque)
    
    diff = minus(predictions, test_torque);
    disp('disp')
    size(diff)
    rmse = [];
    for i = 1:size(diff,1)
        rmse_new = norm(diff(i,:));
        rmse = [rmse; rmse_new];
    end
    
    rmse = sum(rmse)
    