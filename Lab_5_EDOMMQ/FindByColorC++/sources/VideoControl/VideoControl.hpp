/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   VideoControl.hpp
 * Author: samuel
 *
 * Created on November 16, 2018, 3:41 AM
 */

#ifndef VIDEOCONTROL_HPP
#define VIDEOCONTROL_HPP
#include <opencv2/opencv.hpp>
#include <string>

class VideoControl {
public:
    VideoControl();
    VideoControl(std::string &videoPath);
    VideoControl(const VideoControl& orig);
    bool getFrame(cv::Mat& frame);
    virtual void showVideo(bool loop) = 0;
    virtual ~VideoControl();
protected:
    void setVideoVelocity(int vel);
    cv::Mat currentFrame;
    cv::VideoCapture *cam;
    std::string videoName;
    std::string windowInput;
    void showImageResized(std::string window,cv::Mat& image);
    void control();

private:
    
    int velVideo;

};

#endif /* VIDEOCONTROL_HPP */

