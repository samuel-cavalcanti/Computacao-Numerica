import cv2 as cv
import numpy


class VideoControls:
    cap = cv.VideoCapture()
    __trackbarWindowName = 'Trackbars'
    __frameVideo = False
    __size = False
    time = 'none'
    frame = numpy.array([])

    def __init__(self, nameOfVideo):
        self.cap.open(nameOfVideo)
        self.__videoName = nameOfVideo
        self.__outputWindowName = "output of " + nameOfVideo
        self.__frameWidth =  int (self.cap.get(cv.CAP_PROP_FRAME_WIDTH) )
        self.__frameHeight = int (self.cap.get(cv.CAP_PROP_FRAME_HEIGHT))

        pass

    def __videoControls(self):
        key = cv.waitKey(int(self.cap.get(cv.CAP_PROP_FPS))) or 0xff
        if key == ord('p'):
            cv.waitKey(0)
        elif key == ord('q'):
            self.__closeVideo()

    def __closeVideo(self):
        self.cap.release()
        cv.destroyAllWindows()

    def getFrame(self, size, loop):

        ret, frame = self.cap.read()
        self.__videoControls()
        if ret:
            self.frame = frame
            self.time = self.cap.get(cv.CAP_PROP_POS_MSEC)
            if size:
                frame = cv.resize(frame, (size))

           
        elif loop:
            self.cap = cv.VideoCapture(self.__videoName)
        else:
            self.__closeVideo()

    def watch(self, size=False, loop=False):
        cv.namedWindow(self.__videoName, cv.WINDOW_NORMAL)

        while self.cap.isOpened():
            self.getFrame(size, loop)