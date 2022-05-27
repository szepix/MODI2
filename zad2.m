clear all;
close all;
[daneTreningowe_D,~]=importdata('danedynucz37.txt');
[daneWalidacyjne_D,~]=importdata('danedynwer37.txt');


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
N=30; %rz¹d dynamiki
rzad=5; %rz¹d wielomianu
P=length(daneTreningowe_D);
Y_training_D=daneTreningowe_D(N+1:P,2);

%Tworzenie uniwersalnej macierzy M
M_training_D=ones(length(daneTreningowe_D)-N, 2*N*rzad);
for i=1:N
    for j=1:rzad
        M_training_D(:,rzad*i-rzad+j)=daneTreningowe_D((N-(i-1)):(P-i),1).^j;
        M_training_D(:,rzad*i-rzad+j+N*rzad)=daneTreningowe_D((N-(i-1)):(P-i),2).^j;
    end
end
W_training_D=M_training_D\Y_training_D;
n=length(W_training_D)/2;


%%
%model liniowy bez rekurencji
y_mod_ARX = zeros(P,1);
y_mod_OE = zeros(P,1);
y_mod_ARX_val = zeros(P,1);
y_mod_OE_val = zeros(P,1);
for k=1:N
y_mod_OE(k) = daneTreningowe_D(k,2);
end

for k=N+1:P
    for m=1:N
        y_mod_ARX(k)=y_mod_ARX(k)+W_training_D(m)*daneTreningowe_D(k-m,1)+W_training_D(m+n)*daneTreningowe_D(k-m,2);
        y_mod_ARX_val(k)=y_mod_ARX_val(k)+W_training_D(m)*daneWalidacyjne_D(k-m,1)+W_training_D(m+n)*daneWalidacyjne_D(k-m,2);
    end
end

%model liniowy z rekurencj¹

for kr=N+1:P
    for mr=1:N
        y_mod_OE(kr)=y_mod_OE(kr)+W_training_D(mr)*daneTreningowe_D(kr-mr,1)+W_training_D(mr+n)*y_mod_OE(kr-mr);
        y_mod_OE_val(kr)=y_mod_OE_val(kr)+W_training_D(mr)*daneWalidacyjne_D(kr-mr,1)+W_training_D(mr+n)*y_mod_OE_val(kr-mr);
    end
end

Y_validation_D=daneWalidacyjne_D(N+1:P,2);
% %b³êdy modeli bez rekurencji:
% trainingError_ARX=(norm(y_mod_ARX(N+1:P)-Y_training_D()))^2
% validationError_ARX=(norm(y_mod_ARX_val(N+1:P)-Y_validation_D))^2
% 
% %b³êdy modeli z rekurencj¹:
% trainingError_OE=(norm(y_mod_OE(N+1:P)-Y_training_D()))^2
% validationError_OE=(norm(y_mod_OE_val(N+1:P)-Y_validation_D))^2

% figure
% plot(trainingData_D(:,1));
% hold on
% plot(trainingData_D(:,2));
% plot(y_mod_ARX(:));
% plot(y_mod_OE(:));
% legend('wejœcie modelu u(k), dane ucz¹ce','wyjœcie modelu y(k), dane ucz¹ce','model liniowy rzêdu 4 bez rekurencji','model liniowy rzêdu 4 z rekurencj¹');
% ylim([-2 6])
% xlabel('k - numer próbki');
% 
% figure
% plot(validationData_D(:,1));
% hold on
% plot(validationData_D(:,2));
% plot(y_mod_ARX_val(:));
% plot(y_mod_OE_val(:));
% ylim([-2 6])
% xlabel('k - numer próbki');
% legend('wejœcie modelu u(k), dane waliduj¹ce','wyjœcie modelu y(k), dane waliduj¹ce','model liniowy rzêdu 4 bez rekurencji','model liniowy rzêdu 4 z rekurencj¹');

