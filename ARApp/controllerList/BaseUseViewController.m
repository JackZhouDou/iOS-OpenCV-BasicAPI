//
//  BaseUseViewController.m
//  ARApp
//
//  Created by yuyunzhang on 2020/3/16.
//  Copyright © 2020 yuyunzhang. All rights reserved.
//

#import "BaseUseViewController.h"
#import "UIImage+BaseDispatchImage.h"
#import "DispatchImageShowViewController.h"
@interface BaseUseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *showList;
@end

@implementation BaseUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showList = @[@{@"title":@"灰度图像", @"tag":@"0"},
                      @{@"title":@"亮度对比度调节",@"tag":@"1"},
                      @{@"title":@"高斯模糊",@"tag":@"2"},
                      @{@"title":@"中值滤波器",@"tag":@"3"},
                      @{@"title":@"均值滤波器",@"tag":@"4"},
                      @{@"title":@"双边滤波器",@"tag":@"5"},
                      @{@"title":@"绘制图形",@"tag":@"6"},
                      @{@"title":@"膨胀",@"tag":@"7"},
                      @{@"title":@"开操作",@"tag":@"8"},
                      @{@"title":@"腐蚀",@"tag":@"9"},
                      @{@"title":@"闭操作",@"tag":@"10"},
                      @{@"title":@"提取里面的文字",@"tag":@"11"},
                      @{@"title":@"上采样",@"tag":@"12"},
                      @{@"title":@"DOG",@"tag":@"13"},
                     @{@"title":@"自定义模糊（拉普拉斯）",@"tag":@"14"},
                    @{@"title":@"sobel算子",@"tag":@"15"},
                     @{@"title":@"Laplance算子",@"tag":@"16"},
                    @{@"title":@"canny边缘检测",@"tag":@"17"},
                    @{@"title":@"霍夫变换-提取直线",@"tag":@"18"},
                    @{@"title":@"霍夫变换-提取圆",@"tag":@"19"},
                   @{@"title":@"重映射",@"tag":@"20"},
                   @{@"title":@"直方图均衡",@"tag":@"21"}];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.showList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    static NSString * cellid = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
    
    if (indexPath.row < self.showList.count) {
        NSDictionary *dic = self.showList[indexPath.row];
        cell.textLabel.text = dic[@"title"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.showList.count) {
        NSDictionary *dic = self.showList[indexPath.row];
        [self imageDispatchTag:dic];
    }
    
}

