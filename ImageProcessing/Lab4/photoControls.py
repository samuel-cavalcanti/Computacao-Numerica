import cv2
import numpy as np
import os


def __show_image__(image=None, window_name=None):
    image = cv2.resize(image, dsize=(int(1800), int(1080)))
    cv2.imshow(window_name, image)


class photoControls:
    hsv_name = "hsv image"
    hsv_file = "hsvRange"
    trackbarsControl = "trackbars"

    def __init__(self, file_name):
        self.input_image = cv2.imread(file_name)
        if self.input_image is None:
            print("Can not read/find the image.")
            exit(-1)
        self.output_image = np.copy(self.input_image)
        self.file_name = file_name
        self.photo_name = str.split(self.file_name, ".")[0]
        self.output_name = self.photo_name + " output"
        cv2.namedWindow(self.photo_name, flags=cv2.WINDOW_NORMAL)
        cv2.namedWindow(self.output_name, cv2.WINDOW_NORMAL)
        cv2.namedWindow(self.hsv_name, cv2.WINDOW_NORMAL)
        cv2.namedWindow(self.trackbarsControl,cv2.WINDOW_NORMAL)

        self.__createTrackbars()
        self.__loadHsvRange()

    def show(self):
        __show_image__(self.input_image, self.photo_name)
        __show_image__(self.output_image, self.output_name)
        __show_image__(self.hsv_image, self.hsv_name)
        cv2.waitKey(0)

    def __change__(self, value):
        self.hsv_image = cv2.cvtColor(src=self.input_image, code=cv2.COLOR_BGR2HSV)

        self.__getTrackbarInfo()

        self.hsv_image = cv2.inRange(self.hsv_image, self.lower, self.upper)

        # canny_output = cv2.Canny(grayPhoto, threshold1=value, threshold2=value * 2, edges=3)

        self.__morphologicalTransformations()
        self.output_image = np.copy(self.input_image)
        self.__drawCts()
        __show_image__(self.input_image, self.photo_name)
        __show_image__(self.output_image, self.output_name)
        __show_image__(self.hsv_image, self.hsv_name)

        if cv2.getTrackbarPos("update (regarrega imagem e salva os pontos)",self.trackbarsControl):
         np.savez(file=self.hsv_file, lower=self.lower, upper=self.upper)
         self.input_image = cv2.imread("garrafa.jpg")

    def __createTrackbars(self):
        cv2.createTrackbar("update (regarrega imagem e salva os pontos)", self.trackbarsControl, 0, 1, self.__change__)

        for i in 'H_MIN', 'S_MIN', 'V_MIN', 'H_MAX', 'S_MAX', 'V_MAX':
            cv2.createTrackbar(i, self.trackbarsControl, 0, 255, self.__change__)

    def __getTrackbarInfo(self):
        self.lower = []
        self.upper = []

        for i in 'H_MIN', 'S_MIN', 'V_MIN':
            self.lower.append(cv2.getTrackbarPos(i, self.trackbarsControl))

        for i in 'H_MAX', 'S_MAX', 'V_MAX':
            self.upper.append(cv2.getTrackbarPos(i, self.trackbarsControl))

        self.lower = np.array(self.lower)
        self.upper = np.array(self.upper)

    def __loadHsvRange(self):

        try:

            file = np.load(self.hsv_file + ".npz")

            self.lower = file["lower"]
            self.upper = file["upper"]

            self.__loadHsvImage()

            self.__setTrackbarPos()



        except:

            self.hsv_image = np.copy(self.input_image)
            pass

    def __loadHsvImage(self):
        self.hsv_image = cv2.cvtColor(src=self.input_image, code=cv2.COLOR_BGR2HSV)
        self.hsv_image = cv2.inRange(self.hsv_image, self.lower, self.upper)

    def __setTrackbarPos(self):

        lower = self.lower
        upper = self.upper

        for trackbar, value in zip(['H_MAX', 'S_MAX', 'V_MAX'], upper):
            cv2.setTrackbarPos(trackbarname=trackbar, winname=self.trackbarsControl, pos=value)

        for trackbar, value in zip(['H_MIN', 'S_MIN', 'V_MIN'], lower):
            cv2.setTrackbarPos(trackbarname=trackbar, winname=self.trackbarsControl, pos=value)

    def __drawCts(self):

        ret, cts, hierarchy = cv2.findContours(image=self.morphImage, mode=cv2.RETR_TREE,
                                               method=cv2.CHAIN_APPROX_TC89_KCOS)
        for c in cts:
            area = cv2.contourArea(c)

            if area > 989328:
                moment = cv2.moments(c)
                cX = int(moment["m10"] / moment["m00"])
                cY = int(moment["m01"] / moment["m00"])

                print("posX:",cX, "posY:",cY )
                cv2.putText(self.output_image, "x:"+ str(cX) + " y: " +str(cY), (cX, cY), fontFace=2, fontScale=4, color=(255, 0, 50),thickness=4)
                cv2.drawContours(self.output_image, contours=[c], contourIdx=0, color=(0, 255, 0), thickness=5)
                cv2.circle(self.output_image,(cX,cY),1,(0,255,0), thickness=4)
                self.points = np.copy(c)
                #self.__drawRects()
                # with open('cts.txt','w') as file:
                #     file.write(str(c))

    def __morphologicalTransformations(self):
        kernel = np.ones((5, 5), np.uint8)
        erosion = cv2.erode(self.hsv_image, kernel, iterations=1)
        dilate = cv2.dilate(erosion, kernel, iterations=3)
        opening = cv2.morphologyEx(dilate, cv2.MORPH_OPEN, kernel, iterations=8)
        closing = cv2.morphologyEx(opening, cv2.MORPH_CLOSE, kernel, iterations=2)

        self.morphImage = closing

    def __drawRects(self):

        points = [[1056, 1727], [1289, 1440], [1522, 1440], [1755, 1443], [1988, 1488], [2221, 1512], [2454, 1512],
                  [2687, 1493], [2920, 1472], [3153, 1527], [3386, 1728]]

        points = np.array(points)

        size = int(self.points.size)

        smallX = np.array([99999999999999, 0])
        bigger = np.array([-1, 0])

        if self.points.size < 11 or self.points.size > 966:
            size = 0
        else:
            print(size)
            for i in range(96, int(size / 8)):
                # cv2.line(self.output_image, (self.points[i][0][0], self.points[i][0][1]),
                #          (self.points[i + 1][0][0], self.points[i + 1][0][1]), (255, 0, 50), 5)
                if smallX[0] > self.points[i][0][0]:
                    smallX = np.copy(self.points[i][0])

                if smallX[0] > self.points[i + 1][0][0]:
                    smallX = np.copy(self.points[i + 1][0])

                if bigger[0] < self.points[i][0][0]:
                    bigger = np.copy(self.points[i][0])

                if bigger[0] < self.points[i + 1][0][0]:
                    bigger = np.copy(self.points[i + 1][0])

                cv2.circle(self.output_image, (self.points[i][0][0], self.points[i][0][1]), 5, (0, 0, 255), -1)
                cv2.circle(self.output_image, (self.points[i + 1][0][0], self.points[i + 1][0][1]), 5, (0, 0, 255), -1)
                # points.append([self.points[i][0][0], self.points[i][0][1]])
                # points.append([self.points[i + 1][0][0], self.points[i + 1][0][1]])

            print(smallX)
            print(bigger)
            delta = bigger - smallX
            print(delta)
            cv2.circle(self.input_image, (1039,1936), 5, (255, 0, 0), -1)
            cv2.circle(self.input_image, (1054,1936), 5, (255, 0, 0), -1)
            # for p in points:
            #      cv2.circle(self.input_image, (p[0], p[1]), 10, (0, 255, 0), -1)
            #cv2.line(self.input_image, (1056, 1950), (3386, 1950), (255, 0, 50), 5)
            cv2.circle(self.input_image, (points[0][0], points[0][1]), 10, (0, 255, 0), -1)
            cv2.circle(self.input_image, (points[-1][0], points[-1][1]), 10, (0, 255, 0), -1)
            cv2.imwrite("distanciaAB.png", self.input_image)

    #  np.savetxt("resultImageProcessing.csv", np.array(points), delimiter=",")
