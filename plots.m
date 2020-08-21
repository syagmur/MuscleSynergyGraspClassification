PCA_Average_MAV= [76   77   76   78   76   75] ; 
PCA_Average_RMS= [75   77   74   78   76   75]  ;

NMF_Average_MAV= [80   80   78   80   79   78] ; 
NMF_Average_RMS= [89   88   87   89   88   88];  

PCA_Average_MAV_Min = [63 57 62 54 61 57 46]
PCA_Average_MAV_Max = [89 84 87 85 88 83 89]
% bir_m = mean([PCA_Average_MAV_Min();PCA_Average_MAV_Max])
% bir_s = std([PCA_Average_MAV_Min();PCA_Average_MAV_Max])

PCA_Average_RMS_Min = [66 61 66 54 61 57 46]
PCA_Average_RMS_Max = [91 85 87 84 88 83 89]
% iki_m = mean([PCA_Average_RMS_Min();PCA_Average_RMS_Max])
% iki_s = std([PCA_Average_RMS_Min();PCA_Average_RMS_Max])

NMF_Average_MAV_Min = [65 62 64 58 63 59 51]
NMF_Average_MAV_Max = [90 91 88 89 89 88 88]
% uc_m = mean([NMF_Average_MAV_Min();NMF_Average_MAV_Max])
% uc_s = std([NMF_Average_MAV_Min();NMF_Average_MAV_Max])

NMF_Average_RMS_Min = [84 82 83 80 83 80 77]
NMF_Average_RMS_Max = [95 93 94 93 95 93 95]
% dort_m = mean([NMF_Average_RMS_Min();NMF_Average_RMS_Max])
% dort_s = std([NMF_Average_RMS_Min();NMF_Average_RMS_Max])
% 
% all_means = [bir_m; iki_m; uc_m; dort_m]'
% all_std = [bir_s; iki_s; uc_s; dort_s]'

% means = mean(([PCA_Average_MAV_Min();PCA_Average_MAV_Max]),([PCA_Average_RMS_Min;PCA_Average_RMS_Max]),...
%     ([NMF_Average_MAV_Min;NMF_Average_MAV_Max]),([NMF_Average_RMS_Min;NMF_Average_RMS_Max]))
% sapma = std([PCA_Average_MAV_Min();PCA_Average_MAV_Max;PCA_Average_RMS_Min;PCA_Average_RMS_Max;...
%     NMF_Average_MAV_Min;NMF_Average_MAV_Max;NMF_Average_RMS_Min;NMF_Average_RMS_Max])

E0 =[82 82 84 91]
E1 =[76 75 80 89]
E2 = [77 77 80 88]
E3 = [76 74 78 87]
E4 = [78 78 80 89]
E5 = [76 76 79 88]
E6 = [75 75 78 88]
ElectrodeExtract = [E0; E1; E2; E3; E4; E5; E6]'
lower_bound = ElectrodeExtract - [PCA_Average_MAV_Min' PCA_Average_RMS_Min' NMF_Average_MAV_Min' NMF_Average_RMS_Min' ]'
upper_bound = [PCA_Average_MAV_Max' PCA_Average_RMS_Max' NMF_Average_MAV_Max' NMF_Average_RMS_Max' ]'-ElectrodeExtract

errorbar_groups(ElectrodeExtract,lower_bound,upper_bound,'bar_width',0.75,'errorbar_width',0.5, ...
'optional_bar_arguments',{'LineWidth',1.0},'optional_errorbar_arguments',{'LineStyle','none','Marker','none','LineWidth',1.0})
hold on;
grid on;
ylabel('Accuracy (%)','FontSize',14)
xlabel('Extracted Electrode','FontSize',14)
xticklabels({'None', 'Extensor digitorum', 'flexor carpi ulnaris','flexor digitorum superficialis',...
          'extensor carpi ulnaris','brachioradialis','pronator teres'})
