clear
/*
Os algoritmos do Arquivo EDO_MMQ.sce São implementações dos métodos de EULER de primeiro grau e segundo
grau, e Runge-Kutta de primeiro, segundo grau, Runge-Kutta de ordem 4 segundo grau , Algoritmo Ajuste Linear Polinomial,respectivamente.
*/
exec("EDO_MMQ.sce")


function plotEDOResult(x,y,icon,description)
    scf(length(winsid()) +1);
    xname(description);
    plot(x,y,icon);
    legend([description]);

endfunction

function plotResultMMQ(x,a,icon,description,f)
    y = f(a,x) 
    scf(length(winsid()) +1);
    xname(description);
    plot(x,y,icon);
    legend([description]);
    

endfunction

function [a1,a2,a3,a4]= GraficoSolucaoMMQ(t1,t2,y1,y2,description,plotGraphic)

    a1 = poli(t1,y1,1);
    if plotGraphic then
         plotResultMMQ(t1,a1,"o-",description +" h:0.1 MMQ linear",straight);
    end
   


    a2 = poli(t1,y1,2);
    if plotGraphic then
         plotResultMMQ(t1,a2,"o-r",description +" h:0.1 MMQ parábola",parable);
    end
   


    a3 =poli(t2,y2,1);
    if plotGraphic then
         plotResultMMQ(t2,a3,"o-g",description +" h:0.001 MMQ linear",straight);
    end
   


    a4 = poli(t2,y2,2);
    if plotGraphic then
         plotResultMMQ(t2,a4,"o-y",description +" h:0.001 MMQ parábola",parable);
    end
   


endfunction


function [t1,t2,y1,y2] = graficoSolucaoEDO(t,y,EDOFunction,description, plotGraphic)
    
    function g= df1(x,y,z)
        g = z
    endfunction

    function g2 = df2(x,y,z)
        g2 = -3960.55524611549117
    endfunction

    a  = t(10);
    b  = t($);
    y0 = y(10);
    z0 = 0;
    h  = 0.1;

    [t1,y1,v]= EDOFunction(a,b,h,y0,z0,df1,df2)
    if plotGraphic then
         plotEDOResult(t1,y1,"o-", description+ ", h: 0.1");
    end
   
    
   
    h =0.001;
    
    [t2,y2,v]= EDOFunction(a,b,h,y0,z0,df1,df2);
    
    if plotGraphic then
         plotEDOResult(t2,y2,"r", description+ ", h: 0.001");
    end
   
   

    
endfunction

function y =parable(a,x)
    y = a(3)*x^2 + a(2)*x + a(1);
endfunction

function y = straight(a,x)
    y = a(2)*x + a(1);
endfunction

function[t,y] =getData(fileName)
    positions = csvRead(fileName)
    y =  positions(1,2) - positions(:,2)   
    t = (positions(:,3) - positions(1,3))/1000
endfunction


function r= resultadosEDO(Y)
    for i = 2: length(Y)
        r($+1) = Y(i)($)   
    end
    
endfunction

function r= resultadosMMQ(A,t)
    
    for i = 1: length(A)
        
        for j =1: length(A(i))
            
            if length(A(i)(j)) == 2 then
                r($+1) = straight (A(i)(j),t($))
            else
                r($+1) = parable (A(i)(j),t($))
            end
           
         
       end
            
    end
    
endfunction

/*
- Recupeando dados do vídeo
*/
[t,y] = getData("positions.csv")

// T é uma lista que vai ficar com todos os tempos
T = list(t);

// Y é uma lista que vai ficar com todas as posições do eixo y
Y = list(y);

// criando uma lista vazia
A = list();

/*
1- Gráfico da solução (momento em que a bola toca no chão) pelo método de EULER
com passo h=0.1s e h=0.001s, partindo da primeira imagem. (dois gráficos)
*/

/* O sifrão  retorna o ultimo indice de um vetor, Se T tem tamanho 5, então T($) = T(5), logo
   T($+1) = T(6). No caso, utilizei o sifrão para garantir sempre que estou adicioando um elemento na sua ultima posição  
   
*/                                                            // %f é igual a false e  %t é gual a true
[T($+1),T($+1),Y($+1),Y($+1)] = graficoSolucaoEDO(t,y,Euler2,"Euler",%f)



/*
2 – Encontre a solução por MMQ linear e de segundo grau utilizando a malha de
pontos gerada no item anterior. (quatro gráficos)
*/

eulerMMQ = list();                                                             // %f é igual a false e  %t é gual a true
[eulerMMQ($+1),eulerMMQ($+1),eulerMMQ($+1),eulerMMQ($+1)] = GraficoSolucaoMMQ(T(3),T(2),Y(3),Y(2),"Euler",%f);

// uma lista de listas :-) 
A($+1)= eulerMMQ;

/*
3- Gráfico da solução (momento em que a bola toca no chão) pelo método de RK2 com
passo h=0.1s e h=0.001s, partindo da primeira imagem. (dois gráficos)
*/                                                                 // %f é igual a false e  %t é gual a true
[T($+1),T($+1),Y($+1),Y($+1)] = graficoSolucaoEDO(t,y,RK2Order2,"RK2",%f)


/*
4 – Encontre a solução por MMQ linear e de segundo grau utilizando a malha de
pontos gerada no item anterior. (quatro gráficos)
*/
rk2MMQ =list();                                                                              // %f é igual a false e  %t é gual a true
[rk2MMQ($+1),rk2MMQ($+1),rk2MMQ($+1),rk2MMQ($+1)] = GraficoSolucaoMMQ(T(5),T(4),Y(5),Y(4),"RK2",%f);

A($+1)= rk2MMQ;

/*
5- Gráfico da solução (momento em que a bola toca no chão) pelo método de RK4 com
passo h=0.1s e h=0.001s, partindo da primeira imagem. (dois gráficos)
*/                                                                // %f é igual a false e  %t é gual a true
[T($+1),T($+1),Y($+1),Y($+1)] = graficoSolucaoEDO(t,y,RK4Order2,"RK4",%f)

/*
6 – Encontre a solução por MMQ linear e de segundo grau utilizando a malha de
pontos gerada no item anterior. (quatro gráficos)
*/
rk4MMQ =list();                                                                                // %f é igual a false e  %t é gual a true
[rk4MMQ($+1),rk4MMQ($+1),rk4MMQ($+1),rk4MMQ($+1)] = GraficoSolucaoMMQ(T(7),T(6),Y(7),Y(6),"RK4",%f);

A($+1) = rk4MMQ;

resultsMMQ = resultadosMMQ(A,t);
resultsEDO = resultadosEDO(Y);
