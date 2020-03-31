//
//  UIImage+Opencv.h
//  ARApp
//
//  Created by yuyunzhang on 2019/2/20.
//  Copyright © 2019年 yuyunzhang. All rights reserved.
//



#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Opencv)
-(UIImage *)onGray;

-(UIImage *)onNot;

-(UIImage *)onOtsu;

-(UIImage *)onAdaptive;
// 余弦离散变换
-(UIImage *)DCTexchange;

    /// 高斯模糊
-(UIImage *)GaussianExchange;

    /// 中值滤波
-(UIImage *)medianBlurExchange;


    /// 输出像素图
-(NSString *)showCodeImage;



-(UIImage *)showEnhanceImage;
//学习样本处理

///图片截取
-(UIImage *)captureImage:(CGRect)react;


-(UIImage *)colorExcahngeImage;


    /// 图片合成
    /// @param byImage 被合成
-(UIImage *)addWeightedImage:(UIImage *)byImage;

///亮度和对比度调节
-(UIImage *)brightnessValue:(double)brightness contrastValue:(double)contrast;
@end

NS_ASSUME_NONNULL_END
