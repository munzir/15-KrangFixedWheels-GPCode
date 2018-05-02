clc; clear; close all;
dof   = 18;
offset = 1;
dir = 'all_data/data3/';
q = tdfread(strcat(dir,'dataQ.txt'), '\t');
q = q.dataQ;
q = q(offset:end,:);

dq = tdfread(strcat(dir,'dataQdot.txt'), '\t');
dq = dq.dataQdot;
dq = dq(offset:end,:);

ddq = tdfread(strcat(dir,'dataQdotdot.txt'), '\t');
ddq = ddq.dataQdotdot;
ddq = ddq(offset:end,:);

qref = tdfread(strcat(dir,'dataQref.txt'), '\t');
qref = qref.dataQref;

torque = tdfread(strcat(dir,'dataTorque.txt'), '\t');
torque = torque.dataTorque;
torque = torque(offset:end,:);
max_torque = max(abs(torque));
% torque = torque./max_torque.*3.5;

time = tdfread(strcat(dir,'dataTime.txt'));
time = time.dataTime;
time = time(offset:end,:);
rows = 5; cols = 4;
flag = 0;
for i = 1:dof
    subplot(rows, cols, i);
    plot(time, q(:,i), time, qref(:,i)); grid on;
%     plot(time(:,1), q(:,i)); grid on;
%     hold on;
%     plot(time(:,1), dq(:,i));
%     hold on;
%     plot(time(:,1), ddq(:,i));
%     hold on;
%     plot(time(:,1), torque(:,i));
%     xlabel('Time');
%     legend('q','dq','ddq','torque');

%     title(['max torque: ' num2str(max_torque(i))]);
end