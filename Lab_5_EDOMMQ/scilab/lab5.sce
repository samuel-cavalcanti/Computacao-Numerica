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

function GraficoSolucaoMMQ(t1,t2,y1,y2,description)

    a = poli(t1,y1,1);
    plotResultMMQ(t1,a,"o-",description +" h:0.1 MMQ linear",straight);


    a = poli(t1,y1,2);
    plotResultMMQ(t1,a,"o-r",description +" h:0.1 MMQ parábola",parable);


    a =poli(t2,y2,1);
    plotResultMMQ(t2,a,"o-g",description +" h:0.001 MMQ linear",straight);


    a = poli(t2,y2,2);
    plotResultMMQ(t2,a,"o-y",description +" h:0.001 MMQ parábola",parable);

endfunction


function [t1,t2,y1,y2] = graficoSolucaoEDO(t,y,EDOFunction,description)
    
    function g= df1(x,y,z)
        g = z
    endfunction

    function g2 = df2(x,y,z)
        g2 = -1980.277623058
    endfunction

    a  = t(10);
    b  = t($);
    y0 = y(10);
    z0 = 0;
    h  = 0.1;

    [t1,y1,eulerV]= EDOFunction(a,b,h,y0,z0,df1,df2)
    plotEDOResult(t1,y1,"o-", description+ ", h: 0.1");

    h =0.001;
    
    [t2,y2,eulerV]= EDOFunction(a,b,h,y0,z0,df1,df2);
    plotEDOResult(t2,y2,"r", description+ ", h: 0.001");

    
endfunction

function y =parable(a,x)
    y = a(3)*x^2 + a(2)*x + a(1);
endfunction

function y = straight(a,x)
    y = a(2)*x + a(1);
endfunction

function[t,y] =getData(fileName)
    positions = csvRead(fileName)
    y =  positions(1,2) -positions(:,2)   
    t = (positions(:,3) - positions(1,3))/1000
endfunction

/*
- Recupeando dados do vídeo
*/
[t,y] = getData("positions.csv")


/*
- Gráfico da solução (momento em que a bola toca no chão) pelo método de EULER
com passo h=0.1s e h=0.001s, partindo da primeira imagem. (dois gráficos)
*/
[t1,t2,y1,y2] = graficoSolucaoEDO(t,y,Euler2,"Euler")

/*
2 – Encontre a solução por MMQ linear e de segundo grau utilizando a malha de
pontos gerada no item anterior. (quatro gráficos)
*/
GraficoSolucaoMMQ(t1,t2,y1,y2,"Euler");


/*
3- Gráfico da solução (momento em que a bola toca no chão) pelo método de RK2 com
passo h=0.1s e h=0.001s, partindo da primeira imagem. (dois gráficos)
*/
[t1,t2,y1,y2] = graficoSolucaoEDO(t,y,RK2Order2,"RK2")

/*
4 – Encontre a solução por MMQ linear e de segundo grau utilizando a malha de
pontos gerada no item anterior. (quatro gráficos)
*/
GraficoSolucaoMMQ(t1,t2,y1,y2,"RK2");

/*
5- Gráfico da solução (momento em que a bola toca no chão) pelo método de RK4 com
passo h=0.1s e h=0.001s, partindo da primeira imagem. (dois gráficos)
*/
[t1,t2,y1,y2] = graficoSolucaoEDO(t,y,RK4Order2,"RK4")

/*
6 – Encontre a solução por MMQ linear e de segundo grau utilizando a malha de
pontos gerada no item anterior. (quatro gráficos)
*/
GraficoSolucaoMMQ(t1,t2,y1,y2,"RK4");






