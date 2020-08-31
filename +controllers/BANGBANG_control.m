%%%%%%%%%%%% BANBAN_control.m %%%%%%%%%%%%%%
% バンバン制御
% gainを要素に持つ 1*2 ベクトル (double)
% gain[1] : 直進成分ゲイン
% gain[2] : 回転成分ゲイン
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function u = BANGBANG_control(t, delta_t, value_light_sensor, value_range_sensor, gain)
z = sum(value_light_sensor,'all')/5;
if z >160  % センサ白検知
    e = -0.1;
else
    e = 0.1;
end
u = [1 1;1 -1]*diag(gain)*[1; e];   % 変換行列 * ゲイン対角行列 * 量
%disp(z)
end
