import cv2 as cv
import numpy


class VideoControls:
    cap = cv.VideoCapture()
    __trackbarWindowName = 'Trackbars'
    __frameVideo = False
    __size = False
    __vel = 1
    time = 'none'
    frame = numpy.array([])

    def __init__(self, nameOfVideo):
        self.cap.open(nameOfVideo) 
        self.videoName = nameOfVideo
        self.__frameWidth =  int (self.cap.get(cv.CAP_PROP_FRAME_WIDTH) )
        self.__frameHeight = int (self.cap.get(cv.CAP_PROP_FRAME_HEIGHT))


    def __videoControls(self):
        key = cv.waitKey(self.__vel) or 0xff

        if key == ord('p'):
            cv.waitKey(0)
        elif key == ord('q'):
            self.__closeVideo()
        elif key == ord('a'):
            self.__vel += 10
        elif key == ord('s'):
            if self.__vel > 1:
                self.__vel -= 10
            

    def __closeVideo(self):
        self.cap.release()
        cv.destroyAllWindows()

    def showFrame(self,size):
        if size:
            self.frame = cv.resize(self.frame, size)

        
        cv.putText(self.frame,'delay:'+ str(self.__vel),org=(0,size[1] -10),fontFace=0,fontScale=2,color=(0,0,255) )
        cv.imshow(self.videoName, self.frame)
    

    def getFrame(self, size, loop):

        ret, frame = self.cap.read()
        self.__videoControls()
        if ret:
            self.frame = frame
            self.time = self.cap.get(cv.CAP_PROP_POS_MSEC)
            if size:
                frame = cv.resize(frame, (size))

           
        elif loop:
            self.cap = cv.VideoCapture(self.videoName)
        else:
            self.__closeVideo()

    def watch(self, size=False, loop=False):
        cv.namedWindow(self.videoName, cv.WINDOW_NORMAL)

        while self.cap.isOpened():
            self.getFrame(size, loop)