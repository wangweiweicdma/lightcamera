//
//  FileTableViewCell.h
//  recorder
//
//  Created by wangweiwei on 2019/3/29.
//  Copyright © 2019 wangweiwei. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface FileTableViewCell : UITableViewCell



@property(null_resettable, nonatomic,strong) IBOutlet UIButton  * btnDelete; // The getter first invokes [self loadView] if the view hasn't been set yet. Subclasses must call super if they override the setter or getter.


@property(null_resettable, nonatomic,strong) IBOutlet UIButton  * btnShare; // The getter first invokes [self loadView] if the view hasn't been set yet. Subclasses must call super if they override the setter or getter.

@end

NS_ASSUME_NONNULL_END
