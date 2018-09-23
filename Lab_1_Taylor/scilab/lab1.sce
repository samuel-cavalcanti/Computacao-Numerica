// importando funções
exec('taylorMethods.sce')
function [e]= erroTaylor(n,w0,r,f0,time)

    //
    for i = 1: length(time)
        angt(i) = taylor(time(1),n,time(i),w0,r)
        e(i) = abs( (angt(i) - f0(i))/f0(i) )    
    end

endfunction

function [y] = mmq(w0, r ,t)
    y = r(1) + r(2)*cos(w0*t) + r(3)*sin(w0*t)

endfunction

function[ang, time] = getData(fileName)
    x = 662 
    y = 690
    pos = csvRead(fileName)
    x0 = pos(:,1)
    y0 = pos(:,2)
    time = (pos(:,3)/1000) // milisec to sec

    ang = getAngByAcos([x y],x0,y0)

endfunction


function[ang] = getAngByAcos(center, x, y)

    for i =1:length(x)
        deltaX = center(1) - x(i) 
        deltaY = center(2) - y(i)
        norma = sqrt (deltaX^2 + deltaY^2 )
        ang(i) =  acos (deltaX/norma)
    end

endfunction


[ang time] = getData('positions.csv');

p = (time($-16) -time(1))/5; // 6 voltas em  7,8 segundos 

[w0 r] =   coeficientes(time,ang,p);
f0 = mmq(w0, r, time);

//plot(time,ang,'.b')
//plot(time,f0,'r')
//legend(['Real Data' 'MMQ'],-6)
//143
//time(184-41)

tay(1) = taylor(time(143),1,time($),w0,r)
tay(2) = taylor(time(143),2,time($),w0,r)
tay(3) = taylor(time(143),3,time($),w0,r) 
tay(4) = taylor(time(143),50,time($),w0,r)   
for i =1:4
    erroT(i) = abs(tay(i) -f0($) )/ abs(f0($))
end

//tay = taylor(time(143),1,time,w0,r)

time2 = time($-41:$)
f1 = f0($-41:$)

for i =1:length(time2)
    angt1(i) = taylor(time2(1),1,time2(i),w0,r) 
    angt2(i) = taylor(time2(1),2,time2(i),w0,r) 
    angt3(i) = taylor(time2(1),3,time2(i),w0,r) 
    angt4(i) = taylor(time2(1),50,time2(i),w0,r) 

end



//tay =  taylor(time2(1),1,time2,w0,r)

//scf(0)
//plot(time, angt)


//erro1 = erroTaylor(1,w0,r,f0,time)

//erro2 = erroTaylor(2,w0,r,f0,time)


//erro3 = erroTaylor(3,w0,r,f0,time)

//erro4 = erroTaylor(50,w0,r,f0,time)





