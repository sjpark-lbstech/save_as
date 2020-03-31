//
// Created by sjpar on 2020-03-31.
//
#include <opencv2/imgproc.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>

#include "proj_net_lbstech_save_as_OpenCV.h"
#include <jni.h>

using namespace cv;

extern "C"{

    void reverse(Vec4b &cel){
        if(cel[0] == 0){
            cel[0]=255;
            cel[1]=255;
            cel[2]=255;
            cel[3] = 0;
        }else{
            cel[0]=0;
            cel[1]=0;
            cel[2]=0;
            cel[3]=255;
        }
    }

    struct reverseOperator {
        void operator ()(Vec4b &cel, const int * position) const{
            reverse(cel); }
    };

    JNIEXPORT void JNICALL Java_proj_net_lbstech_save_1as_OpenCV_getCanny
        (JNIEnv *env, jobject, jstring jsrcPath, jstring jedgePath){

        const char *srcPath = env->GetStringUTFChars(jsrcPath, JNI_FALSE);
        const char *edgePath = env->GetStringUTFChars(jedgePath, JNI_FALSE);

        Mat src = imread(srcPath, IMREAD_GRAYSCALE);
        Mat edge = Mat();

        Canny(src, edge, 150, 200);
        cvtColor(edge, src, COLOR_GRAY2RGBA);
        src.forEach<Vec4b>(reverseOperator());

        imwrite(edgePath, src);

        src.release();
        edge.release();

        delete(srcPath);
        delete(edgePath);

    }
}