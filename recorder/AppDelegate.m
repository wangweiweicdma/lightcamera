//
//  AppDelegate.m
//  recorder
//
//  Created by wangweiwei on 2018/11/19.
//  Copyright © 2018年 wangweiwei. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    NSString * tmpDir = NSTemporaryDirectory();
    NSLog(@" temp path :%@",tmpDir);
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray  * tempArray =  [fm contentsOfDirectoryAtPath:tmpDir error:nil];
    
    for (NSString * path in tempArray) {
        NSLog(@"file list :%@",path);
        NSString * tempfile = [tmpDir stringByAppendingPathComponent:path];
        [fm removeItemAtPath:tempfile error:nil];
    }
    
    
    
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    
    NSLog(@"applicationWillResignActive  ");

    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"applicationWillEnterForeground  ");

   
    
    NSString * tmpDir = NSTemporaryDirectory();
    NSLog(@" temp path :%@",tmpDir);
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray  * tempArray =  [fm contentsOfDirectoryAtPath:tmpDir error:nil];
    
    
    NSLog(@"the current file item : %@",[tempArray firstObject]);
    
    
    
    //文件管理器
    
    //         NSString *homePath = NSHomeDirectory();
    NSArray *docPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    
    
    //创建视频的存放路径
    NSDate * date = [NSDate date];
    NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM_dd-HH_mm";
    
    
    NSString * path = [NSString stringWithFormat:@"%@/video_%@.mp4",  documentsPath, [fmt stringFromDate:date]];
    NSURL *mergeFileURL = [NSURL fileURLWithPath:path];
    //NSString * videoUrl = mergeFileURL;
    
    //通过文件管理器将视频存放的创建的路径中
    NSString * tempPath = [tmpDir stringByAppendingPathComponent:[tempArray firstObject]];
    

    NSURL *tempurl = [NSURL fileURLWithPath:tempPath];

    
    [fm copyItemAtURL:tempurl  toURL:mergeFileURL error:nil];
    
    
    NSLog(@"save file sucess ");
    
    exit(0);
}




- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"recorder"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    NSLog(@"saveContext");
}

@end
