//
//  XLocationManager.m
//  LEVE
//
//  Created by canoe on 2018/1/5.
//  Copyright © 2018年 canoe. All rights reserved.
//

#import "XLocationManager.h"
#import "XAuthorityTool.h"

@interface XLocationManager ()<CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *manager;
@property(nonatomic, strong) NSMutableArray *successBlockArray;
@property(nonatomic, strong) NSMutableArray *failedBlockArray;
@property(nonatomic, strong) NSMutableArray *addressBlockArray;
@property(nonatomic, strong) NSMutableArray *cityBlockArray;

@end

@implementation XLocationManager

-(NSMutableArray *)successBlockArray
{
    if (!_successBlockArray) {
        _successBlockArray = [NSMutableArray array];
    }
    return _successBlockArray;
}

-(NSMutableArray *)failedBlockArray
{
    if (!_failedBlockArray) {
        _failedBlockArray = [NSMutableArray array];
    }
    return _failedBlockArray;
}

-(NSMutableArray *)addressBlockArray
{
    if (!_addressBlockArray) {
        _addressBlockArray = [NSMutableArray array];
    }
    return _addressBlockArray;
}

-(NSMutableArray *)cityBlockArray
{
    if (!_cityBlockArray) {
        _cityBlockArray = [NSMutableArray array];
    }
    return _cityBlockArray;
}

-(CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        //控制定位精度,越高耗电量越
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        // 1. 适配 动态适配
        if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_manager requestWhenInUseAuthorization];
            [_manager requestAlwaysAuthorization];
        }
        // 2. 另外一种适配 systemVersion 有可能是 8.1.1
        float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (osVersion >= 8) {
            [_manager requestWhenInUseAuthorization];
            [_manager requestAlwaysAuthorization];
        }
    }
    return _manager;
}

+ (XLocationManager *) shareManager {
    static XLocationManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[XLocationManager alloc] init];
    });
    return shared;
}

-(void)startLocation
{
    if([XAuthorityTool locationServicesEnabled] && [XAuthorityTool hasLocationAuthor] != XAuthorityStateFailed)
    {
        [self.manager startUpdatingLocation];
    }else
    {
        [XAuthorityTool showRequestAuthorViewWithMassage:@"是否前去开启定位服务?"];
    }
}

-(void)stop
{
    [self.successBlockArray removeAllObjects];
    [self.addressBlockArray removeAllObjects];
    [self.cityBlockArray removeAllObjects];
    [self.failedBlockArray removeAllObjects];
    
    [self.manager stopUpdatingLocation];
}

- (void)getLocationWithSuccess:(LocationSuccess)success failure:(LocationFailed)failure
{
    [self.successBlockArray addObject:success];
    [self.failedBlockArray addObject:failure];
    [self startLocation];
}

-(void)getAddressWithSuccess:(GetAddressSuccess)success failure:(LocationFailed)failure
{
    [self.addressBlockArray addObject:success];
    [self.failedBlockArray addObject:failure];
    [self startLocation];
}

-(void)getCityWithSuccess:(GetCitySuccess)success failure:(LocationFailed)failure
{
    [self.cityBlockArray addObject:success];
    [self.failedBlockArray addObject:failure];
    [self startLocation];
}

#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = [locations lastObject];
    CLLocationCoordinate2D l = loc.coordinate;
    double lat = l.latitude;
    double lnt = l.longitude;
    for (LocationSuccess successBlock in self.successBlockArray) {
        successBlock ? successBlock(lat, lnt) : nil;
    }
    
    CLGeocoder *geocoder= [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks,NSError *error)
     {
         if (placemarks.count > 0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString * lastCity = [NSString stringWithFormat:@"%@%@",placemark.administrativeArea,placemark.locality];
             
             NSString * lastAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@",placemark.country,placemark.administrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare];//详细地址
             for (GetAddressSuccess addressBlock in self.addressBlockArray) {
                 addressBlock ? addressBlock(lastAddress) : nil;
             }
             for (GetCitySuccess cityBlock in self.cityBlockArray) {
                 cityBlock ? cityBlock(lastCity) : nil;
             }
         }
     }];
    
    if (self.stopAfterUpdates == YES) {
        [self stop];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    for (LocationFailed failedBlock in self.cityBlockArray) {
        failedBlock ? failedBlock(error) : nil;
    }
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

@end
