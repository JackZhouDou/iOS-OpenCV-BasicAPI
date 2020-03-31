//
//  UIImage+BaseDispatchImage.m
//  ARApp
//
//  Created by yuyunzhang on 2020/3/16.
//  Copyright © 2020 yuyunzhang. All rights reserved.
//

#import "UIImage+BaseDispatchImage.h"


@implementation UIImage (BaseDispatchImage)
///OC图转换成C++图片对象Mat
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

#pragma mark 基础部分
///转换成灰度图
-(UIImage *)onGray{
    cv::Mat mat = [self matWithImage];
    cv::Mat gray;
      cv::cvtColor(mat, gray, CV_BGR2RGB);
      return MatToUIImage(mat);
    
}

/// 高斯模糊
-(UIImage *)GaussianExchange{
    cv::Mat mat = [self matWithImage];
       cv::Mat outImg;
        double size = 5; //必须是奇数
       cv::GaussianBlur(mat, outImg, cv::Size(size,size), 11, 11);
       return MatToUIImage(outImg);
    
}


/// 中值滤波
-(UIImage *)medianBlurExchange{
    cv::Mat mat = [self matWithImage];
       cv::Mat outImg;
    int size = 3; //表示3x3点方形矩阵必须也是奇数； 如果问我为什么是奇数因为不是奇数的话就没有中间点, 卷积运算中，对3x3中的9个值排序取中间值给中心位置；
       cv::medianBlur(mat, outImg, size);
       
       return MatToUIImage(outImg);
    
}

///均值滤波
-(UIImage *)avgBlurExchange{
    cv::Mat mat = [self matWithImage];
    cv::Mat outImg;
    cv::blur(mat, outImg, cv::Size(3,3), cv::Point(-1, -1));
    
    return MatToUIImage(outImg);
}

    /// 双边滤波 常用于美白
-(UIImage *)bilateralBlurExchange{
    cv::Mat mat = [self matWithImage];
    
    cv::Mat outImg;
//    int type = mat.type();//原图有要求：需要为8位或者浮点型单通道、三通道的图像
    cv::cvtColor(mat, mat, cv::COLOR_RGBA2RGB);
    
//    关于2个sigma参数：
//
//    简单起见，可以令2个sigma的值相等；
//    如果他们很小（小于10），那么滤波器几乎没有什么效果；
//    如果他们很大（大于150），那么滤波器的效果会很强，使图像显得非常卡通化；
//    关于参数d：
//
//    过大的滤波器（d>5）执行效率低。
//    对于实时应用，建议取d=5；
//    对于需要过滤严重噪声的离线应用，可取d=9；
//    d>0时，由d指定邻域直径；
//    d<=0时，d会自动由sigmaSpace的值确定，且d与sigmaSpace成正比；
//    cv::bilateralFilter(原图, 输出图, d, sigmaColor, sigmaSpace);
  
    cv::bilateralFilter(mat, outImg, 20, 100, 100);
    
    return MatToUIImage(outImg);
}
///膨胀（用区块内覆盖的最大值替换锚点也是中心点）主要用于大替小
-(UIImage *)getStructuringElementDilate{
    cv::Mat mat = [self matWithImage];
    //覆盖区创建parameter1 现状（三种现状）    parameter2 尺寸
  cv::Mat elemant = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(9, 9));
    cv::Mat outMat;

    cv::dilate(mat, outMat, elemant);
    
    
    return MatToUIImage(outMat);
}
///腐蚀（用区块内覆盖的最大值替换锚点也是中心点）
-(UIImage *)getStructuringElementErode{
    cv::Mat mat = [self matWithImage];
    //覆盖区创建parameter1 现状（三种现状）    parameter2 形状尺寸
  cv::Mat elemant = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(9, 9));
    cv::Mat outMat;

    cv::erode(mat, outMat, elemant);
    
    
    return MatToUIImage(outMat);
}

//开操作是基于膨胀和腐蚀的结合操作
-(UIImage *)getStructuringElementOpen{
    cv::Mat mat = [self matWithImage];
    cv::Mat elemant = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(11, 11));
    cv::Mat outMat;
    // 第三个参数是类型表示开操作， 实现的是先腐蚀后膨胀 去掉小的斑点
    cv::morphologyEx(mat, outMat, CV_MOP_OPEN, elemant);
    
    return MatToUIImage(outMat);
}

