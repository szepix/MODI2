clear all;
close all;
[trainingData_D,~]=importdata('danedynucz37.txt');
[validationData_D,~]=importdata('danedynwer37.txt');


% 
% plot(trainingData_D(:,1));
% title("dane uczace")
% hold on
% plot(trainingData_D(:,2));
% xlabel('k - numer próbki');
% legend('wejœcie modelu u(k)','wyjœcie modelu y(k)');
% figure
% plot(validationData_D(:,1));
% hold on
% plot(validationData_D(:,2));
% xlabel('k - numer próbki');
% legend('wejœcie modelu u(k)','wyjœcie modelu y(k)');

%
N=3; %rz¹d dynamiki
degree_D=4; %rz¹d wielomianu
P=length(trainingData_D);
Y_training_D=trainingData_D(N+1:P,2);

%Tworzenie uniwersalnej macierzy M
M_training_D=ones(length(trainingData_D)-N, 2*N*degree_D);
for i=1:N
    for j=1:degree_D
        M_training_D(:,degree_D*i-degree_D+j)=trainingData_D((N-(i-1)):(P-i),1).^j;
        M_training_D(:,degree_D*i-degree_D+j+N*degree_D)=trainingData_D((N-(i-1)):(P-i),2).^j;
    end
end
W_training_D=M_training_D\Y_training_D;
n=length(W_training_D)/2;

%%B
%%
%model liniowy bez rekurencji
y_mod_ARX = zeros(P,1);
for k=N+1:P
    for m=1:N
        %y_mod_ARX(k)=y_mod_ARX(k)+W_training_D(m)*trainingData_D(k-m,1)+W_training_D(m+n)*trainingData_D(k-m,2);
        y_mod_ARX(k)=y_mod_ARX(k)+W_training_D(m)*validationData_D(k-m,1)+W_training_D(m+n)*validationData_D(k-m,2);
    end
end

%model liniowy z rekurencj¹
y_mod_OE = zeros(P,1);
for kr=N+1:P
    for mr=1:N
        %y_mod_OE(kr)=y_mod_OE(kr)+W_training_D(mr)*trainingData_D(kr-mr,1)+W_training_D(mr+n)*y_mod_OE(kr-mr);
        y_mod_OE(kr)=y_mod_OE(kr)+W_training_D(mr)*validationData_D(kr-mr,1)+W_training_D(mr+n)*y_mod_OE(kr-mr);
    end
end

Y_validation_D=validationData_D(N+1:P,2);
%b³êdy modeli bez rekurencji (odkomentowaæ odpowiednie y_mod_ARX):
%trainingError_ARX=(norm(y_mod_ARX(N+1:P)-Y_training_D()))^2
validationError_ARX=(norm(y_mod_ARX(N+1:P)-Y_validation_D))^2;

%b³êdy modeli z rekurencj¹ (odkomentowaæ odpowiednie y_mod_OE):
%trainingError_OE=(norm(y_mod_OE(N+1:P)-Y_training_D()))^2
validationError_OE=(norm(y_mod_OE(N+1:P)-Y_validation_D))^2;

% figure
% %plot(trainingData_D(:,1));
% plot(validationData_D(:,1));
% hold on
% %plot(trainingData_D(:,2));
% plot(validationData_D(:,2));
% hold on
% plot(y_mod_ARX(:));
% plot(y_mod_OE(:));
% ylim([-2 6])
% xlabel('k - numer próbki');
% %legend('wejœcie modelu u(k), dane ucz¹ce','wyjœcie modelu y(k), dane ucz¹ce','model liniowy rzêdu 3 bez rekurencji','model liniowy rzêdu 3 z rekurencj¹');
% legend('wejœcie modelu u(k), dane waliduj¹ce','wyjœcie modelu y(k), dane waliduj¹ce','model liniowy rzêdu 3 bez rekurencji','model liniowy rzêdu 3 z rekurencj¹');
% 
%%
%model liniowy bez rekurencji
y_tr_ARX = zeros(P,1);
y_val_ARX = zeros(P,1);
y_tr_OE = zeros(P,1);
y_val_OE = zeros(P,1);
W(:)=W_training_D(:);
U_tr(:)=trainingData_D(:,1);
Y_tr(:)=trainingData_D(:,2);
U_val(:)=validationData_D(:,1);
Y_val(:)=validationData_D(:,2);