%%
%model liniowy bez rekurencji
y_tr_ARX = zeros(P,1);
y_val_ARX = zeros(P,1);
y_tr_OE = zeros(P,1);
y_val_OE = zeros(P,1);
W(:)=W_training_D(:);
U_tr(:)=daneTreningowe_D(:,1);
Y_tr(:)=daneTreningowe_D(:,2);
U_val(:)=daneWalidacyjne_D(:,1);
Y_val(:)=daneWalidacyjne_D(:,2);
for k=1:N
y_tr_OE(k) = daneTreningowe_D(k,2);
y_val_OE(k) = daneWalidacyjne_D(k,2);
end
kmax = length(Y_tr);
kmin = 1+N;

M_ucz_no_rek = zeros(kmax,1);
M_wer_no_rek = zeros(kmax,1);
M_ucz_rek = zeros(kmax,1);
M_wer_rek = zeros(kmax,1);

%Liczenie wartoœci modelu
i_u = 1;
i_y = 1;

for k = kmin:kmax
   for nk = 1:N
        for sk = 1:rzad
            M_ucz_no_rek(k,i_u) = U_tr(k-nk)^sk;
            M_wer_no_rek(k,i_u) = U_val(k-nk)^sk;
            M_ucz_rek(k,i_u) = U_tr(k-nk)^sk;
            M_wer_rek(k,i_u) = U_val(k-nk)^sk;
            i_u = i_u + 1;
        end
   end 
   for nk = 1:N
        for sk = 1:rzad
            M_ucz_no_rek(k,i_y+N*rzad) = Y_tr(k-nk)^sk;
            M_wer_no_rek(k,i_y+N*rzad) = Y_val(k-nk)^sk;
            M_ucz_rek(k,i_y+N*rzad) = y_tr_OE(k-nk)^sk;
            M_wer_rek(k,i_y+N*rzad) = y_val_OE(k-nk)^sk;
            i_y = i_y + 1;
        end
   end
   i_u = 1;
   i_y = 1;
   y_tr_OE(k) = M_ucz_rek(k,:)* W';
   y_val_OE(k) = M_wer_rek(k,:)* W';
end
y_tr_ARX =  M_ucz_no_rek * W';
y_val_ARX = M_wer_no_rek * W';
    
%b³êdy modeli bez rekurencji :
trError_ARX=(norm(y_tr_ARX(N+1:P)-Y_training_D()))^2
valError_ARX=(norm(y_val_ARX(N+1:P)-Y_validation_D))^2

%b³êdy modeli z rekurencj¹ :
trError_OE=(norm(y_tr_OE(N+1:P)-Y_training_D))^2
valError_OE=(norm(y_val_OE(N+1:P)-Y_validation_D))^2

% %wykres - modele na tle danych ucz¹cych

% plot(daneTreningowe_D(:,1));
% hold on
% plot(daneTreningowe_D(:,2));
% hold on
% plot(y_tr_ARX(:));
% hold on
% plot(y_tr_OE(:));
% ylim([-1.5,6]);
% xlabel('k - numer próbki');
% ylabel('Amplituda');
% legend('wejœcie modelu u(k), dane ucz¹ce','wyjœcie modelu y(k), dane ucz¹ce', ['model nieliniowy rzêdu ', sprintf('%g',N), 'st. wiel. ',sprintf('%g',rzad'),' bez rekurencji'],['model nieliniowy rzêdu ', sprintf('%g',N), 'st. wiel. ',sprintf('%g',rzad'),' z rekurencj¹']);
% title('Modele na tle danych ucz¹cych');
% 
% %wykres - modele na tle danych weryfikuj¹cych
% figure;
% plot(daneWalidacyjne_D(:,1));
% hold on
% plot(daneWalidacyjne_D(:,2));
% hold on
% plot(y_val_ARX(:));
% hold on
% plot(y_val_OE(:));
% ylim([-1.5,6]);
% xlabel('k - numer próbki');
% ylabel('Amplituda');
% legend('wejœcie modelu u(k), dane waliduj¹ce','wyjœcie modelu y(k), dane waliduj¹ce',['model nieliniowy rzêdu ', sprintf('%g',N), 'st. wiel. ',sprintf('%g',rzad'),' bez rekurencji'],['model nieliniowy rzêdu ', sprintf('%g',N), 'st. wiel. ',sprintf('%g',rzad'),' z rekurencj¹']);
% title('Modele na tle danych waliduj¹cych');