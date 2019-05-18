//
//  FileListController.m
//  recorder
//
//  Created by wangweiwei on 2019/3/29.
//  Copyright © 2019 wangweiwei. All rights reserved.
//

#import "FileListController.h"
#import "FileTableViewCell.h"
#import "FileTableViewCell.h"
#import <AVFoundation/AVFoundation.h>


@interface FileListController ()

@end

@implementation FileListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self.tableView registerClass:[FileTableViewCell class] forCellReuseIdentifier:@"fileview"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"FileTableViewCell" bundle:nil] forCellReuseIdentifier:@"fileview"];
    
    
}

- (NSArray*) videoArray{
 
    NSArray * array = nil;
    
    NSArray *docPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];

    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray  * tempArray =  [fm contentsOfDirectoryAtPath:documentsPath error:nil];
    
    for (NSString * path in tempArray) {
        NSLog(@"file list :%@",path);
    }
    
    array =  [tempArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    return array;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self videoArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileview"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"fileview"];
    }
    
    NSArray * array  = [self videoArray];
    
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    
    
    NSString * path = [array objectAtIndex:indexPath.row];
    
    NSString * title = path;
    cell.textLabel.text = title;

    
    NSArray *docPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    
    path = [documentsPath stringByAppendingPathComponent:path];
    
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);

    if(seconds > 60){
        NSString * detail = [NSString stringWithFormat:@"长度：%d分%d秒",seconds/60,seconds%60];
        cell.detailTextLabel.text = detail;
        
        

    }else{
        NSString * detail = [NSString stringWithFormat:@"长度：%d秒",seconds%60];
        cell.detailTextLabel.text = detail;

    }
    
    
    NSFileManager* manager = [NSFileManager defaultManager];
    long size =[[manager attributesOfItemAtPath:path error:nil] fileSize];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %dM",cell.detailTextLabel.text,(size/1024/1024)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 60;
}


- (int ) currentSelect{
    NSIndexPath * path =  self.tableView.indexPathForSelectedRow ;

    if (path == nil) {
        return -1;
    }else{
        return path.row;
    }
}

- (IBAction)deleteEvent:(id)sender{
 
    NSLog(@" delete event : %d",[self currentSelect]);
    
    if ([self currentSelect] >=0) {
        
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@" 确定点击了");
            
            NSString * path = [[self videoArray] objectAtIndex:[self currentSelect]];
            
            NSArray *docPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsPath = [docPath objectAtIndex:0];
            
            path = [documentsPath stringByAppendingPathComponent:path];
            
            NSFileManager * fm = [NSFileManager defaultManager];
            
            [fm removeItemAtPath:path error:nil];
            
            [self.tableView reloadData];
            
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        
        // 弹出对话框
        [self presentViewController:alert animated:true completion:nil];
        
        
        
    }
    
}

- (IBAction)shareEvent :(id)sender{
    if ([self currentSelect] >=0) {
        
        NSString * path = [[self videoArray] objectAtIndex:[self currentSelect]];
        
        NSArray *docPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        
        path = [documentsPath stringByAppendingPathComponent:path];
        [self.tableView reloadData];
        
        
        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:),nil);

        
        
        NSLog(@"share ok ");
    }
    NSLog(@"share event");
    
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
   
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存到相册成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@" 确定点击了");
    }]];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 
    UIView * view =[[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    UIView * custom  = [[UIView alloc] init];
    
    UIImage * shareImage = [UIImage imageNamed:@"share.jpg"];

    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:shareImage forState:UIControlStateNormal];
    CGSize size = shareImage.size;
    shareButton.frame = CGRectMake(0, 0,size.width,size.height);
    shareButton.center = CGPointMake(260, 30);
    
    
    UIButton * delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * delImage = [UIImage imageNamed:@"delete.png"];

    [delButton setImage:delImage forState:UIControlStateNormal];

    size = delImage.size;
    
    delButton.frame = CGRectMake(0, 0,size.width,size.height);
    delButton.center = CGPointMake(180, 30);
    
    
    UIButton * exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * exitImage = [UIImage imageNamed:@"exit.jpg"];
    
    [exitButton setImage:exitImage forState:UIControlStateNormal];
    
    size = exitImage.size;
    
    exitButton.frame = CGRectMake(0, 0,size.width,size.height);
    exitButton.center = CGPointMake(350, 30);
    

    

    [custom addSubview:exitButton];
    [custom addSubview:shareButton];
    [custom addSubview:delButton];

    
    [shareButton addTarget:self action:@selector(shareEvent:) forControlEvents:UIControlEventTouchUpInside];
    [delButton addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
    [exitButton addTarget:self action:@selector(exitEvent:) forControlEvents:UIControlEventTouchUpInside];
    
     
    return custom;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    return 70;
}

- (IBAction)exitEvent :(id)sender{
 
    exit(0);
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
