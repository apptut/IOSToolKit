//
//  ViewController.m
//  IOSToolKit
//
//  Created by liangqi on 15/5/23.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+ITK_Refresh.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *testTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.testTableView itk_onRefreshStart:^{
        NSLog(@"on top refresh load");
    }];
    
    [self.testTableView itk_onLoadMoreStart:^{
        NSLog(@"onload load more code");
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];

    return cell;
}


@end
