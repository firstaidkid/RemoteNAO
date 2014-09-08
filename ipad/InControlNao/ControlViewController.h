//
//  ControlViewController.h
//  InControlNao
//
//  Created by Chris on 10.01.13.
//  Copyright (c) 2013 hdmstuttgart.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSocketController.h"

@interface ControlViewController : UIViewController {
    NSMutableData *receivedData;
    NSString *tfIP;
    NSString *tfPort;
    NSString *baseURL;
    Boolean checkForRunningBehaviors;
    NSMutableArray *runningBehaviors;
    NSURLConnection *theConnection;
    NSObject *myVideoSocketController;
}
@property (retain, nonatomic) NSString *urlString;
@property (retain, nonatomic) NSString *ipSpeicher;
@property (retain, nonatomic) NSString *portSpeicher;
@property (retain, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) IBOutlet UIImageView *videoView;
@property (weak, nonatomic) IBOutlet UITextField *speakTextField;
@property (weak, nonatomic) UIPopoverController *popoverController;
@property (weak, nonatomic) IBOutlet UIButton *btnWalkLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnWalkRight;
@property (weak, nonatomic) IBOutlet UIButton *btnWalkForwards;
@property (weak, nonatomic) IBOutlet UIButton *btnWalkBackwards;
@property (weak, nonatomic) IBOutlet UIButton *btnHeadLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnHeadUp;
@property (weak, nonatomic) IBOutlet UIButton *btnHeadRight;
@property (weak, nonatomic) IBOutlet UIButton *btnHeadDown;

- (void)dismissPopover;
- (void)updateImageViewWith:(UIImage*) cgImage;
- (void)pressedButton:(NSString*)methode:(NSString*)parameter;

- (IBAction)behaviourButton:(id)sender;
- (IBAction)speakButton:(id)sender;

- (IBAction)walkForwButton:(id)sender;
- (IBAction)walkLeftButton:(id)sender;
- (IBAction)walkBackButton:(id)sender;
- (IBAction)walkRightButton:(id)sender;

- (IBAction)stopWalkForwButton:(id)sender;
- (IBAction)stopWalkLeftButton:(id)sender;
- (IBAction)stopWalkBackButton:(id)sender;
- (IBAction)stopWalkRightButton:(id)sender;

- (IBAction)lookUpButton:(id)sender;
- (IBAction)lookLeftButton:(id)sender;
- (IBAction)lookDownButton:(id)sender;
- (IBAction)lookRightButton:(id)sender;

- (IBAction)stopLookUpButton:(id)sender;
- (IBAction)stopLookLeftButton:(id)sender;
- (IBAction)stopLookDownButton:(id)sender;
- (IBAction)stopLookRightButton:(id)sender;

- (IBAction)backButton:(id)sender;
@end
