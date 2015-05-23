//
//  ViewController.m
//  IOSToolKit
//
//  Created by liangqi on 15/5/23.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "ViewController.h"

#import "UIView+ITK_Loading.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view itk_showLoading:@"努力加载中.."];
}


@end
