%Determine Bubble depth
%Written by Francois Noelle
%Incorparated with Matt Malteno's code

%APPLICATION used to calibrate as well as determine the depth of bubbles
%within a image. Once the depth is known, it can be used to adjust the 
%mm/pixel scale specific for each bubble, therefore improving overall
%bubble parameter estimations

%written by Francois Noelle

clear all
clc
close all

thresh=0.8;% This thresholds bubbles from random noise
bubsize_range=[1000,inf]; %Minimum and maximum bubble size 



%% Determine Operation
prompt = 'Input depth of known bubble'; %It is recommended to use bubble depths that lie deeper
depth = input(prompt);
%% Calibrate System and Determine Scale
imagenamecalib='pole.jpg'; % Image of the calibrtion pole as described in paper
knowndepth = 'H9.03.jpg'; %Image of bubbles at a known depth, all bubbles 
%within this image are assumed to be at the same depth.

A = imread(imagenamecalib);
B = imread(knowndepth);


[pole_calibration, scale,rodgrads, rodstd, maxBgrad]= calibrate(A, B,thresh, depth,bubsize_range); %Calibration Procedure
%% Analyse Bubbles
A = imread('H12.08.jpg'); %Image of the bubbles where depth is to be determined

[bubgrad,NrBubs,Depth]=derivativeautoDepth(A,thresh,bubsize_range,pole_calibration,maxBgrad);

