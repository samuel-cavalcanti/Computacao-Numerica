exec('linearSystemMethods.sce')


function relativeError = bigBangErro(sN,sA)
    
for i =1:length(sN)
    relativeError(i)= abs(sN(i) - sA(i))/sA(i)
end
    
endfunction


bigBang = [937,725,4220.072751322751]'
//posX: 937 posY: 725 time: 4220.072751322751
posX = [859 904 830];
posY = [872 786 933];
time = [4456.396825396825 4321.354497354497 4591.439153439153 ];
vel = sqrt(posX^2  + posY^2 );
vel = vel./time;
theta = atan(posX,posY)
A = [0 -cos(theta(1)) vel(1)*sin(theta(1))*cos(theta(1));sin(theta(2)) -cos(theta(2)) 0;sin(theta(3)) 0 -vel(3)*sin(theta(3))*cos(theta(3)) ]

B = [-cos(theta(1))*posY(3)+vel(1)*sin(theta(1))*cos(theta(1))*time(3) sin(theta(2))*posX(3)-cos(theta(2))*posY(3) sin(theta(3))*posX(3)-vel(3)*sin(theta(3))*cos(theta(3))*time(3) ]'

[A,B] = verifyMatrix(A,B)

X1 = Gauss(A,B);

temp = X1(1);
X1(1) = X(2);
X1(2) = temp

relativeError = bigBangErro(X1,bigBang)


[iter, X] = jacobi(A,B,zeros(B),10^-15,10^15)

[iter, X] = gaussSeidel (A,B,zeros(B),10^-15,10^15)
