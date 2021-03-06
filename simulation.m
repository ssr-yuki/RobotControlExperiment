clear   % 一旦ワークスペース内全変数を消去

field_number = '01';

% save_video_name = 'movie';

run("fields/set_field_list.m");
field_folder = field_list(field_number);

func.makeField(field_folder);

load( strcat("fields/" , field_folder, "/", "field") );

func.drawInit(field_size);

func.drawField(field_size, field_line, field_wall, finish_zone);
field_line = field_line.';
field_wall = field_wall.';

light_sensor_visible = "on";    % ライトセンサ表示するか否か
% time_constant = 0.1;    % 時定数の初期設定値
% viscocity = 0.0;    % 粘性の初期設定値
run("robot.m");
run("list_system_config.m");    % システム設定の読み込み

body_line = line;
wheel_line = [line, line];
cond_string = "待機中";
message = text(0, -30, strcat("T = ",string(0.0),"[s],  ",cond_string),'Fontsize',20);
light_sensor_points = text(zeros(size(list_light_sensor,1),1), zeros(size(list_light_sensor,1),1), '〇', 'Color','red', 'Fontsize', 8);
range_sensor_points = text(zeros(size(list_range_sensor,1),1), zeros(size(list_range_sensor,1),1), '*', 'Color','magenta');
for i = 1:size(list_range_sensor,1)
    range_sensor_line(i) = line;
    range_sensor_line(i).Visible = range_line_visible;
    range_sensor_line(i).Color = 'g';
end
% range_sensor_line.Visible = repmat(range_line_visible,1,2);

range_detect_points = zeros(2, size(list_range_sensor,1));

state_robot = init_state + [10*(rand-0.5); 10*(rand-0.5); 10/360*2*pi*(rand-0.5)];
environmental_light_noise = 40 * (rand-0.5);

delta_t = 0.01;
wait_N = -50;  % 開始までの時間
N = 18000;       % シミュレーション最大時間 3min
t = 0:delta_t:delta_t*(N-1);
t = t.';
q = zeros(N, 3);
u = zeros(N, 2);
z = zeros(N, size(list_light_sensor,1)+size(list_range_sensor,1));
control_input = [0.0;0.0];    % dutyR, dutyL (-1.0 ~ +1.0, duty rate
value_light_sensor = zeros(size(list_light_sensor,1),1);
value_range_sensor = zeros(size(list_range_sensor,1),1);
simulation_cond = 1;    % 実行
movie_k = 0;

for k = wait_N:1:N
    if k>0
        cond_string = "スタート";
        if mod(k,5) == 0    % 20Hz
            value_light_sensor = func.getLightSensor(state_robot, list_light_sensor, field_line, environmental_light_noise);
            [value_range_sensor, range_detect_points] = func.getRangeSensor(state_robot, list_range_sensor, field_wall);
            control_input = controller(t(k,1), delta_t, value_light_sensor, value_range_sensor);
        end
        q(k,:) = state_robot;
        u(k,:) = control_input;
        z(k,:) = [value_light_sensor.', value_range_sensor.'];
    end
    % if exist('time_constant','var') == 1
    %     state_robot = func.robotSystem(state_robot, control_input, wheel, delta_t, time_constant, viscocity);
    % else
    %     state_robot = func.robotSystem(state_robot, control_input, wheel, delta_t);
    % end
    state_robot = func.robotSystem(state_robot, control_input, wheel, delta_t, system_config);
    
    simulation_cond = simulation_cond * func.checkRobotPosition(state_robot, body, field_size, field_wall, finish_zone);
    if simulation_cond<0    % 何らかの終了原因が生じた
        cond_string = "終了";
    end
    func.drawRobot(state_robot, body, body_line, wheel, wheel_line, list_light_sensor, light_sensor_points, list_range_sensor(:,1:2), range_sensor_points, range_detect_points, range_sensor_line, light_sensor_visible);
    message.String = strcat("T = ",num2str(k*delta_t,'%3.2f'),"[s],  ", cond_string);
    
    if exist('save_video_name', 'var') == 1  % movie作成
        if mod(k,4) == 1
            movie_k = movie_k + 1;
            Movie(movie_k) = getframe(gcf);
        end
    else
        pause(delta_t/2);
    end
    drawnow limitrate
    
    if simulation_cond<0    % 何らかの終了原因が生じた
        break;
    end
    
end

clear controller % for clear perisistent variable
clear checkRobotPosition
clear robotSystem

if simulation_cond == 1
    disp("シミュレーション時間が終了しました");
end

% figure
% j = 1:k;
% plot(j, q(1:k,2));
% grid on

if exist('save_video_name', 'var') == 1
    func.makeVideo(save_video_name, Movie);
end

