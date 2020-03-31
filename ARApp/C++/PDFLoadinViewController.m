//
//  PDFLoadinViewController.m
//  ARApp
//
//  Created by yuyunzhang on 2019/12/12.
//  Copyright © 2019 yuyunzhang. All rights reserved.
//

#import "PDFLoadinViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
@interface PDFLoadinViewController ()

@end

@implementation PDFLoadinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    WKWebView *webview = [WKWebView new];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.211:8080/webPdf/1561338708813.html"]]];
    
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