//闭操作是基于膨胀和腐蚀的结合操作
-(UIImage *)getStructuringElementClose{
    cv::Mat mat = [self matWithImage];
    cv::Mat elemant = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(11, 11));
    cv::Mat outMat;
    // 第三个参数是类型表示开操作， 闭操作实现的是先膨胀后腐蚀 纯色中的缺点补上     //还有梯度图：CV_MOP_GRADIENT（膨胀减腐蚀） //顶帽图：CV_MOP_TOPHAT(原图与开操作之后的差值)
         //黑帽：CV_MOP_BLACKHAT(原图与闭操作的差值)
    cv::morphologyEx(mat, outMat, CV_MOP_CLOSE, elemant);
    
    return MatToUIImage(outMat);
}
///提取里面的文字
-(UIImage *)getLineVH{
    cv::Mat  mat = [self matWithImage];
    cv::Mat grayMat;
    cv::cvtColor(mat, grayMat, cv::COLOR_BGR2GRAY);
    //转换成二值图像, 自适应阈值
    cv::Mat binImg;
    cv::adaptiveThreshold(~grayMat, binImg, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 15, -3);
     cv::Mat rectElement = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(3,3));
    cv::Mat temp;
    cv::erode(binImg, temp, rectElement);
    cv::dilate(temp, mat, rectElement);
    cv::bitwise_not(mat, mat);
    //
    cv::blur(mat, mat, cv::Size(3, 3));
    return MatToUIImage(mat);
}

///上采样（对图像放大2倍处理）
-(UIImage *)pyrUp{
    cv::Mat mat = [self matWithImage];
    cv::Mat outMat;
    cv::pyrUp(mat, outMat, cv::Size(mat.cols * 2, mat.rows * 2));
    
    return MatToUIImage(outMat);
}

//降采样对图像缩小一倍
-(UIImage *)pyrDown{
    cv::Mat mat = [self matWithImage];
    cv::Mat outMat;
    cv::pyrUp(mat, outMat, cv::Size(mat.cols * 0.5, mat.rows * 0.5));
    
    return MatToUIImage(outMat);
}
///生成DOG图
-(UIImage *)creatDOGimage{
    cv::Mat mat = [self matWithImage];
    cv::Mat outMat, gryMat, tempMat1, tempMat2;
    cv::cvtColor(mat, gryMat, cv::COLOR_BGR2GRAY);
    cv::GaussianBlur(gryMat, tempMat1, cv::Size(7,7), 0);
    cv::GaussianBlur(tempMat1, tempMat2, cv::Size(7, 7), 0);
    cv::subtract(tempMat1, tempMat2, outMat);
    
    //归一显示
    cv::normalize(outMat, outMat, 255, 0, cv::NORM_MINMAX);
   
    return MatToUIImage(outMat);
}


///阈值处理和获取阈值
-(UIImage *)thresholdTypeAndDispatch{
    cv::Mat mat = [self matWithImage];
    cv::Mat gray, threshodlMat;
    cv::cvtColor(mat, gray, CV_BGR2GRAY);
    //五种处理类型二值处理：THRESH_BINARY 反二值处理：THRESH_BINARY_INV, 截断， 取零， 反取零
    cv::threshold(mat, threshodlMat, 180, 255, cv::THRESH_BINARY);
    
    return MatToUIImage(threshodlMat);
}
//各类卷积算子处理图像(自定义卷积模糊)
-(UIImage *)getRobertAndSobel{
    cv::Mat mat = [self matWithImage];
    
//    cv::cvtColor(mat, mat, CV_BGR2GRAY);
    cv::Mat outMat;
    //robert算子
//x  //1, 0   //y // 0,  1
    //0,-1       //-1,  0
    cv::Mat  kernel_robert = (cv::Mat_<int>(2,2)<<1,0,0,-1);
    
    //拉普拉斯算子
    //-1，0, 1
    //-2, 0, 2
    //-1, 0, 1
    cv::Mat kernel_lapulas = (cv::Mat_<int>(3,3)<<0,-1,0,-1,4,-1,0,-1,0);
    
    
    //soble算子
    //-1，0, 1
    //-2, 0, 2
    //-1, 0, 1
    cv::Mat kernel_soble = (cv::Mat_<int>(3,3)<<-1,0,1,-2,0,2,-1,0,1);

    cv::Mat kernel = cv::Mat::ones(cv::Size(5, 5), CV_32F) / (float)(5.0 * 5.0);
    
    cv::filter2D(mat, outMat, -1, kernel, cv::Point(-1,-1), 0, cv::BORDER_CONSTANT);
    
    return MatToUIImage(outMat);
}