%bez rekurencji
    if N==1
        for k=N+1:P
            if degree_D==2           
                y_tr_ARX(k)=y_tr_ARX(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*Y_tr(k-1)+W(4)*Y_tr(k-1)^2;
                y_val_ARX(k)=y_val_ARX(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*Y_val(k-1)+W(4)*Y_val(k-1)^2;
            elseif degree_D==3
                y_tr_ARX(k)=y_tr_ARX(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3+W(4)*Y_tr(k-1)+W(5)*Y_tr(k-1)^2+W(6)*Y_tr(k-1)^3;
                y_val_ARX(k)=y_val_ARX(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3+W(4)*Y_val(k-1)+W(5)*Y_val(k-1)^2+W(6)*Y_val(k-1)^3;
            elseif degree_D==4
                y_tr_ARX(k)=y_tr_ARX(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3+W(4)*U_tr(k-1)^4+W(5)*Y_tr(k-1)+W(6)*Y_tr(k-1)^2+W(7)*Y_tr(k-1)^3+W(8)*Y_tr(k-1)^4;
                y_val_ARX(k)=y_val_ARX(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3+W(4)*U_val(k-1)^4+W(5)*Y_val(k-1)+W(6)*Y_val(k-1)^2+W(7)*Y_val(k-1)^3+W(8)*Y_val(k-1)^4;
            end
        end
    elseif N==2
        for k=N+1:P
            if degree_D==2
                y_tr_ARX(k)=y_tr_ARX(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2 + W(3)*U_tr(k-2)+W(4)*U_tr(k-2)^2+...
                    W(5)*Y_tr(k-1)+W(6)*Y_tr(k-1)^2 + W(7)*Y_tr(k-2)+W(8)*Y_tr(k-2)^2;
                y_val_ARX(k)=y_val_ARX(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2 + W(3)*U_val(k-2)+W(4)*U_val(k-2)^2+...
                    W(5)*Y_val(k-1)+W(6)*Y_val(k-1)^2 + W(7)*Y_val(k-2)+W(8)*Y_val(k-2)^2;
            elseif degree_D==3
                y_tr_ARX(k)=y_tr_ARX(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3+...
                    W(4)*U_tr(k-2)+W(5)*U_tr(k-2)^2+W(6)*U_tr(k-2)^3+...
                    W(7)*Y_tr(k-1)+W(8)*Y_tr(k-1)^2+W(9)*Y_tr(k-1)^3+...
                    W(10)*Y_tr(k-2)+W(11)*Y_tr(k-2)^2+W(12)*Y_tr(k-2)^3;
                y_val_ARX(k)=y_val_ARX(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3+...
                    W(4)*U_val(k-2)+W(5)*U_val(k-2)^2+W(6)*U_val(k-2)^3+...
                    W(7)*Y_val(k-1)+W(8)*Y_val(k-1)^2+W(9)*Y_val(k-1)^3+...
                    W(10)*Y_val(k-2)+W(11)*Y_val(k-2)^2+W(12)*Y_val(k-2)^3;
            elseif degree_D==4
                y_tr_ARX(k)=y_tr_ARX(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3+W(4)*U_tr(k-1)^4+...
                    W(5)*U_tr(k-2)+W(6)*U_tr(k-2)^2+W(7)*U_tr(k-2)^3+W(8)*U_tr(k-2)^4+...
                    W(9)*Y_tr(k-1)+W(10)*Y_tr(k-1)^2+W(11)*Y_tr(k-1)^3+W(12)*Y_tr(k-1)^4+...
                    W(13)*Y_tr(k-2)+W(14)*Y_tr(k-2)^2+W(15)*Y_tr(k-2)^3+W(16)*Y_tr(k-2)^4;
                y_val_ARX(k)=y_val_ARX(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3+W(4)*U_val(k-1)^4+...
                    W(5)*U_val(k-2)+W(6)*U_val(k-2)^2+W(7)*U_val(k-2)^3+W(8)*U_val(k-2)^4+...
                    W(9)*Y_val(k-1)+W(10)*Y_val(k-1)^2+W(11)*Y_val(k-1)^3+W(12)*Y_val(k-1)^4+...
                    W(13)*Y_val(k-2)+W(14)*Y_val(k-2)^2+W(15)*Y_val(k-2)^3+W(16)*Y_val(k-2)^4;
            end
        end
    elseif N==3
        for k=N+1:P
            if degree_D==2
                y_tr_ARX(k)=y_tr_ARX(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2 + W(3)*U_tr(k-2)+W(4)*U_tr(k-2)^2+...
                    W(5)*U_tr(k-3)+W(6)*U_tr(k-3)^2+W(7)*Y_tr(k-1)+W(8)*Y_tr(k-1)^2 +...
                    W(9)*Y_tr(k-2)+W(10)*Y_tr(k-2)^2+W(11)*Y_tr(k-3)+W(12)*Y_tr(k-3)^2;
                y_val_ARX(k)=y_val_ARX(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2 + W(3)*U_val(k-2)+W(4)*U_val(k-2)^2+...
                    W(5)*U_val(k-3)+W(6)*U_val(k-3)^2+W(7)*Y_val(k-1)+W(8)*Y_val(k-1)^2 +...
                    W(9)*Y_val(k-2)+W(10)*Y_val(k-2)^2+W(11)*Y_val(k-3)+W(12)*Y_val(k-3)^2;
            elseif degree_D==3
                y_tr_ARX(k)=y_tr_ARX(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3 + W(4)*U_tr(k-2)+W(5)*U_tr(k-2)^2+W(6)*U_tr(k-2)^3+...
                    W(7)*U_tr(k-3)+W(8)*U_tr(k-3)^2+W(9)*U_tr(k-3)^3+W(10)*Y_tr(k-1)+W(11)*Y_tr(k-1)^2+W(12)*Y_tr(k-1)^3 +...
                    W(13)*Y_tr(k-2)+W(14)*Y_tr(k-2)^2+W(15)*Y_tr(k-2)^3 + W(16)*Y_tr(k-3)+W(17)*Y_tr(k-3)^2+W(18)*Y_tr(k-3)^3;
                y_val_ARX(k)=y_val_ARX(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3 + W(4)*U_val(k-2)+W(5)*U_val(k-2)^2+W(6)*U_val(k-2)^3+...
                    W(7)*U_val(k-3)+W(8)*U_val(k-3)^2+W(9)*U_val(k-3)^3+W(10)*Y_val(k-1)+W(11)*Y_val(k-1)^2+W(12)*Y_val(k-1)^3 +...
                    W(13)*Y_val(k-2)+W(14)*Y_val(k-2)^2+W(15)*Y_val(k-2)^3 + W(16)*Y_val(k-3)+W(17)*Y_val(k-3)^2+W(18)*Y_val(k-3)^3;
            elseif degree_D==4
                y_tr_ARX(k)=y_tr_ARX(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3+W(4)*U_tr(k-1)^4 +...
                    W(5)*U_tr(k-2)+W(6)*U_tr(k-2)^2+W(7)*U_tr(k-2)^3+W(8)*U_tr(k-2)^4+...
                    W(9)*U_tr(k-3)+W(10)*U_tr(k-3)^2+W(11)*U_tr(k-3)^3+W(12)*U_tr(k-3)^4+...
                    W(13)*Y_tr(k-1)+W(14)*Y_tr(k-1)^2+W(15)*Y_tr(k-1)^3+W(16)*Y_tr(k-1)^4 +...
                    W(17)*Y_tr(k-2)+W(18)*Y_tr(k-2)^2+W(19)*Y_tr(k-2)^3+W(20)*Y_tr(k-2)^4 +...
                    W(21)*Y_tr(k-3)+W(22)*Y_tr(k-3)^2+W(23)*Y_tr(k-3)^3+W(24)*Y_tr(k-3)^4;
                y_val_ARX(k)=y_val_ARX(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3+W(4)*U_val(k-1)^4 +...
                    W(5)*U_val(k-2)+W(6)*U_val(k-2)^2+W(7)*U_val(k-2)^3+W(8)*U_val(k-2)^4+...
                    W(9)*U_val(k-3)+W(10)*U_val(k-3)^2+W(11)*U_val(k-3)^3+W(12)*U_val(k-3)^4+...
                    W(13)*Y_val(k-1)+W(14)*Y_val(k-1)^2+W(15)*Y_val(k-1)^3+W(16)*Y_val(k-1)^4 +...
                    W(17)*Y_val(k-2)+W(18)*Y_val(k-2)^2+W(19)*Y_val(k-2)^3+W(20)*Y_val(k-2)^4 +...
                    W(21)*Y_val(k-3)+W(22)*Y_val(k-3)^2+W(23)*Y_val(k-3)^3+W(24)*Y_val(k-3)^4;
            end 
        end
    end
    
 %z rekurencj¹
    if N==1
        for k=N+1:P
            if degree_D==2           
                y_tr_OE(k)=y_tr_OE(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*y_tr_OE(k-1)+W(4)*y_tr_OE(k-1)^2;
                y_val_OE(k)=y_val_OE(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*y_val_OE(k-1)+W(4)*y_val_OE(k-1)^2;
            elseif degree_D==3
                y_tr_OE(k)=y_tr_OE(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3+W(4)*y_tr_OE(k-1)+W(5)*y_tr_OE(k-1)^2+W(6)*y_tr_OE(k-1)^3;
                y_val_OE(k)=y_val_OE(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3+W(4)*y_val_OE(k-1)+W(5)*y_val_OE(k-1)^2+W(6)*y_val_OE(k-1)^3;
            elseif degree_D==4
                y_tr_OE(k)=y_tr_OE(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3+W(4)*U_tr(k-1)^4+W(5)*y_tr_OE(k-1)+W(6)*y_tr_OE(k-1)^2+W(7)*y_tr_OE(k-1)^3+W(8)*y_tr_OE(k-1)^4;
                y_val_OE(k)=y_val_OE(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3+W(4)*U_val(k-1)^4+W(5)*y_val_OE(k-1)+W(6)*y_val_OE(k-1)^2+W(7)*y_val_OE(k-1)^3+W(8)*y_val_OE(k-1)^4;
            end
        end
    elseif N==2
        for k=N+1:P
            if degree_D==2
                y_tr_OE(k)=y_tr_OE(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2 + W(3)*U_tr(k-2)+W(4)*U_tr(k-2)^2+...
                    W(5)*y_tr_OE(k-1)+W(6)*y_tr_OE(k-1)^2 + W(7)*y_tr_OE(k-2)+W(8)*y_tr_OE(k-2)^2;
                y_val_OE(k)=y_val_OE(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2 + W(3)*U_val(k-2)+W(4)*U_val(k-2)^2+...
                    W(5)*y_val_OE(k-1)+W(6)*y_val_OE(k-1)^2 + W(7)*y_val_OE(k-2)+W(8)*y_val_OE(k-2)^2;
            elseif degree_D==3
                y_tr_OE(k)=y_tr_OE(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3+...
                    W(4)*U_tr(k-2)+W(5)*U_tr(k-2)^2+W(6)*U_tr(k-2)^3+...
                    W(7)*y_tr_OE(k-1)+W(8)*y_tr_OE(k-1)^2+W(9)*y_tr_OE(k-1)^3+...
                    W(10)*y_tr_OE(k-2)+W(11)*y_tr_OE(k-2)^2+W(12)*y_tr_OE(k-2)^3;
                y_val_OE(k)=y_val_OE(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3+...
                    W(4)*U_val(k-2)+W(5)*U_val(k-2)^2+W(6)*U_val(k-2)^3+...
                    W(7)*y_val_OE(k-1)+W(8)*y_val_OE(k-1)^2+W(9)*y_val_OE(k-1)^3+...
                    W(10)*y_val_OE(k-2)+W(11)*y_val_OE(k-2)^2+W(12)*y_val_OE(k-2)^3;
            elseif degree_D==4
                y_tr_OE(k)=y_tr_OE(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3+W(4)*U_tr(k-1)^4+...
                    W(5)*U_tr(k-2)+W(6)*U_tr(k-2)^2+W(7)*U_tr(k-2)^3+W(8)*U_tr(k-2)^4+...
                    W(9)*y_tr_OE(k-1)+W(10)*y_tr_OE(k-1)^2+W(11)*y_tr_OE(k-1)^3+W(12)*y_tr_OE(k-1)^4+...
                    W(13)*y_tr_OE(k-2)+W(14)*y_tr_OE(k-2)^2+W(15)*y_tr_OE(k-2)^3+W(16)*y_tr_OE(k-2)^4;
                y_val_OE(k)=y_val_OE(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3+W(4)*U_val(k-1)^4+...
                    W(5)*U_val(k-2)+W(6)*U_val(k-2)^2+W(7)*U_val(k-2)^3+W(8)*U_val(k-2)^4+...
                    W(9)*y_val_OE(k-1)+W(10)*y_val_OE(k-1)^2+W(11)*y_val_OE(k-1)^3+W(12)*y_val_OE(k-1)^4+...
                    W(13)*y_val_OE(k-2)+W(14)*y_val_OE(k-2)^2+W(15)*y_val_OE(k-2)^3+W(16)*y_val_OE(k-2)^4;
            end
        end
    elseif N==3
        for k=N+1:P
            if degree_D==2
                y_tr_OE(k)=y_tr_OE(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2 + W(3)*U_tr(k-2)+W(4)*U_tr(k-2)^2+...
                    W(5)*U_tr(k-3)+W(6)*U_tr(k-3)^2+W(7)*y_tr_OE(k-1)+W(8)*y_tr_OE(k-1)^2 +...
                    W(9)*y_tr_OE(k-2)+W(10)*y_tr_OE(k-2)^2+W(11)*y_tr_OE(k-3)+W(12)*y_tr_OE(k-3)^2;
                y_val_OE(k)=y_val_OE(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2 + W(3)*U_val(k-2)+W(4)*U_val(k-2)^2+...
                    W(5)*U_val(k-3)+W(6)*U_val(k-3)^2+W(7)*y_val_OE(k-1)+W(8)*y_val_OE(k-1)^2 +...
                    W(9)*y_val_OE(k-2)+W(10)*y_val_OE(k-2)^2+W(11)*y_val_OE(k-3)+W(12)*y_val_OE(k-3)^2;
            elseif degree_D==3
                y_tr_OE(k)=y_tr_OE(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3 + W(4)*U_tr(k-2)+W(5)*U_tr(k-2)^2+W(6)*U_tr(k-2)^3+...
                    W(7)*U_tr(k-3)+W(8)*U_tr(k-3)^2+W(9)*U_tr(k-3)^3+W(10)*y_tr_OE(k-1)+W(11)*y_tr_OE(k-1)^2+W(12)*y_tr_OE(k-1)^3 +...
                    W(13)*y_tr_OE(k-2)+W(14)*y_tr_OE(k-2)^2+W(15)*y_tr_OE(k-2)^3 + W(16)*y_tr_OE(k-3)+W(17)*y_tr_OE(k-3)^2+W(18)*y_tr_OE(k-3)^3;
                y_val_OE(k)=y_val_OE(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3 + W(4)*U_val(k-2)+W(5)*U_val(k-2)^2+W(6)*U_val(k-2)^3+...
                    W(7)*U_val(k-3)+W(8)*U_val(k-3)^2+W(9)*U_val(k-3)^3+W(10)*y_val_OE(k-1)+W(11)*y_val_OE(k-1)^2+W(12)*y_val_OE(k-1)^3 +...
                    W(13)*y_val_OE(k-2)+W(14)*y_val_OE(k-2)^2+W(15)*y_val_OE(k-2)^3 + W(16)*y_val_OE(k-3)+W(17)*y_val_OE(k-3)^2+W(18)*y_val_OE(k-3)^3;
            elseif degree_D==4
                y_tr_OE(k)=y_tr_OE(k)+W(1)*U_tr(k-1)+W(2)*U_tr(k-1)^2+W(3)*U_tr(k-1)^3+W(4)*U_tr(k-1)^4 +...
                    W(5)*U_tr(k-2)+W(6)*U_tr(k-2)^2+W(7)*U_tr(k-2)^3+W(8)*U_tr(k-2)^4+...
                    W(9)*U_tr(k-3)+W(10)*U_tr(k-3)^2+W(11)*U_tr(k-3)^3+W(12)*U_tr(k-3)^4+...
                    W(13)*y_tr_OE(k-1)+W(14)*y_tr_OE(k-1)^2+W(15)*y_tr_OE(k-1)^3+W(16)*y_tr_OE(k-1)^4 +...
                    W(17)*y_tr_OE(k-2)+W(18)*y_tr_OE(k-2)^2+W(19)*y_tr_OE(k-2)^3+W(20)*y_tr_OE(k-2)^4 +...
                    W(21)*y_tr_OE(k-3)+W(22)*y_tr_OE(k-3)^2+W(23)*y_tr_OE(k-3)^3+W(24)*y_tr_OE(k-3)^4;
                y_val_OE(k)=y_val_OE(k)+W(1)*U_val(k-1)+W(2)*U_val(k-1)^2+W(3)*U_val(k-1)^3+W(4)*U_val(k-1)^4 +...
                    W(5)*U_val(k-2)+W(6)*U_val(k-2)^2+W(7)*U_val(k-2)^3+W(8)*U_val(k-2)^4+...
                    W(9)*U_val(k-3)+W(10)*U_val(k-3)^2+W(11)*U_val(k-3)^3+W(12)*U_val(k-3)^4+...
                    W(13)*y_val_OE(k-1)+W(14)*y_val_OE(k-1)^2+W(15)*y_val_OE(k-1)^3+W(16)*y_val_OE(k-1)^4 +...
                    W(17)*y_val_OE(k-2)+W(18)*y_val_OE(k-2)^2+W(19)*y_val_OE(k-2)^3+W(20)*y_val_OE(k-2)^4 +...
                    W(21)*y_val_OE(k-3)+W(22)*y_val_OE(k-3)^2+W(23)*y_val_OE(k-3)^3+W(24)*y_val_OE(k-3)^4;
            end 
        end
    end
    
%b³êdy modeli bez rekurencji (odkomentowaæ odpowiednie y_mod_ARX):
trError_ARX=(norm(y_tr_ARX(N+1:P)-Y_training_D()))^2
valError_ARX=(norm(y_val_ARX(N+1:P)-Y_validation_D))^2

%b³êdy modeli z rekurencj¹ (odkomentowaæ odpowiednie y_mod_OE):
trError_OE=(norm(y_tr_OE(N+1:P)-Y_training_D))^2
valError_OE=(norm(y_val_OE(N+1:P)-Y_validation_D))^2

%wykres - modele na tle danych ucz¹cych

plot(trainingData_D(:,1));
hold on
plot(trainingData_D(:,2));
hold on
plot(y_tr_ARX(:));
hold on
plot(y_tr_OE(:));
ylim([-1.5,6]);
xlabel('k - numer próbki');
ylabel('Amplituda');
legend('wejœcie modelu u(k), dane ucz¹ce','wyjœcie modelu y(k), dane ucz¹ce',...
     'model nieliniowy rzêdu 3, st. wiel. 4 bez rekurencji','model nieliniowy rzêdu 3, st. wiel. 4 z rekurencj¹');
title('Modele na tle danych ucz¹cych');

%wykres - modele na tle danych weryfikuj¹cych
figure;
plot(validationData_D(:,1));
hold on
plot(validationData_D(:,2));
hold on
plot(y_val_ARX(:));
hold on
plot(y_val_OE(:));
ylim([-1.5,6]);
xlabel('k - numer próbki');
ylabel('Amplituda');
legend('wejœcie modelu u(k), dane waliduj¹ce','wyjœcie modelu y(k), dane waliduj¹ce',...
    'model nieliniowy rzêdu 3, st. wiel. 4 bez rekurencji','model nieliniowy rzêdu 3, st. wiel. 4 z rekurencj¹');
title('Modele na tle danych waliduj¹cych');