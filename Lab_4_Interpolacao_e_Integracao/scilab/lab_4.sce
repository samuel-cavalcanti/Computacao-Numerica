clear
exec("interpolacao_integracao.sce")

function s= trapPontos(x,y)
    h = abs(x(2) - x(1))

    s = y(1)
    for i =2:length(y)-1
        s = 2*y(i) +s
    end
    s =  (y($) +s)*h/2        
endfunction

function s= primeiraRegraDeSimpsomPontos(x,y)
    h = abs(x(2) - x(1))

    s = y(1)
    for i=2:length(y)-1 //
        if modulo(i,2) == 0
            s = s + 4*y(i)
        else
            s = s + 2*y(i)
        end

    end
    s =  (s +y($))*h/3  //-0.0020814

endfunction

function s = segundaRegraDeSimpsomPontos(x,y)
    h = abs(x(2) - x(1))

    s = y(1)
    for i=2:length(y) -1
        if modulo(i,3) == 1
            s = s+ 2*y(i)
        else
            s = s+ 3*y(i)
        end

    end
    s = 3*h/8*(s + y($))


endfunction

function  [points, poli]= interpolacaoPorPartes(x,y,n)

    poli =[ ]
    begin = 1



    for i=2:length(x)
        if modulo(i,2) ==0

            // pegando o subintervalos
            intervX = x(begin:i)
            intervY = y(begin:i)
            // pegando pontos do subintervalo 
            point = x(begin):n:x(i) 
            j = 1
            if length(poli) > 0
                j=2
            end


            for j=j:length(point)
                poli($+1)= newton(intervX, intervY, point(j))
            end

            begin = i //2, 4, 6 ,8 ,10 

        end

    end

    points = x(1):n:x($)





endfunction

function [trapezio, simpsom] = volumePontos(x,y)
    r = y.^2
    trapezio = %pi*trapPontos(x,r)
    simpsom = %pi *segundaRegraDeSimpsomPontos(x,r)
    // cm³ para litros
    trapezio = trapezio * 10^-3
    simpsom = simpsom   * 10^-3
    // area real = 0.51 litros
endfunction


function simpsom= volumeFuncao(x,y)
    area = primeiraRegraDeSimpsonLagrange(x(1),x($),2000,x,y)
    volume = %pi*area

    // cm³ para litros
    simpsom =  volume* 10^-3

endfunction

function[x, y, origin]= getData(filename)
    points = csvRead(filename);//intervalo.csv
    // points = csvRead("intervalo.csv");
    x = points(:,1)
    y = points(:,2)

    [x, y , origin ]= matrixMudancaDeCordenadas(x,y)

endfunction

function [u ,v , origin] = matrixMudancaDeCordenadas(x,y)
    origin = [ x(1), y(1) ]


    // mudança de cordenadas deslocando os eixos
    // 15 pixels = 0.1 cm 
    // OBS: foi descolado a origem para o ponto (1106,1878) e covertido para cm
    v =  (1878 -y )/150
    u =  (x - origin(1) )/150 

endfunction

function  [intervalo, rL]  = poliLagrange(x,y)
    n = 200
    b = x($)
    a= x(1)

    h = (b-a)/n

    intervalo=a:h:b

    for i =1 : length(intervalo)
        rL(i) =  lagrange(x,y,intervalo(i))
    end


endfunction


function [x,y]= MatrixDeCordenadasScilab(u,v,origin ,imageSize)


    // mudança de cordenadas  para o maltplot scilab
    delY = imageSize(1) -1878
    y = delY +150*v 

    x = origin(1) +150*u
endfunction

function plotImage(x, y, origin, colorPlot)
    scicv_Init()
    garrafa = imread("../imagem/garrafa.jpg")

    [u,v]= MatrixDeCordenadasScilab(x,y,origin, size (garrafa) )


    matplot(garrafa)
    plot(u',v,colorPlot)


endfunction


function [trapezio,simpsom1,simpsom2]= volumeNewton(x,y,h)
    [u ,v] = interpolacaoPorPartes(x, y, h)
    r = v^2 
    trapezio = trapPontos(u,r)
    simpsom1 = primeiraRegraDeSimpsomPontos(u,r)
    simpsom2 = segundaRegraDeSimpsomPontos(u,r)
    // calculando  mutiplicando por pi
    trapezio =  %pi*trapezio
    simpsom1 =  %pi*simpsom1
    simpsom2 =  %pi*simpsom2

    // convertendo para litros
    trapezio =  trapezio*10^-3
    simpsom1 =  simpsom1*10^-3
    simpsom2 =  simpsom2*10^-3
endfunction

[x,y, origem] = getData("intervalo.csv")
[newX, newY]=MatrixDeCordenadasScilab(x,y,origem,[3120,4160])

//scf(0)


[trapezio,simpsom1,simpsom2]= volumeNewton(x,y,0.05)

disp("trapezio: ",trapezio , "simpsom1" ,simpsom1,"simpsom2",simpsom2 )

//plot(x,y^2,'.r')
//1873
// area real = 0.31 litros
[trapezioPontos simpsomPontos] = volumePontos(x,y)
volumeFunçao= volumeFuncao(x,y)

//scf(1)
//[intervalo, rL] = poliLagrange(x,y);
//plotImage(intervalo,rL, origem,'.g')
//plot(newX,newY,'.r')
//
//
//
//scf(2)
//[u ,v] = interpolacaoPorPartes(x, y, 0.1)
//plotImage(u,v,origem ,'.b')
//[newX, newY]=MatrixDeCordenadasScilab(x,y,origem,[3120,4160])
//plot(newX,newY,'.r')
//

//plot(intervalo',rL,'b',x,y,'.r');
//volumeFunçao= volumeFuncao(x,y)
