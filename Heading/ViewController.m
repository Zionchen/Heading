//
//  ViewController.m
//  Heading
//
//  Created by Chen on 15/3/13.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>
@property (nonatomic , strong) CLLocationManager *locationManager;
@property (nonatomic , strong) NSOperationQueue *queue;
@property (nonatomic , strong) CALayer *naviIcon;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([CLLocationManager headingAvailable]) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingHeading];
    }
    else{
        [self.headingLabel setText:@"此设备没有磁力计"];
    }
    
    self.naviIcon = [[CALayer alloc] init];
    self.naviIcon.frame = CGRectMake(170,230,30,30);
    self.naviIcon.contents = (id)[[UIImage imageNamed:@"location.png"] CGImage];
    [self.view.layer addSublayer:self.naviIcon];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    CGFloat headings = M_PI*newHeading.trueHeading/180.0f;
    //CGFloat headings = newHeading.trueHeading;
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D fromValue = self.naviIcon.transform;
    anim.fromValue = [NSValue valueWithCATransform3D:fromValue];
    
    CATransform3D toValue = CATransform3DMakeRotation(headings, 0, 0, 1);
    anim.toValue = [NSValue valueWithCATransform3D:toValue];
    anim.duration = 0.2;
    anim.removedOnCompletion = YES;
    self.naviIcon.transform = toValue;
    [self.naviIcon addAnimation:anim forKey:nil];
    
    [self.headingLabel setText:[NSString stringWithFormat:@"与北方的方向:\n%f", newHeading.trueHeading]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
