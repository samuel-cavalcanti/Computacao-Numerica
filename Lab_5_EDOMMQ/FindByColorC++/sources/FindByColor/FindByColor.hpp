/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   FindColor.hpp
 * Author: samuel
 *
 * Created on November 16, 2018, 10:05 PM
 */

#ifndef FINDCOLOR_HPP
#define FINDCOLOR_HPP
#include <VideoControl.hpp>
#include <fstream>
#include <sstream>
#include <vector>

class FindByColor : public VideoControl {
public:
    FindByColor(std::string& videoPath);
    FindByColor(std::string &videoPath, std::string &outputPath);
    FindByColor(const FindByColor& orig);
    void showVideo(bool loop);
    void saveVideo(std::string videoName);
    virtual ~FindByColor();

private:
    void imageProcessing();
    void inicializeTrackbars();
    void createTrackbars();
    void setTrackbar();
    void setTrackbarValues(std::vector<std::string>* trackbarNames, std::vector<int>* pos);
    bool getSavedTrackbarsValues();
    void getTrackbarsPos();
    void getTrackbarPos(std::vector<std::string>* trackbarNames, std::vector<int>* pos);
    void csvToVector(std::ifstream& file);
    void showImages();
    void saveTrackbars();
    void getTrackbarValue(std::stringstream streamLine, std::vector<int>* pos);
    void trackbarToStringstream(std::stringstream &line, std::vector<int>*pos);
    void getMassCenter();
    void calibrationColor();
    void drawOutput(int& largestContourId, std::vector<cv::Vec4i>& hierarchy, std::vector< std::vector<cv::Point> >& contours, cv::Point2f& massCenter);
    bool getTheLargestContours(int& largestContourId, std::vector<cv::Vec4i>& hierarchy, std::vector< std::vector<cv::Point> >& contours);
    void startVideoRecorder();
    void videoRecorder();
    void exit();

    cv::Scalar vectorToScalar(std::vector<int>* pos);
    static void onChange(int, void*);
    std::string trackbarWindowName;
    std::string calibrationWindow;
    std::string outputWindow;
    std::string nameOfFileTrackBars;
    std::string saveTrackbarName;
    std::string minArea;
    cv::Mat* calibrationFrame;
    cv::Mat* outputFrame;
    std::vector<int>* lower;
    std::vector<int>* upper;
    std::vector<std::string>*trackbarLowerNames;
    std::vector<std::string>*trackbarUpperNames;
    bool recordFrame;






};

#endif /* FINDCOLOR_HPP */

