clear all;
close all;

filename = 'danestat4.txt';
[data,delimiterOut]=importdata(filename)
%%A
%%
% plot(data(:,1),'Color',[0.2 1.0 0.8]);
% hold on
% plot(data(:,2),'Color',[0.8 0.0 0.8]);
% xlabel('k - numer próbki');
% ylabel('Amplituda');
% legend('sygna³ wejœciowy u(k)','sygna³ wejœciowy y(k)');

%%B
%%
[A,delimiterOut]=importdata('trainingIndexes.txt');
L=false(200,2)
L(A,:)=true;

%wy³uskanie indeksów rozró¿niaj¹cych wejœciowy plik z danymi na plik z
%danymi ucz¹cymi oraz weryfikuj¹cymi
trainingD=data(L);
trainingData=[trainingD(1:100,1),trainingD(101:200,1)]
validationD=data(~L)
validationData=[validationD(1:100,1),validationD(101:200,1)]
dlmwrite('trainingData.txt',trainingData)
dlmwrite('validationData.txt',validationData)

%%charakterystyka y(u) dla danych ucz¹cych
% figure
% plot(trainingData(:,1),trainingData(:,2),'.g');
% xlabel('u');
% ylabel('y');

%%rysunek danych ucz¹cych
% plot(trainingData(:,1),'Color',[0.2 1.0 0.8]);
% hold on
% plot(trainingData(:,2),'Color',[0.8 0.0 0.8]);
% xlabel('k - numer próbki');
% ylabel('Amplituda');
% legend('sygna³ wejœciowy u(k)','sygna³ wejœciowy y(k)');

%%charakterystyka y(u) dla danych weryfikuj¹cych
% figure
% plot(validationData(:,1),validationData(:,2),'.r');
% xlabel('u');
% ylabel('y');

%%rysunek danych weryfikuj¹cych
% plot(validationData(:,1),'Color',[0.2 1.0 0.8]);
% hold on
% plot(validationData(:,2),'Color',[0.8 0.0 0.8]);
% xlabel('k - numer próbki');
% ylabel('Amplituda');
% legend('sygna³ wejœciowy u(k)','sygna³ wejœciowy y(k)');

%%C,D
%%
degree=12; %%dla punktu C (modeli liniowych) degree=1 
Y_training=trainingData(:,2);
M_training=ones(100,degree+1)
for i=1:degree
    M_training(:,i+1)=trainingData(:,1).^i
end
%W=M\Y z MNK:
W_training=M_training\Y_training

u=[-1:0.01:1]
y=W_training(1);
for j=1:degree
    y=y+W_training(j+1)*u.^j
end 

%%charakt. stat. na tle danych we/wy
% figure
% plot(u,y,'Color',[0.4 0.0 0.6]) %[0.4 0.6 0.4]
% hold on
% plot(trainingData(:,1),trainingData(:,2),'.g')
% plot(validationData(:,1),validationData(:,2),'.r')
% xlabel('u')
% ylabel('y');

% Ymod_training=M_training*W_training
% %wyjœcie modelu na tle danych ucz¹cych
% plot(Ymod_training(:),'Color',[1.0 1.0 0.0]);
% hold on
% plot(trainingData(:,1),'Color',[0.2 1.0 0.8]);
% hold on
% plot(trainingData(:,2),'Color',[0.8 0.0 0.8]);
% xlabel('k - numer próbki');
% ylabel('Amplituda');
% legend('wyjœcie modelu y_m_o_d(k)','sygna³ wejœciowy u(k)','sygna³ wyjœciowy y(k)');

M_validation=ones(100,degree+1)
for k=1:degree
    M_validation(:,k+1)=validationData(:,1).^k
end

Ymod_validation=M_validation*W_training
%%wyjœcie modelu na tle danych weryfikuj¹cych
% plot(Ymod_validation(:),'Color',[1.0 1.0 0.0]);
% hold on
% plot(validationData(:,1),'Color',[0.2 1.0 0.8]);
% hold on
% plot(validationData(:,2),'Color',[0.8 0.0 0.8]);
% xlabel('k - numer próbki');
% ylabel('Amplituda');
% legend('wyjœcie modelu y_m_o_d(k)','sygna³ wejœciowy u(k)','sygna³ wyjœciowy y(k)');


Y_validation=validationData(:,2);
trainingError=(norm(M_training*W_training-Y_training))^2
validationError=(norm(M_validation*W_training-Y_validation))^2