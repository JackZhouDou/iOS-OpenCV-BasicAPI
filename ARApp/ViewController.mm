//
//  ViewController.m
//  ARApp
//
//  Created by yuyunzhang on 2019/2/19.
//  Copyright © 2019年 yuyunzhang. All rights reserved.
//

#import "ViewController.h"

//#ifdef __cplusplus
#import "UIImage+Opencv.h"
//#endif
#import "PDFLoadinViewController.h"
#import "ShowImageViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *showList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"openCV+识别";
    self.showList = @[@{@"title":@"OpenCV基础处理", @"vc":@"BaseUseViewController"},
                       @{@"title":@"高级识别处理",@"vc":@""}];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.showList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * cellid = @"cell0";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
    
    NSDictionary *dic = self.showList[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.showList[indexPath.row];
       NSString *classString = dic[@"vc"];
    NSString *titleString = dic[@"title"];
    if (classString.length) {
        Class vcName = NSClassFromString(classString);
        if (vcName) {
           
            UIViewController *vc = [vcName new];
            [vc setValue:titleString forKey:@"title"];
        [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}




@end
