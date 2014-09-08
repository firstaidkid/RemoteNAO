//
//  BonjourViewController.h
//  InControlNao
//
//  Created by Chris on 10.01.13.
//  Copyright (c) 2013 hdmstuttgart.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/NSNetServices.h>


/**
 * NOTE:
 * currently not in use.
 * ToDo: implement Bonjour Service to find NAO Robots in the network.
 */

@class BonjourViewController;

@protocol BonjourViewControllerDelegate <NSObject>
@required
- (void)bonjourViewController:(BonjourViewController *)bvc didResolveInstance:(NSNetService *)ref;
@end


@interface BonjourViewController : UIViewController <NSNetServiceBrowserDelegate, NSNetServiceDelegate, UITableViewDataSource, UITableViewDelegate> {
@private
    id<BonjourViewControllerDelegate> _delegate;
    NSString* _searchingForServicesString;
	BOOL _showDisclosureIndicators;
	NSNetServiceBrowser* _netServiceBrowser;
	NSNetService* _currentResolve;
	NSTimer* _timer;
	BOOL _needsActivityIndicator;
	BOOL _initialWaitOver;
}
//@property (nonatomic, assign) id<BonjourViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString* searchingForServicesString;
@property (nonatomic, strong) NSMutableArray* servicesList;
@property (nonatomic, strong) IBOutlet UITableView *servicesTableView;

- (BOOL)searchForServicesOfType:(NSString *)type inDomain:(NSString *)domain;

@end
