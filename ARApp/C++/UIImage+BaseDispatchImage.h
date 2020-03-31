//
//  UIImage+BaseDispatchImage.h
//  ARApp
//
//  Created by yuyunzhang on 2020/3/16.
//  Copyright © 2020 yuyunzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BaseDispatchImage)
///转换成灰度图
-(UIImage *)onGray;

/// 高斯模糊
-(UIImage *)GaussianExchange;


/// 中值滤波
-(UIImage *)medianBlurExchange;
///均值滤波
-(UIImage *)avgBlurExchange;

///双边滤波 常用于美白
-(UIImage *)bilateralBlurExchange;

///膨胀（用区块内覆盖的最大值替换锚点也是中心点）
-(UIImage *)getStructuringElementDilate;

///腐蚀（用区块内覆盖的最小值替换锚点也是中心点）
-(UIImage *)getStructuringElementErode;

//开操作是基于膨胀和腐蚀的结合操作
-(UIImage *)getStructuringElementOpen;


//闭操作是基于膨胀和腐蚀的结合操作
-(UIImage *)getStructuringElementClose;
///提取里面的文字
-(UIImage *)getLineVH;
///上采样
-(UIImage *)pyrUp;
///下采样
-(UIImage *)pyrDown;
///生成DOG图
-(UIImage *)creatDOGimage;

///阈值处理和获取阈值
-(UIImage *)thresholdTypeAndDispatch;

///d自定义卷积处理（拉普拉斯）
-(UIImage *)getRobertAndSobel;
///sobles算子是离散求一阶导，
-(UIImage *)sobleImageDispatch;

///拉普拉斯算子是二阶导数
-(UIImage *)laplanceImageDispatch;


///canny边缘检测和处理
-(UIImage *)cannyEdgeDispatch;

///canny边缘检测和处理
//-(UIImage *)cannyEdgeDispatch;

///霍夫变换-检测直线
-(UIImage *)houghLineTransform;

///霍夫变换-检测圆
-(UIImage *)houghCircleTransform;

///映射
-(UIImage *)remapImage;

    ///直方图均衡
-(UIImage *)equalizeHistDiaptach;
@end

NS_ASSUME_NONNULL_END
