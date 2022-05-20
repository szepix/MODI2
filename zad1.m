clear all;
close all;

[data, ~]=importdata("danestat37.txt");
%{
a)
plot(data(:,1));
hold on
plot(data(:,2));
xlabel('k - numer próbki');
ylabel('Amplituda');
legend('sygnał wejściowy u(k)','sygnał wejściowy y(k)');
%}
%{ 

[m,n] = size(data) ;
P = 0.5 ;
idx = randperm(m);
Training = data(idx(1:round(P*m)),:); 
Validation = data(idx(round(P*m)+1:end),:);
dlmwrite('daneuczace.txt', Training);
dlmwrite('danewalidacyjne.txt', Validation);
%}


[daneUczace,~]=importdata('daneuczace.txt');
[daneWalidacyjne,~]=importdata('danewalidacyjne.txt');
%%charakterystyka y(u) dla danych uczących
%{
figure
plot(daneUczace(:,1),daneUczace(:,2),'.g');
xlabel('u');
ylabel('y');
%}

%%rysunek danych uczących
%{
plot(daneUczace(:,1));
hold on
plot(daneUczace(:,2));
xlabel('k - numer próbki');
ylabel('Amplituda');
legend('sygnał wejściowy u(k)','sygnał wejściowy y(k)');
%}

%%charakterystyka y(u) dla danych walidacyjnych
%{
figure
plot(daneWalidacyjne(:,1),daneWalidacyjne(:,2),'.r');
xlabel('u');
ylabel('y');
%}
%%rysunek danych walidacyjnych
%{
plot(daneWalidacyjne(:,1));
hold on
plot(daneWalidacyjne(:,2));
xlabel('k - numer próbki');
ylabel('Amplituda');
legend('sygnał wejściowy u(k)','sygnał wejściowy y(k)');
%}


degree=15;
Y_training=daneUczace(:,2);
M_training=ones(100,degree+1);
for i=1:degree
    M_training(:,i+1)=daneUczace(:,1).^i;
end
%W=M\Y z MNK:
W_training=M_training\Y_training

u=[-1:0.01:1];
y=W_training(1);
for j=1:degree
    y=y+W_training(j+1)*u.^j;
end 

%%charakt. stat. na tle danych we/wy
%{
figure
plot(u,y)
hold on
%plot(daneUczace(:,1),daneUczace(:,2),'.g')
plot(daneWalidacyjne(:,1),daneWalidacyjne(:,2),'.r')
xlabel('u')
ylabel('y');
%}

Ymod_training=M_training*W_training;
% %wyjście modelu na tle danych uczących
%{
plot(Ymod_training(:));
hold on
plot(daneUczace(:,1));
hold on
plot(daneUczace(:,2));
xlabel('k - numer próbki');
ylabel('Amplituda');
legend('wyjście modelu y_m_o_d(k)','sygnał wejściowy u(k)','sygnał wyjściowy y(k)');
%}
M_validation=ones(100,degree+1);
for k=1:degree
    M_validation(:,k+1)=daneWalidacyjne(:,1).^k;
end

Ymod_validation=M_validation*W_training;
%%wyjście modelu na tle danych weryfikujących
%{
plot(Ymod_validation(:));
hold on
plot(daneWalidacyjne(:,1));
hold on
plot(daneWalidacyjne(:,2));
xlabel('k - numer próbki');
ylabel('Amplituda');
legend('wyjście modelu y_m_o_d(k)','sygnał wejściowy u(k)','sygnał wyjściowy y(k)');
%}

Y_validation=daneWalidacyjne(:,2);
trainingError=(norm(M_training*W_training-Y_training))^2
validationError=(norm(M_validation*W_training-Y_validation))^2

%print('Tp01.png','-dpng','-r400')