///处理tag
-(void)imageDispatchTag:(NSDictionary *)dic{
     NSInteger tag = [dic[@"tag"] integerValue];
    NSString *titleString = dic[@"title"];
    switch (tag) {
           case 0:
            {//灰度图像
                DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                vc.title = titleString;
                UIImage *image = [UIImage imageNamed:@"lenna.png"];
                [vc showOriginalImage:image withDispatchImage:[image onGray]];
                [self.navigationController pushViewController:vc animated:YES];
                 
            
             }
            break;
            case 1:
                   {//亮度对比度调节
                   
                   }
                       break;
            case 2:
                   {//高斯模糊
                       DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                       vc.title = titleString;
                       UIImage *image = [UIImage imageNamed:@"lenna.png"];
                       [vc showOriginalImage:image withDispatchImage:[image GaussianExchange]];
                       [self.navigationController pushViewController:vc animated:YES];
                   }
                       break;
            case 3:
                   {//中值滤波器
                   DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                   vc.title = titleString;
                   UIImage *image = [UIImage imageNamed:@"blur.png"];
                   [vc showOriginalImage:image withDispatchImage:[image medianBlurExchange]];
                   [self.navigationController pushViewController:vc animated:YES];
                   }
                       break;
            case 4:
                   {//均值滤波器
             DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                 vc.title = titleString;
                            UIImage *image = [UIImage imageNamed:@"lenna.png"];
                    [vc showOriginalImage:image withDispatchImage:[image avgBlurExchange]];
                                     [self.navigationController pushViewController:vc animated:YES];
                   }
                       break;
            
            case 5:
                   {//双边滤波器
           DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                        vc.title = titleString;
                UIImage *image = [UIImage imageNamed:@"blur.png"];
               [vc showOriginalImage:image withDispatchImage:[image bilateralBlurExchange]];
                [self.navigationController pushViewController:vc animated:YES];
                   }
                       break;
            case 6:
                   {//绘制图形
                   
                   
                   }
                       break;
            case 7:
                   {//"膨胀
                       DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                vc.title = titleString;
                        UIImage *image = [UIImage imageNamed:@"shapeClose.png"];
                       [vc showOriginalImage:image withDispatchImage:[image getStructuringElementDilate]];
                        [self.navigationController pushViewController:vc animated:YES];
                   }
                       break;
            case 8:
                   {// 开操作
              DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                          vc.title = titleString;
                UIImage *image = [UIImage imageNamed:@"shapeTest.png"];
                         [vc showOriginalImage:image withDispatchImage:[image getStructuringElementOpen]];
            [self.navigationController pushViewController:vc animated:YES];
                       
                   }
                       break;
            case 9: {//腐蚀
        DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                       vc.title = titleString;
                               UIImage *image = [UIImage imageNamed:@"shapeTest.png"];
                              [vc showOriginalImage:image withDispatchImage:[image getStructuringElementErode]];
                               [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 10: {//闭操作
                   DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                                  vc.title = titleString;
                                          UIImage *image = [UIImage imageNamed:@"shapeClose.png"];
                            [vc showOriginalImage:image withDispatchImage:[image getStructuringElementClose]];
                                          [self.navigationController pushViewController:vc animated:YES];
                   }
                       break;
            case 11: {//提取里面的文字
            DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                           vc.title = titleString;
                                   UIImage *image = [UIImage imageNamed:@"shapeExchange.png"];
                     [vc showOriginalImage:image withDispatchImage:[image getLineVH]];
                                   [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 12: {//
            DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                           vc.title = titleString;
                                   UIImage *image = [UIImage imageNamed:@"lenna.png"];
                     [vc showOriginalImage:image withDispatchImage:[image pyrUp]];
                                   [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 13: {//
                       DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                                      vc.title = titleString;
                                              UIImage *image = [UIImage imageNamed:@"lenna.png"];
                                [vc showOriginalImage:image withDispatchImage:[image creatDOGimage]];
                                              [self.navigationController pushViewController:vc animated:YES];
                       }
                           break;
            case 14: {//
                                 DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                                                vc.title = titleString;
                                                        UIImage *image = [UIImage imageNamed:@"lenna.png"];
                        [vc showOriginalImage:image withDispatchImage:[image getRobertAndSobel]];
                        [self.navigationController pushViewController:vc animated:YES];
                                 }
                                     break;
            case 15: {//
                                            DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                                                           vc.title = titleString;
                                                                   UIImage *image = [UIImage imageNamed:@"lenna.png"];
                                   [vc showOriginalImage:image withDispatchImage:[image sobleImageDispatch]];
                                   [self.navigationController pushViewController:vc animated:YES];
                                            }
                                                break;
            case 16: {//
                     DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                                    vc.title = titleString;
                                            UIImage *image = [UIImage imageNamed:@"lenna.png"];
            [vc showOriginalImage:image withDispatchImage:[image laplanceImageDispatch]];
            [self.navigationController pushViewController:vc animated:YES];
                     }
                         break;
            case 17: {//边缘提取
                                DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                                               vc.title = titleString;
                                                       UIImage *image = [UIImage imageNamed:@"lenna.png"];
                       [vc showOriginalImage:image withDispatchImage:[image cannyEdgeDispatch]];
                       [self.navigationController pushViewController:vc animated:YES];
                                }
                                    break;
            
            case 18: {//边缘提取
                                           DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                                                          vc.title = titleString;
                                                                  UIImage *image = [UIImage imageNamed:@"shapeExchange.png"];
                [vc showOriginalImage:image withDispatchImage:[image houghLineTransform]];
                [self.navigationController pushViewController:vc animated:YES];
                                           }
                                               break;
            case 19: {//提取圆
                                                      DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                                                                     vc.title = titleString;
                                                                             UIImage *image = [UIImage imageNamed:@"shapeExchange.png"];
                           [vc showOriginalImage:image withDispatchImage:[image houghCircleTransform]];
                           [self.navigationController pushViewController:vc animated:YES];
                                                      }
                                                          break;
            case 20: {//重映射
                                                                 DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                                                                                                vc.title = titleString;
                                                                    UIImage *image = [UIImage imageNamed:@"lenna.png"];
                                      [vc showOriginalImage:image withDispatchImage:[image remapImage]];
                                      [self.navigationController pushViewController:vc animated:YES];
                                                                 }
                                                                     break;
            
            
            case 21: {//直方图
                DispatchImageShowViewController *vc = [DispatchImageShowViewController new];
                        vc.title = titleString;
                    UIImage *image = [UIImage imageNamed:@"lenna.png"];
                [vc showOriginalImage:[image onGray] withDispatchImage:[image equalizeHistDiaptach]];
        [self.navigationController pushViewController:vc animated:YES];
                                                                            }
                                                                                break;
        default:
            break;
    }
    
    
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
