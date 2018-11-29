/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   VideoControl.cpp
 * Author: samuel
 * 
 * Created on November 16, 2018, 3:41 AM
 */

#include "VideoControl.hpp"

VideoControl::VideoControl(std::string &videoPath) {
    outputVideo = NULL;
    cam = new cv::VideoCapture(videoPath);
    if (not cam->isOpened())
        std::cout << "video" << videoPath << " not found" << std::endl;

    this->videoName = videoName;
    velVideo = cam->get(cv::CAP_PROP_FPS);
    windowInput = "inputVideo";
    cv::namedWindow(windowInput, cv::WINDOW_NORMAL);


}

VideoControl::VideoControl(std::string& videoPath, std::string& outputPath) {
    cam = new cv::VideoCapture(videoPath);
    if (not cam->isOpened())
        std::cout << "video" << videoPath << " not found" << std::endl;

    this->videoName = videoName;
    velVideo = cam->get(cv::CAP_PROP_FPS);
    windowInput = "inputVideo";
    cv::namedWindow(windowInput, cv::WINDOW_NORMAL);
    cv::Size videoSize((int) cam->get(CV_CAP_PROP_FRAME_WIDTH), (int) cam->get(CV_CAP_PROP_FRAME_HEIGHT));
    outputVideo = new cv::VideoWriter(videoName, cam->get(cv::CAP_PROP_FOURCC), cam->get(cv::CAP_PROP_FPS), videoSize);
}

VideoControl::VideoControl() {
    windowInput = "inputVideo";
    cv::namedWindow(windowInput, cv::WINDOW_NORMAL);
    cam = NULL;
    outputVideo = NULL;
    savingVideo = NULL;
}

VideoControl::VideoControl(const VideoControl& orig) {
}

VideoControl::~VideoControl() {
}

bool VideoControl::getFrame(cv::Mat &frame) {
    return cam->read(frame);
}

void VideoControl::control() {
    int key = cv::waitKey(velVideo);

    switch (key) {
            //press ESC
        case 27:
            cam->release();
            exit();
            break;
            // press a    
        case 97:
            velVideo += 5;
            break;
            // press s
        case 115:
            if (velVideo > 5)
                velVideo -= 5;
            break;
            // press p
        case 112:
            cv::waitKey(0);
            break;

    }

}

void VideoControl::setVideoVelocity(int vel) {
    velVideo = vel;
}

void VideoControl::showImageResized(std::string window, cv::Mat& image) {
    cv::Mat frame;
    if (image.size[0] > 720 and image.size[1] > 1280)
        cv::resize(image, frame, cv::Size(1280, 720));
    else
        frame = image;

    cv::imshow(window, frame);
}

