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

function [x,y,z] =  RK2Order2(a,b,h,y0,z0,df1,df2)
    x= a:h:b;

    y(1)= y0;
    z(1)= z0;
    
    
    
    for i=2:length(x)
        k1y = df1 (x(i-1), y(i-1), z(i-1));
        k1z = df2 (x(i-1), y(i-1), z(i-1));
       
        
        k2y = df1 (x(i-1) + h, y(i-1)+ h*k1y, z(i-1) + h*k1z);
        
        k2z = df2 (x(i-1) + h, y(i-1)+ h*k1z, z(i-1) + h*k1z);
        
        z(i) = z(i-1) + h/2*(k1z + k2z);  
        y(i) = y(i-1) + h/2*(k1y + k2y);  
    end
    
endfunction


function [x,y,z] =  RK4Order2(a,b,h,y0,z0,df1,df2)
    x= a:h:b
    y(1)= y0;
    z(1)= z0;
    
    
    for i=2:length(x)
        k1y = df1 (x(i-1), y(i-1), z(i-1));
        k1z = df2 (x(i-1), y(i-1), z(i-1));
        
        k2y = df1 (x(i-1) + h/2, y(i-1)+ h/2*k1y, z(i-1) + h/2*k1z);
        k2z = df2 (x(i-1) + h/2, y(i-1)+ h/2*k1y, z(i-1) + h/2*k1z);
        
        k3z = df2 (x(i-1) + h/2, y(i-1)+ h/2*k2y, z(i-1)  + h/2*k2z);
        k3y = df1 (x(i-1) + h/2, y(i-1)+ h/2*k2y, z(i-1)  + h/2*k2z);
        
        k4y = df1 (x(i), y(i-1) + h*k3y, z(i-1)+ h*k3z);
        k4z = df2 (x(i), y(i-1) + h*k3y, z(i-1)+ h*k3z);
        
        
        z(i) = z(i-1) + h/6*(k1z + 2*k2z + 2*k3z + k4z);
        y(i) = y(i-1) + h/6*(k1y + 2*k2y + 2*k3y + k4y);    
    end
endfunction



function a= poli(x,y,k)
    n = length(x);
    
    for i =1 : n
        for j=1: k+1
            v(i,j) = x(i)^(j-1);
        end
        b(i) = y(i);
    end
    
    a = inv(v'* v)*(v'*b);
endfunction
