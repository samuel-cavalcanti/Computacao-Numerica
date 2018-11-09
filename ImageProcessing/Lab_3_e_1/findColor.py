import videoControls


class FindColor (videoControls.VideoControls):

    trackbarWindowName = 'Trackbars'

    def __init__(self, videoName):
        super().__init__(videoName)
        self.__outputWindowName = "output of " + videoName

    def __namingAndCreatingTrackbars(self):
        videoControls.cv.namedWindow(
            self.__outputWindowName, videoControls.cv.WINDOW_NORMAL)
        videoControls.cv.namedWindow(
            self.videoName, videoControls.cv.WINDOW_NORMAL)
        self.__createTrackbars()

    def __change(self, value):
        pass

    def __createTrackbars(self):
        videoControls.cv.namedWindow(
            self.trackbarWindowName, videoControls.cv.WINDOW_NORMAL)
        for i in 'H_MIN', 'S_MIN', 'V_MIN', 'H_MAX', 'S_MAX', 'V_MAX':
            videoControls.cv.createTrackbar(i, self.trackbarWindowName,
                                            0, 255, self.__change)

    def __showOutput(self,size):
        if size:
            self.outputFrame = videoControls.cv.resize(self.outputFrame, size)

        
        videoControls.cv.imshow(self.__outputWindowName, self.outputFrame)

    def getColor(self, hsv_min=[], hsv_max=[], loop=False, size=False):
        self.getFrame(size=size, loop=loop)

        if self.frame.size:
            hsvFrame = videoControls.cv.cvtColor(self.frame, videoControls.cv.COLOR_BGR2HSV)

            if videoControls.numpy.array(hsv_min).size:
                self.outputFrame = videoControls.cv.inRange(hsvFrame, videoControls.numpy.array(hsv_min), videoControls.numpy.array(hsv_max))
                return self.outputFrame

            lower = []
            upper = []

            for i in 'H_MIN', 'S_MIN', 'V_MIN':
                lower.append(videoControls.cv.getTrackbarPos(
                    i, self.trackbarWindowName))

            for i in 'H_MAX', 'S_MAX', 'V_MAX':
                upper.append(videoControls.cv.getTrackbarPos(
                    i, self.trackbarWindowName))

            self.outputFrame = videoControls.cv.inRange(hsvFrame, videoControls.numpy.array(lower), videoControls.numpy.array(upper))
        else:
            self.outputFrame = self.frame
            

    def watch(self, size=False, loop=False):

        self.__namingAndCreatingTrackbars()

        while self.cap.isOpened():
         self.getColor(size=size,loop=loop)
         self.showFrame(size=size)
         self.__showOutput(size=size)
           
