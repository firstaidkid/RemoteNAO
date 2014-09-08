//
//  ManConViewController.m
//  InControlNao
//
//  Created by Chris on 10.01.13.
//  Copyright (c) 2013 hdmstuttgart.de. All rights reserved.
//

#import "ManConViewController.h"

@interface ManConViewController ()

@end

@implementation ManConViewController

@synthesize defaults;
@synthesize ipAdr;
@synthesize port;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.ipTextField.text = @"192.168.0.102";
    self.portTextField.text = @"12345";
    
    self.ipTextField.inputAccessoryView = self.accessoryView;
    [self.ipTextField becomeFirstResponder];
    //dismiss Keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // get socket
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dismissKeyboard
{
    //Methode für Keyboard dismiss bei Touch ausserhalb eines Textfeldes
    //[_ipTextField resignFirstResponder];
    //[_portTextField resignFirstResponder];
}

- (IBAction)connectButton:(id)sender
{
    if([self shouldPerformSegueWithIdentifier:@"manToCon" sender:sender]) {
        [self performSegueWithIdentifier:@"manToCon" sender:sender];
    }
}

- (IBAction)backButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // Checking if the input-string are valid, and then storing them in the NSUserDefaults
    
    // IP address RegEx
    NSString *ipFilterString = @"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";
    // Ports RegEx
    NSString *portFilterString = @"[0-9]{2,5}";
    
    // assign to Predicates
    NSPredicate *ipCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ipFilterString];
    NSPredicate *portCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", portFilterString];

    // are we within the manToCon-Segue?
    if ([identifier isEqualToString:@"manToCon"]) {
        
        // check IP address and Port
        if (([ipCheck evaluateWithObject:_ipTextField.text] == NO) && ([portCheck evaluateWithObject:_portTextField.text] == NO)) {
            
            // if we have invalid input -> send an alerd and stop the segue
            UIAlertView *conErr = [[UIAlertView alloc]
                                   initWithTitle:@"Ungültige Eingabe"
                                   message:@"Eingegebene IP-Adresse und Port sind ungültig"
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
            [conErr show];
            return NO;
        }
        
        // check IP address individually
        if ([ipCheck evaluateWithObject:_ipTextField.text] == NO) {
            
            // if we have invalid input -> send an alerd and stop the segue
            UIAlertView *conErr = [[UIAlertView alloc]
                                         initWithTitle:@"Ungültige IP"
                                         message:@"Die eingegebene IP-Adresse ist nicht gültig"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            [conErr show];
            return NO;
        }
        
        // check port
        else if ([portCheck evaluateWithObject:_portTextField.text] == NO) {
            UIAlertView *conErr = [[UIAlertView alloc]
                                    initWithTitle:@"Ungültiger Port"
                                    message:@"Die eingegebene Portnummer ist nicht gültig"
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
            [conErr show];
            return NO;

        }
    }
    
    // check for connection
    if (![self checkConnectionWithIP:_ipTextField.text]) {
        UIAlertView *conErr = [[UIAlertView alloc]
                               initWithTitle:@"Verbindungstest fehlgeschlagen"
                               message:@"Bitte kontrollieren Sie die eingegebene IP."
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
        [conErr show];
        return NO;
    }
    
    // set local variables
    ipAdr = self.ipTextField.text;
    port = self.portTextField.text;
    
    // define NSUserDefaults
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:ipAdr forKey:@"ipAdress"];
    [defaults setObject:port forKey:@"port"];
    
    // submit changes
    [defaults synchronize];
    
    // allow segue
    return YES;
}

- (Boolean)checkConnectionWithIP:(NSString*)ipString {
    NSError *err = nil;
    if (![socket connectToHost:ipString onPort:8080 error:&err]) // Asynchronous!
    {
        return YES;
    }
    else {
        return NO;
    }
}


@end
