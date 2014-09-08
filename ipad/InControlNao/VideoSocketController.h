//
//  VideoSocketController.h
//  InControlNao
//
//  Created by Axel Perschmann on 17.01.13.
//  Copyright (c) 2013 hdmstuttgart.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "ControlViewController.h"

@interface VideoSocketController : NSObject {
    NSString *tfIP;
    NSString *tfPort;
    NSString *urlString;
    NSString *ipSpeicher;
    NSString *portSpeicher;
    
    int _width;
    int _height;
    NSThread *getPicThread;
    
    GCDAsyncSocket *socket;
    long TAG_HEADER;
    long TAG_MESSAGE;
}

@property (nonatomic, readonly) id myDelegate;

- (id) initWithWidth:(int)width withHeight:(int)height withIP:(NSString*)ip withPort:(NSString*)port withDelegate:(id)theDelegate;
- (void) connect;

@end