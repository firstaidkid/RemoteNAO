//
//  BehaviourViewController.h
//  InControlNao
//
//  Created by Chris on 10.01.13.
//  Copyright (c) 2013 hdmstuttgart.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlViewController.h"

/** Popover to perform behaviors installed on the NAO Robot.
 */
@interface BehaviourViewController : ControlViewController <UITableViewDelegate, UITableViewDataSource> {
    NSString* string;
    NSUserDefaults *defaults;
}
@property NSArray *dataSource;
@property UITableView *tableView;

- (void)setupArray;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end