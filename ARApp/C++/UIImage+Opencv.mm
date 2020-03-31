//
//  UIImage+Opencv.m
//  ARApp
//
//  Created by yuyunzhang on 2019/2/20.
//  Copyright © 2019年 yuyunzhang. All rights reserved.
//

#import "UIImage+Opencv.h"

@implementation UIImage (Opencv)
//+(UIImage *)imageFromCVMat:(cv::Mat)mat{
//    NSData *data = [NSData dataWithBytes:mat.data length:mat.elemSize()*mat.total()];
//    CGColorSpaceRef colorSpace;
//    if (mat.elemSize() == 1) {
//        colorSpace =CGColorSpaceCreateDeviceGray();
//    }else{
//        colorSpace = CGColorSpaceCreateDeviceRGB();
//    }
//    CGDataProviderRef provider= CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
//
//    CGImageRef imageRef = CGImageCreate(mat.cols, mat.rows, 8, 8 * mat.elemSize(), mat.step[0], colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
//
//    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    CGDataProviderRelease(provider);
//    CGColorSpaceRelease(colorSpace);
//
//    return finalImage;
//}

-(cv::Mat)matWithImage{
    UIImage* correctImage = self;
    UIGraphicsBeginImageContext(correctImage.size);
    [self drawInRect:CGRectMake(0, 0, correctImage.size.width, correctImage.size.height)];
    correctImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cv::Mat mat;
    UIImageToMat(correctImage, mat);
    
    return mat;
}

-(cv::Mat)matWithGetImage:(UIImage *)correctImage{
    UIGraphicsBeginImageContext(correctImage.size);
    [self drawInRect:CGRectMake(0, 0, correctImage.size.width, correctImage.size.height)];
    correctImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cv::Mat mat;
    UIImageToMat(correctImage, mat);
    
    return mat;
}

-(UIImage *)onGray{

    cv::Mat mat = [self matWithImage];
    cv::cvtColor(mat, mat, CV_BGR2GRAY);
    return MatToUIImage(mat);
}

-(UIImage *)onNot{
    cv::Mat mat = [self matWithImage];
    mat = ~mat;
    return MatToUIImage(mat);
}


-(UIImage *)onOtsu{
    cv::Mat mat = [self matWithImage];
    cv::cvtColor(mat, mat, CV_BGR2GRAY);
    cv::threshold(mat, mat, 0, 255, cv::THRESH_BINARY|cv::THRESH_OTSU);
    
    return MatToUIImage(mat);
}


-(UIImage *)onAdaptive{
    cv::Mat mat = [self matWithImage];
    cv::cvtColor(mat, mat, CV_BGR2GRAY);
    cv::adaptiveThreshold(mat, mat, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY, 7, 8);
    
    return MatToUIImage(mat);
}

-(UIImage *)DCTexchange{
    cv::Mat mat = [self matWithImage];
    cv::Mat outImg;
    cv::GaussianBlur(mat, outImg, cv::Size(5,5), 1.25);
    
    return MatToUIImage(mat);
}

-(UIImage *)GaussianExchange{
    cv::Mat mat = [self matWithImage];
    cv::Mat outImg;
    cv::GaussianBlur(mat, outImg, cv::Size(3,3), 0, 0);
    
    
    return MatToUIImage(outImg);
}

-(UIImage *)medianBlurExchange{
    cv::Mat mat = [self matWithImage];
    cv::Mat outImg;
    cv::medianBlur(mat, outImg, 3);
    
    return MatToUIImage(outImg);
}
//int display_dst( int delay )
//{
//  imshow( window_name, dst );
//  int c = waitKey ( delay );
//  if( c >= 0 ) { return -1; }
//  return 0;
//}


//int display_caption( const char* caption )
//{
//  dst = Mat::zeros( src.size(), src.type() );
//  putText( dst, caption,
//           cv::Point( src.cols/4, src.rows/2),
//           FONT_HERSHEY_COMPLEX, 1, Scalar(255, 255, 255) );
//  imshow( window_name, dst );
//  int c = waitKey( DELAY_CAPTION );
//  if( c >= 0 ) { return -1; }
//  return 0;
//}

-(NSString *)showCodeImage{
    
    cv::Mat mat = [self matWithImage];
    cv::Mat imge;
    cv::cvtColor(mat, imge, cv::COLOR_BGR2GRAY);
 
    const char codeLib[] = "@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,\"^`'.";
//
//
//
    std::string str;
    for (int y = 0; y < imge.rows; y++) {
        for (int x = 0; x < imge.cols; x++) {
            int grayVal = (int) imge.at<uchar>(y, x);
            int index = 68.0 / 255.0 * grayVal;
            str += codeLib[index];
        }
        str += "\n";
    }
//
    NSString *string = [NSString stringWithCString:str.c_str() encoding:NSUTF8StringEncoding];
    
    return string;
}

