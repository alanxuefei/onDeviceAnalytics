//
//  ViewController.m
//  onDeviceAnalytics
//
//  Created by NewUser on 20/10/15.
//  Copyright © 2015 mobile. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>


bool motionbuttonToggled=NO;
bool locationbuttonToggled=NO;
CLLocationManager *locationManager;
CMMotionManager *motionManager;
CLLocationManager *locationManager;

NSString *currentmode=@"NA";

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *StartMovementButton;
@property (strong, nonatomic) IBOutlet UILabel *MotionLabel;
@property (strong, nonatomic) IBOutlet UIButton *LocationButton;
@property (strong, nonatomic) IBOutlet UILabel *LocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastTriggeredtime;

@property (strong, nonatomic) IBOutlet UIButton *walkingButton;
@property (strong, nonatomic) IBOutlet UIButton *MRTButton;
@property (strong, nonatomic) IBOutlet UIButton *TaxiButton;
@property (strong, nonatomic) IBOutlet UIButton *CycleButton;
@property (strong, nonatomic) IBOutlet UIButton *BusButton;
@property (strong, nonatomic) IBOutlet UIButton *NAButton;
@property (strong, nonatomic) IBOutlet UILabel *CurrentMode;

@property (strong, nonatomic) IBOutlet UILabel *CurrentModeLebal;
@end

@implementation ViewController
- (IBAction)walkingButtonClick:(id)sender {
    currentmode=@"Walking";
    self.CurrentModeLebal.text=@"Walking";
    [self clearButtonCollor];
    [sender setBackgroundColor:[UIColor grayColor]];
}

- (IBAction)MRTButtonClick:(id)sender {
    currentmode=@"MRT";
    self.CurrentModeLebal.text=@"MRT";
    [self clearButtonCollor];
    [sender setBackgroundColor:[UIColor grayColor]];
}

- (IBAction)TaxiButton:(id)sender {
    currentmode=@"Taxi";
    self.CurrentModeLebal.text=@"Taxi";
    [self clearButtonCollor];
    [sender setBackgroundColor:[UIColor grayColor]];
}

- (IBAction)CycleButtonClick:(id)sender {
    currentmode=@"Cycle";
    self.CurrentModeLebal.text=@"Cycle";
    [self clearButtonCollor];
    [sender setBackgroundColor:[UIColor grayColor]];
}

- (IBAction)BusButtonClick:(id)sender {
    currentmode=@"Bus";
    self.CurrentModeLebal.text=@"Bus";
    [self clearButtonCollor];
    [sender setBackgroundColor:[UIColor grayColor]];
}

- (IBAction)NAButtonClick:(id)sender {
    
    currentmode=@"NA";
    self.CurrentModeLebal.text=@"NA";
    [self clearButtonCollor];
    [sender setBackgroundColor:[UIColor grayColor]];
    
}

-(void) clearButtonCollor{
    self.walkingButton.backgroundColor= [UIColor whiteColor];
    self.MRTButton.backgroundColor= [UIColor whiteColor];
    self.TaxiButton.backgroundColor= [UIColor whiteColor];
    self.CycleButton.backgroundColor= [UIColor whiteColor];
    self.BusButton.backgroundColor= [UIColor whiteColor];
    self.NAButton.backgroundColor= [UIColor whiteColor];
}


- (IBAction)LocationButtonClick:(id)sender {
    
    if (locationbuttonToggled){
        [sender setTitle:@"Start Location/Light" forState:UIControlStateNormal];
        locationbuttonToggled=NO;
        self.LocationLabel.text=@"Stopped";
        [locationManager stopUpdatingLocation];
        

        
    }
    else{
        [sender setTitle:@"Stop Location/Light" forState:UIControlStateNormal];
        locationbuttonToggled=YES;
        self.LocationLabel.text=@"Started";
        [locationManager startUpdatingLocation];
    }

    
    
}
- (IBAction)StartMovementButtonClick:(id)sender {
    
    
    if (motionbuttonToggled){
        [sender setTitle:@"Start Movement" forState:UIControlStateNormal];
        motionbuttonToggled=NO;
        self.MotionLabel.text=@"Stopped";
        [motionManager stopAccelerometerUpdates];
        [motionManager stopMagnetometerUpdates];

        
    }
    else{
        [sender setTitle:@"Stop Movement" forState:UIControlStateNormal];
         motionbuttonToggled=YES;
        self.MotionLabel.text=@"Started";
        motionManager = [[CMMotionManager alloc] init];
        motionManager.accelerometerUpdateInterval = .2;
        motionManager.gyroUpdateInterval = .2;
        
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                     
                                                    
                                                     NSString *str = [NSString stringWithFormat:@"Ax:%f Ay%f Az%f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z];
 
                                                     [self writeToLogFile:str];
                                                     
                                                     if(error){
                                                         NSLog(@"%@", error);
                                                     }


                                                 }];
        
        [motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMMagnetometerData  *magnetometerData, NSError *error) {
                                                     
                                                    NSString *str = [NSString stringWithFormat:@"Mx:%f My%f Mz%f",magnetometerData.magneticField.x,magnetometerData.magneticField.y,magnetometerData.magneticField.z];
                                                     [self writeToLogFile:str];

                                                     if(error){
                                                         NSLog(@"%@", error);
                                                     }
                                                 }];
        
  
    }
}

-(void) writeToLogFile:(NSString*)content0{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss:SSS"];
    NSString *content = [NSString stringWithFormat:@"%@ %@ %@\n",[dateFormatter stringFromDate:[NSDate date]], currentmode,content0];
            NSLog(@"%@", content);
    //get the documents directory:
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"datalog.txt"];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    if (fileHandle){
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else{
        [content writeToFile:fileName
                  atomically:NO
                    encoding:NSStringEncodingConversionAllowLossy
                       error:nil];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
   // UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
  //  [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];

    
    NSString *str = [NSString stringWithFormat:@"Lat:%f Log%f alt%f speed%@",crnLoc.coordinate.latitude,
                     crnLoc.coordinate.longitude,crnLoc.altitude,crnLoc.speed];
     [self writeToLogFile:str];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss:SSS"];
    NSString *content = [NSString stringWithFormat:@"%@\n",[dateFormatter stringFromDate:[NSDate date]]];
    self.lastTriggeredtime.text=content;
    NSLog(@"%@", content);

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = .2;
    motionManager.gyroUpdateInterval = .2;
    
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.allowsBackgroundLocationUpdates=YES;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // setting the accuracy
   // locationManager.distanceFilter = 1;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
