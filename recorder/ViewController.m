//
//  ViewController.m
//  recorder
//
//  Created by wangweiwei on 2018/11/19.
//  Copyright © 2018年 wangweiwei. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MyRecorderControllerViewController.h"

#import "AppDelegate.h"

@interface ViewController () 
@property(null_resettable, nonatomic,strong) UIImagePickerController  * cameraController;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    // Do any additional setup after loading the view, typically from a nib.

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
        NSLog(@" get video recorder ok !");
        
        
        
        UIImagePickerController * controller = [[MyRecorderControllerViewController alloc]init];
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        controller.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        
        controller.mediaTypes = [NSArray arrayWithObjects:( NSString *)kUTTypeMovie, nil];
        controller.videoMaximumDuration = 60*60*2;
        
        controller.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;

        [root presentViewController:controller animated:YES completion:^{
            [controller startVideoCapture];
        }];
        
        controller.delegate = self;
        
        self.cameraController = controller;
        
        
    }];
    
    
    
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
     if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
         NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
         

         NSString *urlPath = [mediaUrl path];
         
         NSLog(@"stop video : %@",urlPath);
         
         NSFileHandle * file = [NSFileHandle fileHandleForWritingAtPath:urlPath];

         [file seekToEndOfFile];
         NSData * data = [[NSData alloc] initWithContentsOfFile:urlPath];
         [file writeData:data];
         [file synchronizeFile];
         
         

         NSFileManager* fileManager = [NSFileManager defaultManager];
         BOOL readable =  [fileManager isReadableFileAtPath:urlPath];
         BOOL writeable  = [fileManager isWritableFileAtPath:urlPath];
         NSLog(@"read able %d write able %d",readable,writeable);
         
         
         
#if 0
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             
             if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlPath)) {

//
                 UISaveVideoAtPathToSavedPhotosAlbum(urlPath, self, @selector(video:didFinishSavingWithError:contextInfo:),nil);
                 
//                 UISaveVideoAtPathToSavedPhotosAlbum(urlPath, self, @selector(video), nil);
//
//
                 
                 
             }
             
         });
         
         
         
#else
         //文件管理器
         NSFileManager* fm = [NSFileManager defaultManager];
         
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
         [fm copyItemAtURL:[info objectForKey:UIImagePickerControllerMediaURL] toURL:mergeFileURL error:nil];
         AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
         
         //根据AVURLAsset得出视频的时长
         CMTime   time = [asset duration];
         int seconds = ceil(time.value/time.timescale);
         NSString *videoTime = [NSString stringWithFormat:@"%d",seconds];
         

         [self.cameraController dismissViewControllerAnimated:YES completion:^{
            
             exit(0);
         }];
         
         

#endif
     }

    
    NSLog(@"didi finish camera ");
    
}


- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"save Video done for :%@",videoPath);
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL readable =  [fileManager isReadableFileAtPath:videoPath];
    BOOL writeable  = [fileManager isWritableFileAtPath:videoPath];
    NSLog(@"read able %d write able %d",readable,writeable);
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关闭手电筒" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@" 确定点击了");

        exit(0);


    }]];
    

    
    /*
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
        [self.cameraController dismissViewControllerAnimated:NO completion:nil];
        
        NSURL *url = [NSURL fileURLWithPath:videoPath];
        
        
        
        UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
        documentController.delegate = self;
        
        //[documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
        [documentController presentPreviewAnimated:YES];
        
    }]];*/
    
    
    
    // 弹出对话框
    [self.cameraController presentViewController:alert animated:true completion:nil];
    
}

- (IBAction)saveVideoDone:(id)sender{
    
    
    NSLog(@"save Video done ");
    
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return nil;
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}


@end
