function [X,E,LIMIT] = relaxation(A,B,W)
% A SE DECOMPOSE COMME A = D + L + U, D Diagonale, L Partie strictement inf
% La technique de relaxation utilise une matrice PI (M^(-1)*N) que l'on
% �l�ve � de fortres puissance et qui va selon son rayon spectral rho
% converger tr�s vite (rho<1) ou ne jamais converger (rho>1) Plus rho est
% petit, plus le processus iterarif ira vite.
% Concr�tement, on pond�re la solution de Gauss-Seidel pour s'approcher
% plus vite --> Facteur d'optimisation de convergence w
% U partie strictement sup
LINE = size(A,1); %Taille du vecteur colonne X en (1,1)

w=omega(A,B); %On calcule le w permettant la meilleure convergence (minimisation du rs rho)

D=diag(diag(A)); %Matrice diagonale (partie diagonale de A)
L=tril(A,-1); %Matrice strictement inf�rieure venant de A
U=triu(A,1); %Matrice strictement sup�rieure venant de A

X = rand(LINE,1); %Solution de rang 0 (rang m+1 dans la suite des calculs) --> Quelconque au rang (0)

LIMIT=0; %On �vite les boucles infinis

%On calcule les param�tres qui nous permettront de boucler b�tement jusqu'�
%�tre assez proche de la solution. Ils sont d�pendant de w qui est d�j� trouv�, rien de bien difficile donc � ce moment du code.

PI = ((D+w*L)^(-1))*((1-w)*D-w*U); %Calcul du PI avec la valeur de w correspondant
Beta=((D+L*w)^(-1))*w*B; %Calcul du coef Beta qui vient dans la formule X(m+1)=PI*X(m)+Beta

while (max(abs((A*X-B))) > W) && LIMIT < 10000000
        X=PI*X+Beta; %Calcul du X(m+1) avec X(m)
        LIMIT=LIMIT+1; %V�rification nbIt�ration et non boucle infini
end 

E=abs(A*X-B); %On renvoi l'erreur pour v�rifier

end