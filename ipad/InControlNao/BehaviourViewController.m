//
//  BehaviourViewController.m
//  InControlNao
//
//  Created by Chris on 10.01.13.
//  Copyright (c) 2013 hdmstuttgart.de. All rights reserved.
//

#import "BehaviourViewController.h"
#import "ControlViewController.h"


@interface BehaviourViewController ()

@end

@implementation BehaviourViewController {
    NSString *_ipSpeicher;
    NSString *_portSpeicher;
    NSURLConnection *theConnection;
}

@synthesize dataSource;
@synthesize defaults;

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Lifecycle
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
    	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    defaults = [NSUserDefaults standardUserDefaults];
    _ipSpeicher = [defaults objectForKey:@"ipAdress"];
    _portSpeicher = [defaults objectForKey:@"port"];
    runningBehaviors = [defaults objectForKey:@"runningBehaviors"];
    baseURL = [[NSString alloc] initWithFormat:@"http://%@:9559",_ipSpeicher];
    
    NSLog(@"VIEW DID APPEAR");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    /* Because we have to connections -> check if the response came from the real one */
    if(connection != theConnection) {
        return;
    }
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Behavior Sending
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (void)sendRequest:(NSString *)urlString {
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TableView Handling
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [runningBehaviors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *tableCellIdentifier = @"Cell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
	}
	cell.textLabel.text = [runningBehaviors objectAtIndex:[indexPath row]];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sb = [runningBehaviors objectAtIndex:[indexPath row]];
	
	NSString* urlString = [[NSString alloc] initWithFormat:@"%@?eval=ALBehaviorManager.runBehavior(%%22%@\%%22)",
                        baseURL?baseURL:@"",
                        sb?sb:@""];
    
    [self sendRequest:urlString];

}

@end
