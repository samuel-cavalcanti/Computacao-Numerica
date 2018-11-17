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
    outputFrame = NULL;
    nameOfFileTrackBars = "lastPosTrackBars.csv";
    trackbarLowerNames = new std::vector<std::string>{"H_MIN", "S_MIN", "V_MIN"};
    trackbarUpperNames = new std::vector<std::string>{"H_MAX", "S_MAX", "V_MAX"};
    saveTrackbarName = "save trackbars";
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
    while (true) {
        haveFrame = cam->read(currentFrame);
        if (haveFrame) {
            imageProcessing();
            showImages();
            control();

        } else if (loop)
            cam->set(cv::CAP_PROP_POS_FRAMES, 0);
        else
            return;
    }
}

void FindByColor::imageProcessing() {
    cv::Mat hsvFrame;
    cv::cvtColor(currentFrame, hsvFrame, cv::COLOR_BGR2HSV);
    getTrackbarsPos();
    cv::inRange(hsvFrame, vectorToScalar(lower), vectorToScalar(upper), *calibrationFrame);
    if (cv::getTrackbarPos(saveTrackbarName, trackbarWindowName)) {
        saveTrackbars();
        cv::setTrackbarPos(saveTrackbarName, trackbarWindowName, 0);
    }


}

void FindByColor::showImages() {
    showImageResized(windowInput, currentFrame);
    showImageResized(calibrationWindow, *calibrationFrame);

}

void FindByColor::createTrackbars() {
    trackbarWindowName = "Trackbars";
    calibrationWindow = "Calibration";
    cv::namedWindow(trackbarWindowName, cv::WINDOW_NORMAL);
    cv::namedWindow(calibrationWindow, cv::WINDOW_NORMAL);

    for (std::string i :{"H_MIN", "S_MIN", "V_MIN", "H_MAX", "S_MAX", "V_MAX"})
        cv::createTrackbar(i, trackbarWindowName, 0, 255, onChange);


    cv::createTrackbar(saveTrackbarName, trackbarWindowName, 0, 1, onChange);


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