#pragma mark demo教程
///图片截取
-(UIImage *)captureImage:(CGRect)react{
     cv::Mat mat = [self matWithImage];
    cv::Rect rect(10, 10, 50, 50);
    cv::Mat  roi = cv::Mat(mat, rect);
    cv::Mat pImage  = mat.clone();
    
    return MatToUIImage(roi);
}

///图片截取
-(UIImage *)colorExcahngeImage{
     cv::Mat mat = [self matWithImage];
     cv::Mat temp = cv::Mat(600, 600, CV_8UC1);
    for (int i = 0; i < temp.rows; i++) {
        uchar *p = temp.ptr(i);
        for (int j = 0; j < temp.cols; j++) {
            double d1 = (double)((i+j) % 255);
            temp.at<uchar>(i, j) = d1;
            
            double d2 = temp.at<double>(i, j);
        }
    }
    
    
    return MatToUIImage(mat);
}

#pragma mark 空间域处理去燥
///Blur()//模糊
//-(UIImage *)blurImage{
//    
//    
//}

///boxFilter()
///
///addWeighted 图片合并
-(UIImage *)addWeightedImage:(UIImage *)byImage{
    cv::Mat  mat = [self matWithImage];//当前图片
    
    cv::Mat byMat = [self matWithGetImage:byImage];
    //两张图片的大小和类型要一样
    cv::Mat dst;
    if (mat.data && byMat.data && (mat.rows == byMat.rows) && (mat.cols == byMat.cols) && (mat.type() == byMat.type())) {
        double alpha = 0.8;
      cv::addWeighted(mat, alpha, byMat, (1-alpha), 0.0, dst);
//        cv::add(mat, byMat, dst); //直接相加
//        cv::multiply(mat, byMat, dst); //直接相乘
        return MatToUIImage(dst);
    }
    
    //处理失败
    return [UIImage imageNamed:@""];
}

///亮度和对比度调节
-(UIImage *)brightnessValue:(double)brightness contrastValue:(double)contrast{
    
    //
    cv::Mat mat = [self matWithImage];
    
    double widht = mat.cols;
    double height = mat.rows;
    cv::Size sizeOf(widht, height);
    //改造的写法
    cv::Mat tempMat = cv::Mat(sizeOf, mat.type());
    float alpha = contrast;//对比度
    float beta = brightness;//亮度
    
    cv::Mat copyMat;
    mat.convertTo(copyMat, CV_32F);
    
    for (int row = 0; row < height; row++) {
        for (int cols = 0; cols < widht; cols ++) {
            if (copyMat.channels() == 3) {//是多通道BGR
                float b =  copyMat.at<cv::Vec3f>(row, cols)[0];
                float g =  copyMat.at<cv::Vec3f>(row, cols)[1];
                float r =  copyMat.at<cv::Vec3f>(row, cols)[2];
                tempMat.at<cv::Vec3f>(row, cols)[0] = cv::saturate_cast<uchar>(b * alpha + beta);
                tempMat.at<cv::Vec3f>(row, cols)[1] = cv::saturate_cast<uchar>(g * alpha + beta);
                tempMat.at<cv::Vec3f>(row, cols)[2] = cv::saturate_cast<uchar>(r * alpha + beta);
            }else if (copyMat.channels() == 1){//单通道
                float v = mat.at<uchar>(row, cols);
                tempMat.at<uchar>(row, cols) = cv::saturate_cast<uchar>(v * alpha + beta);
            }
            
        }
    }
   
    return MatToUIImage(tempMat);
}

///绘制图形
//-(UIImage *)reactCanvesLineAndRoude{
///矩形 //   cv::rectangle(<#InputOutputArray img#>, <#Point pt1#>, <#Point pt2#>, <#const Scalar &color#>)
///线    cv::line(<#InputOutputArray img#>, <#Point pt1#>, <#Point pt2#>, <#const Scalar &color#>)
///椭圆    cv::ellipse(<#InputOutputArray img#>, <#Point center#>, <#Size axes#>, <#double angle#>, <#double startAngle#>, <#double endAngle#>, <#const Scalar &color#>)
///圆    cv::circle(<#InputOutputArray img#>, <#Point center#>, <#int radius#>, <#const Scalar &color#>)

///填充   cv::fillPoly(<#Mat &img#>, <#const Point **pts#>, <#const int *npts#>, <#int ncontours#>, <#const Scalar &color#>)
    
    
//}
@end
