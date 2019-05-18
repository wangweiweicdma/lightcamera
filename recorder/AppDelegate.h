//
//  AppDelegate.h
//  recorder
//
//  Created by wangweiwei on 2018/11/19.
//  Copyright © 2018年 wangweiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

