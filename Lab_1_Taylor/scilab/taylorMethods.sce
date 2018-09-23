function [y] =  taylor(t0,n,t, w0, r)

    h = t - t0
    y = 0
    for i =0:n-2
        rest =  modulo(i,4)
        if rest == 0
            dev  = r(2)*(-sin(w0*t0))*w0^(i+1) + r(3)*cos(w0*t0)*w0^(i+1)
        elseif rest == 1
            dev  = r(2)*(-cos(w0*t0))*w0^(i+1) + r(3)*(-sin(w0*t0))*w0^(i+1)
        elseif rest == 2
            dev  = r(2)*sin(w0*t0)*w0^(i+1) + r(3)*(-cos(w0*t0))*w0^(i+1)
        elseif rest == 3
            dev = r(2)*cos(w0*t0)*w0^(i+1) +r(3)*sin(w0*t0)*w0^(i+1)
        end

        y =  dev*h^(i+1)/factorial(i+1) + y

    end
    //primeiro termo da serie de taylor
    y =  r(1) + r(2)*cos(w0*t0) +r(3)*sin(w0*t0) + y 
endfunction


function [w0,r ] = coeficientes(t ,ang , p  )//vetores de tempo e angulo, e o período
    n = length(t) //numero de elementos em t
    w0 = 2*%pi/p // frequencia em radianos
    A = [n sum(cos(w0*t)) sum(sin(w0*t)); sum(cos(w0*t)) sum(cos(w0*t).*cos(w0*t))  sum(cos(w0*t).*sin(w0*t)); sum(sin(w0*t)) sum(cos(w0*t).*sin(w0*t)) sum(sin(w0*t).*sin(w0*t))];
    B = [sum(ang); sum(ang.*cos(w0*t));sum(ang.*sin(w0*t));];
    r = inv(A)*B;

endfunction