legend('PCA-MAV','PCA-RMS','NMF-MAV','NMF-RMS','Max-Min Performances')
% PCA_Average_MAV_All = 82
% PCA_Average_RMS_All = 82
% 
% PCA_Average_MAV_Max_All = 89
% PCA_Average_MAV_Min_All = 63
% 
% PCA_Average_RMS_Max_All = 91 
% PCA_Average_RMS_Min_All = 66
% 
% NMF_Average_MAV_All = 84
% NMF_Average_RMS_All = 91
% 
% NMF_Average_MAV_Max_All = 90
% NMF_Average_MAV_Min_All = 65
% 
% NMF_Average_RMS_Max_All = 95
% NMF_Average_RMS_Min_All = 84
% 


% x=1:6
% plot(x,PCA_Average_RMS,'b--o',x,NMF_Average_RMS,'r:*','LineWidth',2)
% hold on  
% grid on  
% 
% x=1:6
% plot(x,PCA_Average_MAV,'b--o',x,NMF_Average_MAV,'r:*','LineWidth',2)
% hold on  
% grid on

Sub1_MAV = [87.5 65.5 63.9]
Sub1_RMS = [93.2 83.3 82.3]

Sub2_MAV = [90.0 51.5 60.9]
Sub2_RMS = [95.4 76.6 78.2]

Sub3_MAV = [83.6 48.4 55.5]
Sub3_RMS = [92.0 73.4 76.4]

Sub4_MAV = [85.0 51.9 53.1]
Sub4_RMS = [92.3 77.5 78.9]

Sub5_MAV = [64.7 37.6 40.4]
Sub5_RMS = [83.8 67.7 69.0]

Sub6_MAV = [82.4 57.7 55.1]
Sub6_RMS = [91.0 81.0 79.6]

Sub7_MAV = [88.0 50.6 53.7]
Sub7_RMS = [94.3 81.0 74.4]

MAV_Res = [Sub1_MAV;Sub2_MAV;Sub3_MAV;Sub4_MAV;Sub5_MAV;Sub6_MAV;Sub7_MAV]'
RMS_Res = [Sub1_RMS;Sub2_RMS;Sub3_RMS;Sub4_RMS;Sub5_RMS;Sub6_RMS;Sub7_RMS]'
Lower_MAV = [85.2 52.7 49.3; 87.2 32.8 48.8;77.8 31.6 43.3; 82.1 38.6 37.9;...
            62.2 25.7 35.3; 78.4 40.8 37.3; 83.3 30.5 38.7]';
%Upper_MAV = [90.5 73.0 70.9; ]
MAV_Var = [0.2 4.1 3.0; 0.2 7.9 6.5;  0.7 7.9 4.9;0.3 5.4 5.0; 0.3 3.9 1.3; 0.4 8.0 7.2; 0.4 14.2 4.1 ]'
RMS_Var = [0.038 1.2 0.9;0.038 0.7 0.5; 0.0415 2.2 1.0; 0.1 2.4 1.8; 0.1 1.2 0.5;0.1 1.2 0.8; 0.1 1.3 2.4]'

errorbar_groups(MAV_Res,MAV_Var,'bar_width',0.75,'errorbar_width',0.5, ...
'optional_bar_arguments',{'LineWidth',1.0},'optional_errorbar_arguments',{'LineStyle','none','Marker','none','LineWidth',1.0})
hold on;
grid on;
ylabel('Accuracy (%)','FontSize',14)
xlabel('Subjects','FontSize',14)
xticklabels({'S1','S2','S3', 'S4','S5', 'S6','S7'})
legend('6x6','6x5','6x4','Mean ± Cross Validation Bias')


