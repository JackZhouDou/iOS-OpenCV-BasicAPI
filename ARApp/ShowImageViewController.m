//
//  ShowImageViewController.m
//  ARApp
//
//  Created by yuyunzhang on 2019/11/20.
//  Copyright © 2019 yuyunzhang. All rights reserved.
//

#import "ShowImageViewController.h"
#import <Masonry/Masonry.h>
#import "UIImage+Opencv.h"
@interface ShowImageViewController ()

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"返回" forState:0];
    [button addTarget:self action:@selector(cancelViewPop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(25);
    }];
    
    UIScrollView *scr = [UIScrollView new];
    [self.view addSubview:scr];
    [scr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(50);
        make.bottom.equalTo(self.view);
    }];
    
    UIView *view = [UIView new];
    [scr addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scr);
        make.width.equalTo(scr);
    }];
    
    UILabel *lable = [UILabel new];
    [view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(view);
    }];
    
    UIImage *orgimage = [UIImage imageNamed:@"pblogo"];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.numberOfLines = 0;
    lable.font = [UIFont systemFontOfSize:2];
    lable.text = [orgimage showCodeImage];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)cancelViewPop{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
