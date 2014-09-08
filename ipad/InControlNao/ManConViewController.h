//
//  ManConViewController.h
//  InControlNao
//
//  Created by Chris on 10.01.13.
//  Copyright (c) 2013 hdmstuttgart.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"

@interface ManConViewController : UIViewController {
    GCDAsyncSocket *socket;
}
@property (copy, nonatomic) NSUserDefaults *defaults;

@property (copy, nonatomic) NSString *ipAdr;
@property (copy, nonatomic) NSString *port;

@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UIToolbar *accessoryView;

- (IBAction)connectButton:(id)sender;
- (IBAction)backButton:(id)sender;
@end
