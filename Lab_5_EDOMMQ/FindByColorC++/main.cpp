#include <iostream>
#include <opencv/cv.hpp>
#include <FindByColor.hpp>
#include <string>

void control(cv::VideoCapture&);

int main(int argc, char** argv) {
    std::string videoName = "../../videos/Sample.mp4";

    cv::VideoCapture video(videoName);
    FindByColor test(videoName);
    test.saveVideo("output.mp4");
    test.showVideo(true);
   // test.massCenterPointsToCsv("positions.csv");


    return 0;
}