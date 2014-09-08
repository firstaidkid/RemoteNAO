//
//  BonjourViewController.m
//  InControlNao
//
//  Created by Chris on 10.01.13.
//  Copyright (c) 2013 hdmstuttgart.de. All rights reserved.
//

#import "BonjourViewController.h"

#define kProgressIndicatorSize 20.0

// A category on NSNetService that's used to sort NSNetService objects by their name.
@interface NSNetService (BrowserViewControllerAdditions)
- (NSComparisonResult) localizedCaseInsensitiveCompareByName:(NSNetService*)aService;
@end

@implementation NSNetService (BrowserViewControllerAdditions)
- (NSComparisonResult) localizedCaseInsensitiveCompareByName:(NSNetService*)aService {
	return [[self name] localizedCaseInsensitiveCompare:[aService name]];
}
@end


@interface BonjourViewController ()

@end

@implementation BonjourViewController

@synthesize servicesTableView;
@synthesize servicesList;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
