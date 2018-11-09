function S = trapC(a,b,n,f)
    h= (b-a)/n
    x(1)=a
    y(1)=f(x(1))
    S = y(1)
    for i=2:n
        x(i)= x(i-1)+h
        y(i)=f(x(i))
        S = S+2*y(i)
    end
    x(n+1) = b
    y(n+1) = f(x(n+1))
    S = h/2*(S+y(n+1))    
endfunction

function s = primeiraRegraDeSimpson(a,b,n,f)
    h = (b-a)/n
    x=a:h:b
    
    for i=1:length(x)
         y(i) = f(x(i))
    end
   
    s = y(1)
    for i=2:length(y)-1 //
        if modulo(i,2) == 0
            s = s + 4*y(i)
        else
            s = s + 2*y(i)
        end

    end
    s =  (s +y($))*h/3  

    
endfunction

function s = segundaRegraDeSimpsom(a,b,n,f)
    h = (b -a)/n
    x = a:h:b
    for i =1: length(x)
        y(i) = f(x(i))
    end
   
   
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


function Tab= diffdiv(x,y)
    n = length(x)
    Tab(:,1)=y

    for i=1:n-1
        for j =1:n-i
            Tab(j,i+1)= (Tab(j+1,i)-Tab(j,i))/(x(j+i)-x(j))
        end

    end

endfunction

function S = newton(x,y,p)
    n = length(x)
    tabDiffdiv = diffdiv(x,y)
    S = y(1)

    for i=2:n
        M =1
        for j=1:i-1
            M=M*(p -x(j))
        end
        S = S + M *tabDiffdiv(1,i)
    end  
endfunction


function S =  lagrange(x,y,p)
    n = length(x)

    S = 0;
    for i=1:n
        L =1;
        for j =1:n

            if i~=j
                L = L * (p -x(j))/(x(i)-x(j))
            end

        end     

        S = S + L*y(i)   
    end

endfunction


function S =  primeiraRegraDeSimpsonLagrange(a,b,n,u,v)
    h = (b-a)/n

    x=a:h:b
    for i=1:length(x)
        y(i) = lagrange(u,v,x(i)) 
    end
    y = y^2
   

    S = y(1)

    for i=2:n    
    
        if modulo(i,2) == 0
            S = S + 4*y(i)
        else
            S = S + 2*y(i)
        end
    end
    
    S =  (S +y($))*h/3 


endfunction