-(UIImage *)sobleImageDispatch{
 cv::Mat mat = [self matWithImage];
    cv::Mat outMat, gausMat, grayMat, outMat1;
    cv::GaussianBlur(mat, gausMat, cv::Size(3, 3), 0);
    cv::cvtColor(gausMat, grayMat, CV_BGR2GRAY);
    cv::Sobel(grayMat, outMat, CV_16S, 1, 0, 3);//x梯度
    cv::Sobel(grayMat, outMat1, CV_16S, 0, 1, 3);//y梯度
    cv::convertScaleAbs(outMat, outMat);//取绝对值
    cv::convertScaleAbs(outMat1, outMat1);//取绝对值
    
    cv::addWeighted(outMat, 0.5, outMat1, 0.5, 0, outMat);//图像融合
    return MatToUIImage(outMat);
}

-(UIImage *)laplanceImageDispatch{
  cv::Mat mat = [self matWithImage];
    cv::Mat outMat, gausMat, grayMat, outMat1;
    cv::GaussianBlur(mat, gausMat, cv::Size(3, 3), 0);
    cv::cvtColor(gausMat, grayMat, CV_BGR2GRAY);
    cv::Laplacian(grayMat, outMat, CV_16S, 3);
    cv::convertScaleAbs(outMat, outMat);
    cv::threshold(outMat, outMat1, 0, 255, cv::THRESH_BINARY | cv::THRESH_OTSU);//阈值二值化
    return MatToUIImage(outMat1);
    
}
///canny边缘检测和处理
-(UIImage *)cannyEdgeDispatch{
    cv::Mat mat = [self matWithImage];
    //第一步高斯模糊 去噪
    //灰度处理
    //计算梯度
    //非最大信号抑制(很重要)
    //高低阈值链接处理输出二值图像 （3:1）/（2:1）；
    cv::Mat gaussMat, grayMat,  outMat;
    cv::GaussianBlur(mat, gaussMat, cv::Size(5, 5), 0);
    cv::cvtColor(gaussMat, grayMat, CV_BGR2GRAY);
//    低于阈值1的像素点会被认为不是边缘；
//    高于阈值2的像素点会被认为是边缘；
//   在阈值1和阈值2之间的像素点,若与第2步得到的边缘像素点相邻，则被认为是边缘，否则被认为不是边缘。
  //最后一个参数是代表精度true的精度更高
    
    cv::Canny(grayMat, outMat, 25, 80, 3, false);
    //加粗膨胀
//     cv::Mat elemant = cv::getStructuringElement(cv::MORPH_CROSS, cv::Size(3, 3));
//    cv::dilate(outMat, outMat, elemant);
    
    return MatToUIImage(~outMat);
    
}
///霍夫变换-检测水平线
-(UIImage *)houghLineTransform {
    cv::Mat mat = [self matWithImage];
    cv::Mat  grayMat, outMat, edgMat;
    cv::cvtColor(mat, grayMat, CV_BGR2GRAY);
    cv::GaussianBlur(grayMat, outMat, cv::Size(3, 3), 0);
    cv::Canny(outMat, edgMat, 50, 150, 3, false);//边缘检测
    
    std::vector<cv::Vec4f> plines;//装载线的向量点数组@[@[x1,y1,x2,y2],@[x1,y1,x2,y2],@[x1,y1,x2,y2]]可以这么理解每个
    //平面空间转换成平面空间转换成极坐标空间
//    cv::HoughLines(<#InputArray image#>, <#OutputArray lines#>, <#double rho#>, <#double theta#>, <#int threshold#>)
    ///返回的是坐标点
    
// image： 必须是二值图像，推荐使用canny边缘检测的结果图像；
    
//rho: 线段以像素为单位的距离精度，double类型的，推荐用1.0
    
//theta： 线段以弧度为单位的角度精度，推荐用numpy.pi/180
    
//InputArray类型的lines，经过调用HoughLinesP函数后后存储了检测到的线条的输出矢量，每一条线由具有四个元素的矢量(x_1,y_1, x_2, y_2）  表示，其中，(x_1, y_1)和(x_2, y_2) 是是每个检测到的线段的结束点
    
//threshod： 累加平面的阈值参数，int类型，超过设定阈值才被检测出线段，值越大，基本上意味着检出的线段越长，检出的线段个数越少。根据情况推荐先用100试试
    
//minLineLength：线段以像素为单位的最小长度，根据应用场景设置
    
//maxLineGap：同一方向上两条线段判定为一条线段的最大允许间隔（断裂），超过了设定值，则把两条线段当成一条线段，值越大，允许线段上的断裂越大，越有可能检出潜在的直线段

    cv::HoughLinesP(edgMat, plines, 1, CV_PI / 180.0, 50, 100.0, 10.0);
    
//创建一个空白的面板对于CV_8UC3的解释数字8(包括8, 16, 32, 64)代表数据的位数比如用int就是8， float是32， double是64， 和面的3(包括1, 2, 3, 4)代表通道； 什么是通道比如灰度图是1个通道要么是黑要么就是白， RGB是3个通道因为他需要存储三种颜色的值， 如果还有透明度A比如：RGBA那就是4个通道
    cv::Mat tempMat = cv::Mat(cv::Size(grayMat.cols, grayMat.rows), CV_8UC3, cv::Scalar(0, 255, 255));
    
    cv::Scalar color = cv::Scalar(255, 255, 255);
    
    for (size_t i = 0; i<plines.size(); i++) {
        cv::Vec4f hline = plines[i];
        cv::line(tempMat, cv::Point(hline[0], hline[1]), cv::Point(hline[2], hline[3]), color, 2);//划线

    }
    
    return MatToUIImage(tempMat);
}
///霍夫变换-检测圆
-(UIImage *)houghCircleTransform{
    cv::Mat mat = [self matWithImage];
    cv::Mat grayMat, outMat, edgMat;
    cv::cvtColor(mat, grayMat, CV_BGR2GRAY);
    cv::medianBlur(grayMat, outMat, 3);//中值滤波
//    cv::Canny(outMat, edgMat, 50, 150, 3, false);
    
    cv::Mat tempMat = cv::Mat(mat.rows, mat.cols, CV_8UC3, cv::Scalar(255, 255, 255));
    std::vector<cv::Vec3f> plain;//vec3f三个flaot
//    HoughCircles函数的原型为：
//        void HoughCircles(InputArray image,OutputArray circles, int method, double dp, double minDist, double param1=100, double param2=100, int minRadius=0,int maxRadius=0 )
//        image为输入图像，要求是灰度图像
//        circles为输出圆向量，每个向量包括三个浮点型的元素——圆心横坐标，圆心纵坐标和圆半径
//        method为使用霍夫变换圆检测的算法，Opencv2.4.9只实现了2-1霍夫变换，它的参数是CV_HOUGH_GRADIENT
//        dp为第一阶段所使用的霍夫空间的分辨率，dp=1时表示霍夫空间与输入图像空间的大小一致，dp=2时霍夫空间是输入图像空间的一半，以此类推
//        minDist为圆心之间的最小距离，如果检测到的两个圆心之间距离小于该值，则认为它们是同一个圆心
//        param1、param2为阈值
//        minRadius和maxRadius为所检测到的圆半径的最小值和最大值
    cv::HoughCircles(outMat, plain,  CV_HOUGH_GRADIENT, 1, 20, 100, 30, 5, 50);
    for (size_t i = 0; i < plain.size(); i++) {
        cv::Vec3f cc = plain[i];
        cv::circle(tempMat, cv::Point(cc[0], cc[1]), cc[2], cv::Scalar(255,4,200), 2);
        cv::circle(tempMat, cv::Point(cc[0], cc[1]), 2, cv::Scalar(255,0,0), 1);
    }
    
    return MatToUIImage(tempMat);
    
}