errorbar_groups(RMS_Res,RMS_Var,'bar_width',0.75,'errorbar_width',0.5, ...
'optional_bar_arguments',{'LineWidth',1.0},'optional_errorbar_arguments',{'LineStyle','none','Marker','none','LineWidth',1.0})
hold on;
grid on;
ylabel('Accuracy (%)','FontSize',14)
xlabel('Subjects','FontSize',14)
xticklabels({'S1','S2','S3', 'S4','S5', 'S6','S7'})
legend('6x6','6x5','6x4','Mean ± Cross Validation Bias')


colormap HSV
bar(ElectrodeExtract)
errorbar(ElectrodeExtract,all_means, all_std)
xlabel('Subjects')
ylabel('Accuracy (%)')
hold on;
grid on;


Sub1_MAV = [59 77.6 79.9 84.0 84.8];
Sub1_RMS = [58.6 77.5 80.2 83.4 84.3 ];

Sub2_MAV = [54.2 80.1 88.2 88.4 88.1];
Sub2_RMS = [54.1 80.3 87.6 88.5 88.0];

Sub3_MAV = [47.9 62.4 68.9 80.1 82.1];
Sub3_RMS = [47.9 61.8 69.7 79.8 81.2];

Sub4_MAV = [48.3 67.2 72.5 82.7 81.6];
Sub4_RMS = [48.7 67.7 72.3 82.5 82.1];

Sub5_MAV = [44.3 52.9 62.9 65.6 62.3];
Sub5_RMS = [44.6 53.3 63.2 65.6 62.6];

Sub6_MAV = [42.0 66.1 77.3 79.5 80.6];
Sub6_RMS = [42.9 66.5 77.5 79.5 80.4];

Sub7_MAV = [57.8 71.0 82.9 87.0 86.3];
Sub7_RMS = [57.9 70.3 83.5 86.8 86.3];

MAV_Res = [Sub1_MAV;Sub2_MAV;Sub3_MAV;Sub4_MAV;Sub5_MAV;Sub6_MAV;Sub7_MAV]'
RMS_Res = [Sub1_RMS;Sub2_RMS;Sub3_RMS;Sub4_RMS;Sub5_RMS;Sub6_RMS;Sub7_RMS]'

MAV_Var = [0.003	0.003	0.002	0.004	0.003; 0.004	0.002	0.001	0.003	0.002;...
    0.004	0.004	0.004	0.004	0.003   ;0.004	0.004	0.002	0.003	0.001;...
    0.005	0.009	0.004	0.007	0.006	; 0.003	0.005	0.003	0.003	0.004;...
    0.004	0.005	0.003	0.002	0.002	]'*100;

RMS_Var= [0.006	0.001	0.002	0.004	0.003;0.002	0.003	0.001	0.003	0.002;...
    0.005	0.006	0.002	0.003	0.002; 0.005	0.003	0.005	0.001	0.003;...
    0.004	0.004	0.009	0.006	0.003;0.005	0.006	0.005	0.005	0.003;...
    0.007	0.002	0.004	0.004	0.002]'*100;

errorbar_groups(MAV_Res,MAV_Var,'bar_width',0.75,'errorbar_width',0.5, ...
'optional_bar_arguments',{'LineWidth',1.0},'optional_errorbar_arguments',{'LineStyle','none','Marker','none','LineWidth',1.0})
hold on;
grid on;
ylabel('Accuracy (%)','FontSize',14)
xlabel('Subjects','FontSize',14)
xticklabels({'S1','S2','S3', 'S4','S5', 'S6','S7'})
legend('2','3','4','5','6','Mean ± Cross Validation Bias')


errorbar_groups(RMS_Res,RMS_Var,'bar_width',0.75,'errorbar_width',0.5, ...
'optional_bar_arguments',{'LineWidth',1.0},'optional_errorbar_arguments',{'LineStyle','none','Marker','none','LineWidth',1.0})
hold on;
grid on;
ylabel('Accuracy (%)','FontSize',14)
xlabel('Subjects','FontSize',14)
xticklabels({'S1','S2','S3', 'S4','S5', 'S6','S7'})
legend('2','3','4','5','6','Mean ± Cross Validation Bias')