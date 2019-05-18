//
//  TodayViewController.m
//  todaydemo
//
//  Created by wangweiwei on 2019/4/22.
//  Copyright © 2019 wangweiwei. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UILabel * lable = [[UILabel alloc] initWithFrame:self.view.frame];
//    lable.text = @"最省电的手电筒";
//
//    [self.view addSubview:lable];
    
//    [self.view setBackgroundColor:[UIColor clearColor]];
//
    
    UIControl * btn = [[UIControl alloc] initWithFrame:self.view.frame];
    [btn addTarget:self action:@selector(tapTest:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    
}

- (IBAction)tapTest:(id)sender{
    

    [self.extensionContext openURL:[NSURL URLWithString:@"recorder://xxx"] completionHandler:nil];
    
    
    
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    
    self.preferredContentSize = CGSizeMake(0, 0);

    
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
