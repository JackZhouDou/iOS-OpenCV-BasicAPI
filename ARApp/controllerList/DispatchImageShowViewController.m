//
//  DispatchImageShowViewController.m
//  ARApp
//
//  Created by yuyunzhang on 2020/3/16.
//  Copyright © 2020 yuyunzhang. All rights reserved.
//

#import "DispatchImageShowViewController.h"

@interface DispatchImageShowViewController ()

    /// 原图
@property (weak, nonatomic) IBOutlet UIImageView *originalImage;
//处理后的图
@property (weak, nonatomic) IBOutlet UIImageView *dispatchImage;

@property (nonatomic, strong) UIImage *original;
@property (nonatomic, strong) UIImage *dispatch;
@end

@implementation DispatchImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originalImage.image = self.original;
    self.dispatchImage.image = self.dispatch;
    // Do any additional setup after loading the view from its nib.
}

-(void)showOriginalImage:(UIImage *)originalImage withDispatchImage:(UIImage *)dispatchImage{
    self.original = originalImage;
    self.dispatch = dispatchImage;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
