//
//  HZCityViewController.h
//  sectionindex
//
//  Created by huangzhenyu on 15/8/7.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZCityViewController : UIViewController
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) void(^dismissWithCityBlock)(NSString *cityName);
@end