-(UIImage *)remapImage{
    cv::Mat mat = [self matWithImage];
    cv::Mat outMat = cv::Mat(mat.rows, mat.cols, mat.type());
    cv::Mat mMapx  =  cv::Mat(mat.rows, mat.cols, CV_32FC1, cv::Scalar(0));
    cv::Mat mMapy  =  cv::Mat(mat.rows, mat.cols, CV_32FC1, cv::Scalar(0));
    for (int i = 0; i < mat.rows; i++) {
        float *ptrx = mMapx.ptr<float>(i);
        float *ptry = mMapy.ptr<float>(i);
        for (int j = 0; j < mat.cols; j++) {
            ptrx[j] =(float)(mat.cols - j);//坐标转换前后调换
            ptry[j] = (float)i;//不调换
            //
//            ptrx[j] = (float)j;
//            ptry[j] = (float)(mat.rows - i);
            //
        }
        
    }
    cv::remap(mat, outMat, mMapx, mMapy, cv::INTER_LINEAR);//重映射， 插值处理
     
    return MatToUIImage(outMat);
    
}
///直方图均衡
-(UIImage *)equalizeHistDiaptach{
    cv::Mat mat = [self matWithImage];
    cv::Mat grayMat, outMat;
    
    cv::cvtColor(mat, grayMat, CV_BGR2GRAY);
    cv::equalizeHist(grayMat, outMat);
    
    return MatToUIImage(outMat);
}
@end
