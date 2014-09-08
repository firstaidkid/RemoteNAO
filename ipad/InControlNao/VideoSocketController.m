//
//  VideoSocketController.m
//  InControlNao
//
//  Created by Axel Perschmann on 17.01.13.
//  Copyright (c) 2013 hdmstuttgart.de. All rights reserved.
//

#import "VideoSocketController.h"
#import "ControlViewController.h"


@implementation VideoSocketController

@synthesize myDelegate;

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Livecycle
#pragma mark -
///////////////////////////////////////////////////////////////////////////


- (id) initWithWidth:(int)width withHeight:(int)height withIP:(NSString*)ip withPort:(NSString*)port withDelegate:(id)theDelegate {
    // define image-size
    _width = width;
    _height = height;
    
    // define TAGS
    TAG_HEADER = 0;
    TAG_MESSAGE = 1;
    
    // ToDo: Hardcoded Port !
    ipSpeicher = ip;
    portSpeicher = port;
    tfPort = @"8080";
    urlString = [NSString  stringWithFormat:@"http://%@:%@/",ipSpeicher,portSpeicher];
    
    myDelegate = (ControlViewController*) theDelegate;
    
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    return self;
    
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Socket Connection
#pragma mark -
///////////////////////////////////////////////////////////////////////////


-(void)connect
{
    //    NSLog(@"Trying to connect to %@", ipSpeicher);
    
    NSError *err = nil;
    if (![socket connectToHost:ipSpeicher onPort:[tfPort intValue] error:&err]) // Asynchronous!
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        //NSLog(@"I goofed");
        //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(connect:) userInfo:nil repeats:NO];
        [self connect];
    }
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    //    NSLog(@"Cool, I'm connected to %@! That was easy.", host);
    
    [socket readDataToLength:4 withTimeout:-1 tag:TAG_HEADER];
}

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    
    if (tag == TAG_HEADER)
    {
        // get the size of the image
        int messageLength = [self parseHeader:data];
        
        // get the image
        [socket readDataToLength:messageLength withTimeout:-1 tag:TAG_MESSAGE];
    }
    else if (tag == TAG_MESSAGE)
    {
        //        NSLog(@"Did receive data, processing now.");
        [self processMessage:data];
        
        // after image was set, get the next one
        
        [self connect];
    }
    
    // free the mutablearray - data
    data = nil;
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Data Processing
#pragma mark -
///////////////////////////////////////////////////////////////////////////


-(NSUInteger) parseHeader:(NSData*)data
{
    void *bytes = [data bytes];
    uint32_t *intBytes = (NSInteger*)bytes;
    uint32_t swapped = CFSwapInt32BigToHost(*intBytes);
    
    // free memory
    bytes = nil;
    intBytes = nil;
    
    // return size
    return (unsigned) swapped;
}

-(void)processMessage:(NSData*)data
{
    // create image-buffer
    char* rgba = (char*)malloc(_width*_height*4);
    
    // push data-bytes into buffer
    unsigned char* pixelBytes = (unsigned char *)[data bytes];
    
    // add Alpha-Value to buffer
    for(int i=0; i < _width*_height; ++i) {
        rgba[4*i] = pixelBytes[3*i];
        rgba[4*i+1] = pixelBytes[3*i+1];
        rgba[4*i+2] = pixelBytes[3*i+2];
        rgba[4*i+3] = 0;
    }
    
    // define CGContextReference to create an image from raw-data
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       rgba,
                                                       _width,
                                                       _height,
                                                       8, // bitsPerComponent
                                                       4*_width, // bytesPerRow
                                                       colorSpace,
                                                       kCGImageAlphaNoneSkipLast);
    
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    
    //    NSLog(@"Image ready");
    [myDelegate updateImageViewWith:[[UIImage alloc] initWithCGImage:cgImage]];
    
    // free memory
    CFRelease(cgImage);
    CFRelease(bitmapContext);
    CFRelease(colorSpace);
    free(rgba);
}



@end
