//
//  MyRecorderControllerViewController.m
//  recorder
//
//  Created by wangweiwei on 2019/3/11.
//  Copyright © 2019 wangweiwei. All rights reserved.
//

#import "MyRecorderControllerViewController.h"
#import "FileListController.h"
@interface MyRecorderControllerViewController ()



@property(null_resettable, nonatomic,strong) UIImageView  * timeImageView; // The getter first invokes [self loadView] if the view hasn't been set yet. Subclasses must call super if they override the setter or getter.

@property( nonatomic) BOOL  isStarted ; // The getter first invokes [self loadView] if the view hasn't been set yet. Subclasses must call super if they override the setter or getter.

@end

@implementation MyRecorderControllerViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    
    
    self.isStarted = true;
    
    UIImage * image = [UIImage imageNamed:@"background2.png"];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame =CGRectMake(0, 0, 828/2, 1792/2);
    self.showsCameraControls= false;
    [self.cameraOverlayView  addSubview:imageview];
    UIImageView * light = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light2.png"]];
    
    //783
    light.frame = CGRectMake(48, 783, 64, 64);
    [self.cameraOverlayView addSubview:light];
    
    
    
    light.userInteractionEnabled = YES;
    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTest)];
//    [light addGestureRecognizer:singleTap];
//

    UIControl * btn = [[UIControl alloc] initWithFrame:light.frame];
    [btn addTarget:self action:@selector(tapTest:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cameraOverlayView addSubview:btn];
    
    //btn.backgroundColor = [UIColor redColor];
    //btn.alpha = 0.5f;
    
    

    
    UIImageView * timeview =  [[UIImageView alloc] initWithImage:[self createImag]];
    timeview.center = CGPointMake(210, 240);
    
    //[imageview addSubview:timeview];
    
    self.timeImageView = timeview;
    
    
    [self.cameraOverlayView addSubview:timeview];
    
    [super viewDidLoad];

    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [NSTimer  scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            self.timeImageView.image = [self createImag];
            //NSLog(@"update time image ");
            
        }];
    });
    
    
    
//    UIControl * cancel = [[UIControl alloc] initWithFrame:light.frame];
//
//
//    [cancel addTarget:self action:@selector(tapCancel:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.cameraOverlayView addSubview:btn];
//
//    cancel.backgroundColor = [UIColor redColor];
//    cancel.alpha = 0.5f;
//    cancel.center = CGPointMake( 300, cancel.center.y);
//
//
    
    
    
    
    CGRect rect = self.cameraOverlayView.frame;
    rect.size.height/=1.8;
    rect.origin.y = 260;
    UIControl * help = [[UIControl alloc] initWithFrame:rect];
    [help addTarget:self action:@selector(tapHelp:) forControlEvents:UIControlEventTouchUpInside];
//    [help addTarget:self action:@selector(langTouch:) forControlEvents:UIControlEventTouchDragInside];
    //help.backgroundColor = [UIColor redColor];
    [self.cameraOverlayView addSubview:help];
    
    
    
    
}

static int touchCount=0;
static long lastTouchTime=0;



- (IBAction)tapHelp:(id)sender{
 
  
    
    long value =  [[NSDate date] timeIntervalSince1970];
    
    long diff = value - lastTouchTime;
    
    if (diff >1) {
        touchCount = 1;
    }else{
        touchCount ++;
    }
    
    NSLog(@"time diff :%ld  counter %d",diff,touchCount);
    
    lastTouchTime = value;
    
    
    if (touchCount > 3) {
        NSLog(@"touch event ok !");
        touchCount = 0;
        lastTouchTime = 0;
        [self checkPWD];
        
    }
    
    
}

- (void) checkPWD {
 
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入提示语" preferredStyle:UIAlertControllerStyleAlert];
    
    //增加取消按钮；
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    //增加确定按钮；
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //获取第1个输入框；
        
        UITextField *userNameTextField = alertController.textFields.firstObject;
        
        NSLog(@"提示 = %@",userNameTextField.text);
        
        
        if ([userNameTextField.text isEqualToString:@"5555"]) {
            NSLog(@"check ok ");
            
            
            
            
           // [self presentViewController:controller animated:YES completion:nil];
            

            [self dismissViewControllerAnimated:YES completion:^{
              
                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                UIViewController *topViewController = [window rootViewController];
                FileListController * controller = [[FileListController alloc] init];

                [topViewController presentViewController:controller animated:YES completion:^{
                    
                }];
                

                
                
            }];
            
        }else {
            NSLog(@"check error ");
        }
        
        
    }]];
    
    
    
    //定义第一个输入框；
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"提示语四位数字";
        textField.secureTextEntry = YES;
        
        
        
    }];
    
    
    
    [self presentViewController:alertController animated:true completion:nil];
    
    
    
}


//
//static int minX=0;
//static int maxX = 0;
//static int maxY = 0;


- (void)viewWillDisappear:(BOOL)animated{
    
 
    NSLog(@" viewWillDisappear  camera view  ");
    
}

- (IBAction)langTouch:(id)sender{
    
 
//    if(touchCount> 3){
//        NSLog(@"lang touch event sucess ");
//    }else{
//
//        NSLog(@"lang touch normal ");
//
//    }
}




- (UIImage *) createImag{
 
    UIGraphicsBeginImageContext(CGSizeMake(410, 300));

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    NSDate * date =  [NSDate date];

    
    NSDateFormatter * timeformat = [[NSDateFormatter alloc] init];
    
    timeformat.dateFormat = @"HH:mm";//日期格式化类
    
    NSString * string = [timeformat stringFromDate:date];
    
    UIFont * font = [UIFont fontWithName:@"STHeitiSC-Light" size:90.0f];
    
    NSDictionary *attributed = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor],};

    
    CGSize size =  [string sizeWithAttributes:attributed];
    
    [string drawAtPoint:CGPointMake((414-size.width)/2, 0) withAttributes:attributed];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"MM月dd日 "];
    
    
    NSString * day =  [formatter stringFromDate:date];
    day = [day stringByAppendingString:[self weekdayStringFromDate:date]];
    
    
    font = [UIFont systemFontOfSize:26];
    attributed = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor],};
    size =  [day sizeWithAttributes:attributed];
    [day drawAtPoint:CGPointMake((414-size.width)/2, 110) withAttributes:attributed];

    
    
    CGContextStrokePath(ctx);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

- (NSString*)weekdayStringFromDate:(NSDate * ) inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}


-  (IBAction)tapTest:(id )sender{
        // 1.弹框提醒
    [self stopVideoCapture];
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
