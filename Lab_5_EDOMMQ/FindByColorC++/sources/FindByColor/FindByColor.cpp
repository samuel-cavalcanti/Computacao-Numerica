/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   FindColor.cpp
 * Author: samuel
 * 
 * Created on November 16, 2018, 10:05 PM
 */

#include "FindByColor.hpp"

FindByColor::FindByColor(std::string &videoPath) : VideoControl(videoPath) {
    calibrationFrame = new cv::Mat();
    outputFrame = new cv::Mat();
    massCenterPoints = new std::list<cv::Point2f>();
    showingVideo = true;
    inicializeTrackbars();

}

FindByColor::FindByColor(std::string& videoPath, std::string& outputPath) : VideoControl(videoPath, outputPath) {
    calibrationFrame = new cv::Mat();
    outputFrame = new cv::Mat();
    massCenterPoints = new std::list<cv::Point2f>();
    showingVideo = true;
    inicializeTrackbars();



}

void FindByColor::inicializeTrackbars() {
    nameOfFileTrackBars = "lastPosTrackBars.csv";
    trackbarLowerNames = new std::vector<std::string>{"H_MIN", "S_MIN", "V_MIN"};
    trackbarUpperNames = new std::vector<std::string>{"H_MAX", "S_MAX", "V_MAX"};
    createTrackbars();
    if (getSavedTrackbarsValues())
        setTrackbar();
    else {
        lower = new std::vector<int>(3, 0);
        upper = new std::vector<int>(3, 255);
    }

}

FindByColor::FindByColor(const FindByColor& orig) {
}

FindByColor::~FindByColor() {
}

void FindByColor::showVideo(bool loop) {

    bool haveFrame = false;
    while (showingVideo) {
        haveFrame = cam->read(currentFrame);
        if (haveFrame) {
            imageProcessing();

            showImages();
            control();

            if (outputVideo != NULL)
                outputVideo->write(*outputFrame);


        } else if (loop)
            cam->set(cv::CAP_PROP_POS_FRAMES, 0);
        else
            return;
    }
}

void FindByColor::imageProcessing() {
    int largestContourId;
    std::vector<cv::Vec4i> hierarchy;
    std::vector< std::vector<cv::Point> > contours;

    getTrackbarsPos();

    calibrationColor();

    if (not getTheLargestContours(largestContourId, hierarchy, contours))
        return;
    cv::Point2f currentPoint = getMassCenter(largestContourId, contours);

    massCenterPoints->push_back(currentPoint);

    drawOutput(largestContourId, hierarchy, contours, currentPoint);

    if (cv::getTrackbarPos(saveTrackbarName, trackbarWindowName)) {
        saveTrackbars();
        cv::setTrackbarPos(saveTrackbarName, trackbarWindowName, 0);
    }


}

void FindByColor::calibrationColor() {
    cv::Mat hsvFrame;
    cv::cvtColor(currentFrame, hsvFrame, cv::COLOR_BGR2HSV);
    cv::inRange(hsvFrame, vectorToScalar(lower), vectorToScalar(upper), *calibrationFrame);

}

cv::Point2f FindByColor::getMassCenter(int& largestContourId, std::vector< std::vector<cv::Point> >& contours) {
    cv::Moments moment = cv::moments(contours[largestContourId]);

    return cv::Point2f(moment.m10 / moment.m00, moment.m01 / moment.m00);



}

bool FindByColor::getTheLargestContours(int& largestContourId, std::vector<cv::Vec4i>& hierarchy, std::vector< std::vector<cv::Point> >& contours) {
    cv::findContours(*calibrationFrame, contours, hierarchy, cv::RETR_TREE, cv::CHAIN_APPROX_NONE);
    //  double maxArea = cv::getTrackbarPos(minArea, trackbarWindowName); testes
    double maxArea = 80;
    bool haveContour = false;

    for (unsigned int i = 0; i < contours.size(); i++) {
        double currentArea = cv::contourArea(contours.at(i));
        if (currentArea > maxArea) {

            maxArea = currentArea;
            largestContourId = i;
            haveContour = true;
        }

    }

    return haveContour;

}

void FindByColor::drawOutput(int& largestContourId, std::vector<cv::Vec4i>& hierarchy, std::vector< std::vector<cv::Point> >& contours, cv::Point2f& massCenter) {
    currentFrame.copyTo(*outputFrame);

    cv::drawContours(*outputFrame, contours, largestContourId, cv::Scalar(0, 0, 255), 2, 8, hierarchy);

    cv::circle(*outputFrame, cv::Point((int) massCenter.x, (int) massCenter.y), 1, cv::Scalar(255, 0, 0), 2, -1);

    showImageResized(outputWindow, *outputFrame);

}

void FindByColor::showImages() {

    showImageResized(windowInput, currentFrame);
    showImageResized(calibrationWindow, *calibrationFrame);
}

