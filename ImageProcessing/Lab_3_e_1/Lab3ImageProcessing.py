#! /bin/env python

from findColor import FindColor
import cv2 as cv
import numpy as np

video = FindColor("bigBang.mp4")
#video.watch((1200, 800), loop=True)

fourcc = cv.VideoWriter_fourcc(*'XVID')
out = cv.VideoWriter('OutputBigBang.mp4',fourcc, 30.0, (1920,1080))

while video.cap.isOpened():
    outputFrame = video.getColor(loop=False, size=(1200, 800), hsv_max=[255, 129, 255], hsv_min=[0, 0, 0])
    outputFrame =  cv.bitwise_not(outputFrame)
    

    kernelErode = np.ones((5, 5), np.uint8)
    kerneldilate = np.ones((5, 5), np.uint8)

    opening = cv.morphologyEx(outputFrame, cv.MORPH_OPEN, kernelErode,iterations=6)
    erode = cv.erode(opening, kernelErode, iterations=0)
    dilate = cv.dilate(erode, kerneldilate, iterations=4)
    erode = cv.erode(dilate, kernelErode, iterations=0)
    dilate = cv.dilate(erode, kerneldilate, iterations=0)

    ret, cts, hierarchy=  cv.findContours(image=dilate,mode = cv.RETR_TREE,method=cv.CHAIN_APPROX_TC89_KCOS)

    for i in range (len(cts)) :
        area = cv.contourArea(cts[i])
        if area > 2000:
         m = cv.moments(cts[i])
         cX = int(m["m10"] / m["m00"])
         cY = int(m["m01"] / m["m00"])

         cv.circle(video.frame, (cX, cY), 1, (0, 0, 255), 2)
         cv.putText(video.frame,'ct['+str(i)+ ']',(cX,cY),fontFace=2,fontScale=3,color=(255,0,50) )
         print('ct:',i,'cX:',cX,'cY:',cY )
         
    print('time:',video.time)
    video.showFrame(size =(1200,800))
    out.write(video.frame)

out.release()

    #cv.imshow('dilate',cv.resize(dilate,(1200,800)))


    
"""
    momento em que as bolas tocam juntas:
          cX: 878 
          cY: 358
          time: 1678.0399061032863
    Quadro1: 
        vermelha: 
            X: 1055 
            Y: 568
        verde:
             X: 970 
             Y: 350
        azul: 
         X: 426 
         Y: 210

    time: 1845.8438967136149

    Quadro2:
    vermelha:  
        X: 1145 
        Y: 651
    verde: 
      X: 1072 
      Y: 340
    azul:  
     X: 120 
     Y: 77

    time: 1980.087089201878



    """

            

            
    

       
                    
    


# h_min = 113
# s_min = 82
# v_min = 96
# h_max = 121
# s_max = 255
# v_max = 255

# quadro zero: posX: 937 posY: 725 time: 4220.072751322751

# segunda  equação: posX: 904 posY: 786 time: 4321.354497354497
# terceira equação: posX: 830 posY: 933 time: 4591.439153439153

# h_min 0
# s_min 0
# h_max 0
# h_max 255
# s_max 129
# v_max 255