exec('linearSystemMethods.sce')


function relativeError = bigBangErro(sN,sA)
    
for i =1:length(sN)
    relativeError(i)= abs(sN(i) - sA(i))/sA(i)
end
    
endfunction


function distance= euclideanDistance(pos0,pos1 )
    distance = (pos0(1)- pos1(1))^2 + (pos0(2) -pos1(2))^2
    distance = sqrt(distance)
endfunction


bigBang = [878, 358, 1678.0399061032863]'
//posX: 937 posY: 725 time: 4220.072751322751

time = [1845.8438967136149, 1980.087089201878 ]

redBallPos1 = [1055, 568]
greenBallPos1 = [970 ,350] 
blueBallPos1 = [426, 210 ]
redBallPos2 = [1145, 651]
greenBallPos2 = [1072, 340]
blueBallPos2 = [120, 77]


// vel(1) == redBallVelocity, vel(2) == greenBallVelocity. vel(3) == blueBallVelocity
deltaT = time(2) - time(1);
velRed = euclideanDistance(redBallPos1,redBallPos2)/deltaT;
velGreen = euclideanDistance(greenBallPos1,greenBallPos2)/deltaT;
velBlue = euclideanDistance(blueBallPos1,blueBallPos2)/deltaT;

vel = [velRed,velGreen,velBlue]

thetaRed = atan(redBallPos2(2)-redBallPos1(2), redBallPos2(1)-redBallPos1(1));
thetaGreen = atan(greenBallPos2(2)-greenBallPos1(2), greenBallPos2(1)-greenBallPos1(1) );
thetaBlue = atan(blueBallPos2(2)-blueBallPos1(2), blueBallPos2(1)-blueBallPos1(1) );


//// thetas(1) == redBallAngle, thetas(2) == greenBallAngle. thetas(3) == blueBallAngle
theta = [thetaRed,thetaGreen,thetaBlue ]


A = [0, -cos(theta(1)), vel(1)*sin(theta(1))*cos(theta(1)); sin(theta(2)), -cos(theta(2)), 0; sin(theta(3)), 0, -vel(3)*sin(theta(3))*cos(theta(3))]
B = [-cos(theta(1))*redBallPos2(2)+vel(1)*sin(theta(1))*cos(theta(1))*time(2); sin(theta(2))*greenBallPos2(1)-cos(theta(2))*greenBallPos2(2); sin(theta(3))*blueBallPos2(1)-vel(3)*sin(theta(3))*cos(theta(3))*time(2)]



[A1,B1] = verifyMatrix(A,B)

X1 = Gauss(A1,B1);



relativeError = bigBangErro(X1,bigBang)


//[iter, X1] = jacobi(A,B,zeros(B),10^-15,10^15)

//[iter, X1] = gaussSeidel (A,B,zeros(B),10^-15,10^5)