void FindByColor::createTrackbars() {
    trackbarWindowName = "Trackbars";
    calibrationWindow = "Calibration";
    saveTrackbarName = "save trackbars";
    minArea = "min area";
    outputWindow = "output";
    cv::namedWindow(trackbarWindowName, cv::WINDOW_NORMAL);
    cv::namedWindow(calibrationWindow, cv::WINDOW_NORMAL);
    cv::namedWindow(outputWindow, cv::WINDOW_NORMAL);

    for (std::string i :{"H_MIN", "S_MIN", "V_MIN", "H_MAX", "S_MAX", "V_MAX"})
        cv::createTrackbar(i, trackbarWindowName, 0, 255, onChange);


    cv::createTrackbar(saveTrackbarName, trackbarWindowName, 0, 1, onChange);
    cv::createTrackbar(minArea, trackbarWindowName, 0, 200, onChange);


}

void FindByColor::onChange(int, void*) {

}

bool FindByColor::getSavedTrackbarsValues() {
    std::ifstream file(nameOfFileTrackBars, std::fstream::in | std::fstream::out);

    if (not file.is_open() or not file.good())
        return false;

    csvToVector(file);

    return true;
}

void FindByColor::csvToVector(std::ifstream& file) {

    std::string line;
    std::string cell;
    lower = new std::vector<int>();
    upper = new std::vector<int>();

    file >> line;
    getTrackbarValue(std::stringstream(line), lower);

    line.clear();

    file >> line;
    getTrackbarValue(std::stringstream(line), upper);



}

void FindByColor::getTrackbarValue(std::stringstream streamLine, std::vector<int>* trackbarValues) {
    std::string value;

    while (std::getline(streamLine, value, ','))
        trackbarValues->push_back(std::stoi(value));


}

void FindByColor::setTrackbar() {

    setTrackbarValues(trackbarLowerNames, lower);
    setTrackbarValues(trackbarUpperNames, upper);

}

void FindByColor::setTrackbarValues(std::vector<std::string>* trackbarNames, std::vector<int>* pos) {

    for (unsigned int i = 0; i < trackbarNames->size(); i++)
        cv::setTrackbarPos(trackbarNames->at(i), trackbarWindowName, pos->at(i));



}

void FindByColor::getTrackbarsPos() {

    getTrackbarPos(trackbarLowerNames, lower);
    getTrackbarPos(trackbarUpperNames, upper);
}

void FindByColor::getTrackbarPos(std::vector<std::string>* trackbarNames, std::vector<int>* pos) {
    pos->clear();

    for (unsigned int i = 0; i < trackbarNames->size(); i++)
        pos->push_back(cv::getTrackbarPos(trackbarNames->at(i), trackbarWindowName));

}

cv::Scalar FindByColor::vectorToScalar(std::vector<int>* pos) {

    return cv::Scalar(pos->at(0), pos->at(1), pos->at(2));
}

void FindByColor::saveTrackbars() {
    std::stringstream line;
    std::fstream file(nameOfFileTrackBars, std::fstream::in | std::fstream::out);

    if (not file.is_open() or not file.good())

        return;

    trackbarToStringstream(line, lower);
    trackbarToStringstream(line, upper);


    file << line.str();

    file.close();


}

void FindByColor::trackbarToStringstream(std::stringstream& line, std::vector<int>* pos) {

    line << pos->at(0) << "," << pos->at(1) << "," << pos->at(2) << std::endl;
}

void FindByColor::saveVideo(std::string videoName) {
    stopRecorder();

    cv::Size videoSize((int) cam->get(CV_CAP_PROP_FRAME_WIDTH), (int) cam->get(CV_CAP_PROP_FRAME_HEIGHT));
    outputVideo = new cv::VideoWriter(videoName, cam->get(cv::CAP_PROP_FOURCC), cam->get(cv::CAP_PROP_FPS), videoSize);



}

void FindByColor::stopRecorder() {

    if (outputVideo != NULL) {
        outputVideo->release();
        delete outputVideo;
    }

}

void FindByColor::exit() {
    cam->release();
    stopRecorder();

    delete outputVideo;
    delete calibrationFrame;
    delete outputFrame;
    delete lower;
    delete upper;

    showingVideo = false;
}

void FindByColor::massCenterPointsToCsv(std::string fileName) {

    std::fstream file(fileName, std::fstream::in | std::fstream::out | std::fstream::app);

    file << pointsToStringstream().str();


    file.close();


}

std::stringstream FindByColor::pointsToStringstream() {
    std::stringstream allPoints;

    for (auto point = massCenterPoints->begin(); point != massCenterPoints->end(); point++) {
        allPoints << (*point).x << "," << (*point).y << std::endl;
    }

    return allPoints;

}


