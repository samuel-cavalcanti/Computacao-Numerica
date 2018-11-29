function [x,y] = Euler(a,b,h,y0,df)
    x=a:h:b;
    y(1)=y0;

    for i=2:length(x)
        y(i) = y(i-1)+ h*df(x(i-1),y(i-1) );
    end
endfunction

function [x,y,z] = Euler2(a,b,h,y0,z0,df,df2)
    x = a:h:b
    y(1) = y0;
    z(1) = z0;


    for i=2:length(x)
        z(i) = z(i-1)+ h*df2(x(i-1),y(i-1),z(i-1));
        y(i) = y(i-1)+ h*df(x(i-1),y(i-1),z(i-1));
    end

endfunction

function [x,y] =  RK2(a,b,h,y0,df)
    x= a:h:b
    y(1)= y0;
    
    for i=2:length(x)
        k1 = df (x(i-1),y(i-1));
        k2 = df (x(i),y(i-1)+ h*k1);
        y(i) = y(i-1)+h/2*(k1 +k2);
    end
endfunction

function a= poli(x,y,k)
    n = length(x);
    
    for i =1 : n
        for j=1: k+1
            v(i,j) = x(i)^(j-1)
        end
        b(i) = y(i);
    end
    
    a = inv(v'* v)*(v'*b);
endfunction
