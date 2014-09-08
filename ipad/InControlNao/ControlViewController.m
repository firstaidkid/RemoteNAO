//
//  ControlViewController.m
//  InControlNao
//
//  Created by Chris on 10.01.13.
//  Copyright (c) 2013 hdmstuttgart.de. All rights reserved.
//

#import "ControlViewController.h"
#import "GCDAsyncSocket.h"
#import "BehaviourViewController.h"

@interface ControlViewController ()
{
    GCDAsyncSocket *socket;
    long TAG_COMMAND;
}

@end

@implementation ControlViewController

@synthesize urlString;
@synthesize videoView;
@synthesize popoverController;
@synthesize defaults;


- (void)initVariables {
    defaults = [NSUserDefaults standardUserDefaults];
    _ipSpeicher = [defaults objectForKey:@"ipAdress"];
    _portSpeicher = [defaults objectForKey:@"port"];
    
    urlString = [NSString  stringWithFormat:@"http://%@:%@/",_ipSpeicher,_portSpeicher];
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    TAG_COMMAND = 1;
    
    // add active-states
    [_btnWalkBackwards setImage:[UIImage imageNamed:@"ArrowDown_active.png"] forState:UIControlEventTouchDown];
    [_btnWalkForwards setImage:[UIImage imageNamed:@"ArrowUp_active.png"] forState:UIControlEventTouchDown];
    [_btnWalkLeft setImage:[UIImage imageNamed:@"ArrowLeft_active.png"] forState:UIControlEventTouchDown];
    [_btnWalkRight setImage:[UIImage imageNamed:@"ArrowRight_active.png"] forState:UIControlEventTouchDown];
    [_btnHeadDown setImage:[UIImage imageNamed:@"TurnDown_active.png"] forState:UIControlEventTouchDown];
    [_btnHeadUp setImage:[UIImage imageNamed:@"TurnUp_active.png"] forState:UIControlEventTouchDown];
    [_btnHeadLeft setImage:[UIImage imageNamed:@"TurnLeft_active.png"] forState:UIControlEventTouchDown];
    [_btnHeadRight setImage:[UIImage imageNamed:@"TurnRight_active.png"] forState:UIControlEventTouchDown];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    // To dismiss the keyboard with touching outside textfield
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [super viewDidLoad];
    
    [self initVariables];
    
    // Create Instance of VideoSocketController and start it in new Thread.
    myVideoSocketController = [[VideoSocketController alloc] initWithWidth:320 withHeight:240 withIP:_ipSpeicher withPort:@"8080" withDelegate:self];
    [myVideoSocketController performSelectorInBackground:@selector(connect) withObject:nil];
    
    baseURL = [NSString stringWithFormat:@"http://%@:9559/?eval=ALBehaviorManager.getInstalledBehaviors()",_ipSpeicher];
    [self sendRequest:baseURL];
}

- (void)updateImageViewWith:(UIImage*) image {
    videoView.image = image;
}

- (void)dismissKeyboard
{
    [_speakTextField resignFirstResponder];
}


- (IBAction)behaviourButton:(id)sender
{
    // just for fun
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Socket Handling
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/** Sends a new command to the NAO socket-server.
 @param command String value which describes the action to be perfomed (motion, say, relax)
 @param param String value which further differentiates the command (walkForwards, ...)
 */
- (void)sendCommandToNao:(NSString*)command withParameter:(NSString*)param {
    NSError *err = nil;
    if (![socket connectToHost:_ipSpeicher onPort:[_portSpeicher integerValue] error:&err]) // Asynchronous!
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        NSLog(@"I goofed while sending a command");
        [self sendCommandToNao:command withParameter:param];
    }
    
    // send a command to the NAO Server with a concatenated string command:param
    [socket
     writeData:[[NSString stringWithFormat:@"%@:%@",command, param] dataUsingEncoding:NSUTF8StringEncoding]
     withTimeout:-1
     tag:TAG_COMMAND];
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    if(sender == socket) {
        //NSLog(@"Cool, I'm connected to %@! That was easy.", host);
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (tag == TAG_COMMAND) {
        // NSLog(@"Command request sent");
        [socket disconnect];
    }
    else {
        // NSLog(@"Some other request sent");
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Button Actions
#pragma mark -
///////////////////////////////////////////////////////////////////////////

//Reden
- (IBAction)speakButton:(id)sender {
    [self sendCommandToNao:@"say" withParameter:_speakTextField.text];
}
//Laufbewegung
- (IBAction)walkForwButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"walkForwards"];
}

- (IBAction)walkLeftButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"turnLeft"];
}

- (IBAction)walkBackButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"walkBackwards"];
}

- (IBAction)walkRightButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"turnRight"];
}
//Endebefehl Laufbewegung
- (IBAction)stopWalkForwButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"stopWalkForwards"];
}

- (IBAction)stopWalkLeftButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"stopTurnLeft"];
}

- (IBAction)stopWalkBackButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"stopWalkBackwards"];
}

- (IBAction)stopWalkRightButton:(id)sender{
    [self sendCommandToNao:@"motion" withParameter:@"stopTurnRight"];
}
//Kopfbewegung
- (IBAction)lookUpButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"turnHeadUp"];
}

- (IBAction)lookLeftButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"turnHeadLeft"];
}

- (IBAction)lookDownButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"turnHeadDown"];
}

- (IBAction)lookRightButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"turnHeadRight"];
}
//Endebefehl Kopfbewegung
- (IBAction)stopLookUpButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"stopTurnHeadUp"];
    
}

- (IBAction)stopLookLeftButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"stopTurnHeadLeft"];
    
}

- (IBAction)stopLookDownButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"stopTurnHeadDown"];
    
}

- (IBAction)stopLookRightButton:(id)sender {
    [self sendCommandToNao:@"motion" withParameter:@"stopTurnHeadRight"];
    
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Segue Handling
#pragma mark -
///////////////////////////////////////////////////////////////////////////

//Methoden um Popover zu dismissen
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];

}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"behavePopover"]) {
        if (popoverController) {
            [popoverController dismissPopoverAnimated:YES];
            return NO;
        }
    }
    return YES;
}


- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [popoverController dismissPopoverAnimated:YES];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Behavior Fetching
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (void)sendRequest:(NSString *)urlString {
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:-1];
    
    theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData data];
    } else {
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    /* Needed to  */
    if(connection != theConnection) {
        return;
    }
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    unsigned char byteBuffer[[receivedData length]];
    [receivedData getBytes:byteBuffer];
    NSLog(@"Output: %s", (char *)byteBuffer);
    
    NSString *b = [NSString stringWithFormat:@"%s",byteBuffer];
    [self setBehaviors:b];
    
    [defaults setObject:runningBehaviors forKey:@"runningBehaviors"];
    
//    connection = nil;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)setBehaviors:(NSString *)behave
{
    runningBehaviors = [[NSMutableArray alloc] init];
    
    NSRange range;
    bool inString = false;
    for (int i=0;i<behave.length;i++)
    {
        if ([behave characterAtIndex:i] == '"')
        {
            inString = !inString;
            if (!inString)
            {
                range.length = i - range.location;
                [runningBehaviors addObject:[behave substringWithRange:range]];
            }
            else
            {
                range.location = i+1;
            }
        }
    }
}




@end