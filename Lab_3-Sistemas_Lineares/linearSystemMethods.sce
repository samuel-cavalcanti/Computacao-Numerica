function [x,iter] = jacobi(A,b,X0,t,N)
    [L,c] = size(A);
    iter  =0
    infNorm = 1
    while  iter < N && infNorm > t
        for i = 1: L
            soma = 0

            for j = 1:L
                if j~=i
                    soma = soma + A(i,j)*X0(j)
                end

            end
            x(i) =(b(i) - soma)/A(i,i);
        end

        iter = iter+1;
        infNorm = max(abs(x -X0))
        X0 =x
    end


endfunction

function [iter,x] = gaussSeidel(A,B,x0,t,N)
    [rows, columns] = size(A);
    iter = 0;
    infNorm = 1;
    while iter <N && infNorm >t
        iter = iter +1
        for i =1:rows
            soma = 0;
            
            for j =1: i -1
                soma = soma + A(i,j) * x(j)
               
            end
            
            for j2 = i+1:rows     
                soma = soma + A(i,j2) * x0(j2)
            end
            
            x(i) = (B(i) - soma)/A(i,i)
        end

        infNorm = max(abs(x - x0));
        x0 = x;
        

    end


endfunction


function x = retroInf(A, b)
    [L,c] = size(A)


    for i=L:-1:1

        soma = 0;
        for j=i+1:c
            soma = soma + x(j)*A(i,j)

        end
        x(i) = (b(i)-soma)/A(i,i);
    end
endfunction

function x1 = retroSup(A,b)

    [L,c] = size(A)


    for i=1:L
        soma = 0;
        for j=1:i-1
            soma = soma + x1(j)*A(i,j)
        end
        x1(i) = (b(i)-soma)/A(i,i);
    end

endfunction



function [A1,B1] = verifyMatrix(Aa, B)
    [l,c] = size(Aa);
    i = 2;
    while Aa(1,1) == 0 && i <= l
        tempA = Aa(1,:);
        tempB = B(1);

        Aa(1,:) = Aa(i,:)
        B(1) =B(i);

        Aa(i,:) = tempA;
        B(i) = tempB;
        i = i + 1
    end

    if  Aa(1,1) == 0
        Aa(:,1) =[ ]    

    end

    A1 = Aa
    B1 = B

endfunction


function [L,U] = decompLU(A)
    [line,cols] = size(A)

    L = eye(A);

    for i =1:line-1
        pivo= A(i,i);

        for j = i+1:cols
            m =  A(j,i)/pivo 
            L(j,i) = m
            A(j,:) = A(j,:) -m*A(i,:)
        end


    end

    U = A

endfunction


function solver = luSolver (A,B)
    [L,U]= decompLU(A)
    // permutação linha 1 com 2 

    y = retroSup(L,B);
    solver = retroInf(U,y)

endfunction


function x = Gauss(A,b)
    [L,c] = size(A);
    Aa = [A,b];
    for i=1:L-1
        pivo=Aa(i,i)
        for j = i+1:c
            m = Aa(j,i)/pivo;
            Aa(j,:) = Aa(j,:) - m*Aa(i,:);
        end
    end
    x = retroInf(Aa(1:L,1:c), Aa(:,c+1));   
endfunction

