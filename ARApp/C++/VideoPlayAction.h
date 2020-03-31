//
//  VideoPlayAction.h
//  ARApp
//
//  Created by yuyunzhang on 2019/3/26.
//  Copyright © 2019年 yuyunzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayAction : CvVideoCamera


@property BOOL letterboxPreview;

- (void)setPointOfInterestInParentViewSpace:(CGPoint)point;
/**
 开始录制视频

 @return 返回
 */
-(BOOL)startVideo;
-(BOOL)stopVideo;
@end

NS_ASSUME_NONNULL_END
