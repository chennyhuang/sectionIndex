//
//  ViewController.m
//  sectionindex
//
//  Created by huangzhenyu on 15/8/7.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "ViewController.h"
#import "HZCityViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>
- (IBAction)cityClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (nonatomic,strong) NSString *cityName;//定位到的城市名

@property (strong, nonatomic) CLLocationManager* locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityName = @"全国";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getcityName:) name:@"getCityNameNotification" object:nil];//nil表示接受所有发送者的事件
    [self getAuthorization];//获取授权
    [self.locationManager startUpdatingLocation];//开始定位
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getCityNameNotification" object:nil];
}

- (void)getcityName:(NSNotification *)note{
    NSString *cityStr = [[note object] objectForKey:@"cityName"];
    NSLog(@"%@",cityStr);
    [self.cityButton setTitle:cityStr forState:UIControlStateNormal];
}

- (IBAction)cityClick:(UIButton *)sender {
    HZCityViewController *vc = [[HZCityViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    vc.cityName = self.cityName;
    vc.dismissWithCityBlock = ^(NSString *cityName){
        [sender setTitle:cityName forState:UIControlStateNormal];
    };
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark 定位相关
- (void)getAuthorization
{
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                break;
                
            case kCLAuthorizationStatusNotDetermined:
                [self.locationManager requestWhenInUseAuthorization];
                break;
            case kCLAuthorizationStatusDenied:
                [self alertOpenLocationSwitch];
                break;
            default:
                break;
        }
    }
}
- (void)alertOpenLocationSwitch
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在隐私设置中打开定位开关" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//定位精确度
        _locationManager.distanceFilter = 10;//10米定位一次
    }
    return _locationManager;
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [_locationManager stopUpdatingLocation];
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * place in placemarks) {
            NSLog(@"name,%@",place.name);                       // 位置名
            NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
            NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
            NSLog(@"locality,%@",place.locality);               // 市
            NSLog(@"subLocality,%@",place.subLocality);         // 区
            NSLog(@"country,%@",place.country);                 // 国家
            self.cityName = place.locality;
            NSDictionary *info = [NSDictionary dictionaryWithObject:place.locality forKey:@"cityName"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getCityNameNotification" object:info];
            
        }
    }];
}
@end
