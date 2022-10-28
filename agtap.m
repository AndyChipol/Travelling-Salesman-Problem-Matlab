function [ruta,costo] = agtap(Npob,pmut,gen,nameFile)
clc
ruta = [];costo = [];
%cargar base de datos
datos = load(nameFile);

s = size(datos); %tamaño de los datos
p = s(1,1); %almacenar el numero de ciudades
inicial = []; %vector inicial de las ciudades
for i = 1:p
    inicial(i) = i;
end
inicial; %verificar vector inicial
%almancenar la poblacion Inicial con permutaciones del vector inicial
pobInicial = [];

for i=1:Npob
    i
    pobInicial(i,:) = permutacion(inicial);
end

% CICLO DE HAMIlTON 
% CAMBIAAR
pobAuxiliar = pobInicial;
tam = size(pobInicial);
tamVector = tam(1,1);
A = zeros(tamVector,1);
%%Creacion de la poblacion Inicial con la evaluacion
for i = 1: tamVector
    suma = 0;
    for j= 1:(p - 1)
        ki = pobInicial(i,j);  ke = pobInicial(i,j+1);
        d1 = (datos(ke,2) - datos(ki,2))^2; d2 = (datos(ke,3) - datos(ki,3))^2;
        res =  sqrt(d1 + d2 );
        suma = suma + res;
    end
    ki = pobInicial(i,p);  ke = pobInicial(i,1);
    d1 = (datos(ke,2) - datos(ki,2))^2; d2 = (datos(ke,3) - datos(ki,3))^2;
    res =  sqrt(d1 + d2 );
    suma = suma + res;
    A(i,1) = suma;
end
%%Uniendo los resultados a la matriz
format('long','g');
pobAuxiliar;
pobFinal = [pobAuxiliar A];
%%Ordenar la Matriz
pobFinal = sortrows(pobFinal,p+1);
%%Cruza Y Mutacion
for i= 1:gen
    i
    %Cruze y mutacion
    ij = 1;
    tamPob = size(pobFinal);
    np = tamPob(1,1);
    for jj = 1 : np/2
        %%Generacion de Pc1 y Pc2
        pc1 = randi([1 p-1],1);
        pc2 = randi([1 p-1],1);
        if(pc1 > pc2)
            aux = pc1;
            pc1 = pc2;
            pc2 = aux;
        end
        while pc1 == pc2
            pc1 = randi([1 p-1],1);
            pc2 = randi([1 p-1],1);
            if(pc1 > pc2)
                aux = pc1;
                pc1 = pc2;
                pc2 = aux;
            end
        end
        
        %%Invertir las parejas
        h1 = pobFinal(ij,1:p);
        h2 = pobFinal(ij+1,1:p);

        intervaloUno = h1(pc1:pc2);
        intervaloDos = h2(pc1:pc2);
        %%invertir parte media
        h1(pc1:pc2) = intervaloDos;
        h2(pc1:pc2) = intervaloUno;

        %%cambiar los elementos
        t = size(intervaloDos);
        t(1,2);
        %     Encontrar indice
        for ii=1: t(1,2)
            inh1 = find(h1 == intervaloDos(ii),1);
            inh2 = find(h2 == intervaloUno(ii),1);

            aux = h1(inh1);
            h1(inh1) = h2(inh2);
            h2(inh2) = aux;
        end

        %%Mutacion
        if rand(1) <= pmut
            pd2 = randi([1 p],1);
            pd1 = randi([1 p],1);

            pos1 = h1(pd1);
            pos2 = h1(pd2);
            h1(pd1) = pos2;
            h1(pd2) = pos1;


            pd2 = randi([1 p],1);
            pd1 = randi([1 p],1);

            pos1 = h2(pd1);
            pos2 = h2(pd2);
            h2(pd1) = pos2;
            h2(pd2) = pos1;
        end

        %%Evaluacion de los hijos
        Hn = [];
        Hn = [Hn;h1;h2];
        ij = ij + 2;
    end
    
        tam = size(Hn);
        tamVector = tam(1,1);
        D = zeros(tamVector,1);
        for i = 1: tamVector
            suma = 0;
            for j= 1:(p - 1)
                ki = Hn(i,j);  ke = Hn(i,j+1);
                d1 = (datos(ke,2) - datos(ki,2))^2; d2 = (datos(ke,3) - datos(ki,3))^2;
                res =  sqrt(d1 + d2 );
                suma = suma + res;
            end
                ki = Hn(i,p);  ke = Hn(i,1);
                d1 = (datos(ke,2) - datos(ki,2))^2; d2 = (datos(ke,3) - datos(ki,3))^2;
                res =  sqrt(d1 + d2 );
                suma = suma + res;
                D(i,1) = suma;
        end
        hnd = [Hn D];
        pobFinal = [pobFinal;hnd];
        pobFinal = sortrows(pobFinal,p+1);
        pobFinal = pobFinal(1:8,:);
        ruta = pobFinal(1,1:p);
        costo = pobFinal(1,p+1:p+1);
end


costo 


%GRAFICO DE MATLAB
vectorRutaX = [];
vectorRutaY = [];
for i=1:p
   s = ruta(1,i);
   vectorRutaX = [vectorRutaX datos(s,2)]; %posicion X
   vectorRutaY = [vectorRutaY datos(s,3)]; %posicion Y
end


x = vectorRutaX;
y = vectorRutaY;
plot(x,y,'-s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6]) ;
