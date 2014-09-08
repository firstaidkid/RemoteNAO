//  
//  GCDAsyncUdpSocket
//  
//  This class is in the public domain.
//  Originally created by Robbie Hanson of Deusty LLC.
//  Updated and maintained by Deusty LLC and the Apple development community.
//  
//  https://github.com/robbiehanson/CocoaAsyncSocket
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>


extern NSString *const GCDAsyncUdpSocketException;
extern NSString *const GCDAsyncUdpSocketErrorDomain;

extern NSString *const GCDAsyncUdpSocketQueueName;
extern NSString *const GCDAsyncUdpSocketThreadName;

enum GCDAsyncUdpSocketError
{
	GCDAsyncUdpSocketNoError = 0,          // Never used
	GCDAsyncUdpSocketBadConfigError,       // Invalid configuration
	GCDAsyncUdpSocketBadParamError,        // Invalid parameter was passed
	GCDAsyncUdpSocketSendTimeoutError,     // A send operation timed out
	GCDAsyncUdpSocketClosedError,          // The socket was closed
	GCDAsyncUdpSocketOtherError,           // Description provided in userInfo
};
typedef enum GCDAsyncUdpSocketError GCDAsyncUdpSocketError;


typedef BOOL (^GCDAsyncUdpSocketReceiveFilterBlock)(NSData *data, NSData *address, id *context);

typedef BOOL (^GCDAsyncUdpSocketSendFilterBlock)(NSData *data, NSData *address, long tag);


@interface GCDAsyncUdpSocket : NSObject

- (id)init;
- (id)initWithSocketQueue:(dispatch_queue_t)sq;
- (id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq;
- (id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq socketQueue:(dispatch_queue_t)sq;



- (id)delegate;
- (void)setDelegate:(id)delegate;
- (void)synchronouslySetDelegate:(id)delegate;

- (dispatch_queue_t)delegateQueue;
- (void)setDelegateQueue:(dispatch_queue_t)delegateQueue;
- (void)synchronouslySetDelegateQueue:(dispatch_queue_t)delegateQueue;

- (void)getDelegate:(id *)delegatePtr delegateQueue:(dispatch_queue_t *)delegateQueuePtr;
- (void)setDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)synchronouslySetDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

- (BOOL)isIPv4Enabled;
- (void)setIPv4Enabled:(BOOL)flag;

- (BOOL)isIPv6Enabled;
- (void)setIPv6Enabled:(BOOL)flag;

- (BOOL)isIPv4Preferred;
- (BOOL)isIPv6Preferred;
- (BOOL)isIPVersionNeutral;

- (void)setPreferIPv4;
- (void)setPreferIPv6;
- (void)setIPVersionNeutral;


- (uint16_t)maxReceiveIPv4BufferSize;
- (void)setMaxReceiveIPv4BufferSize:(uint16_t)max;

- (uint32_t)maxReceiveIPv6BufferSize;
- (void)setMaxReceiveIPv6BufferSize:(uint32_t)max;


- (id)userData;
- (void)setUserData:(id)arbitraryUserData;



- (NSData *)localAddress;
- (NSString *)localHost;
- (uint16_t)localPort;

- (NSData *)localAddress_IPv4;
- (NSString *)localHost_IPv4;
- (uint16_t)localPort_IPv4;

- (NSData *)localAddress_IPv6;
- (NSString *)localHost_IPv6;
- (uint16_t)localPort_IPv6;


- (NSData *)connectedAddress;
- (NSString *)connectedHost;
- (uint16_t)connectedPort;


- (BOOL)isConnected;


- (BOOL)isClosed;


- (BOOL)isIPv4;


- (BOOL)isIPv6;




- (BOOL)bindToPort:(uint16_t)port error:(NSError **)errPtr;


- (BOOL)bindToPort:(uint16_t)port interface:(NSString *)interface error:(NSError **)errPtr;

- (BOOL)bindToAddress:(NSData *)localAddr error:(NSError **)errPtr;


- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError **)errPtr;


- (BOOL)connectToAddress:(NSData *)remoteAddr error:(NSError **)errPtr;


- (BOOL)joinMulticastGroup:(NSString *)group error:(NSError **)errPtr;


- (BOOL)joinMulticastGroup:(NSString *)group onInterface:(NSString *)interface error:(NSError **)errPtr;

- (BOOL)leaveMulticastGroup:(NSString *)group error:(NSError **)errPtr;
- (BOOL)leaveMulticastGroup:(NSString *)group onInterface:(NSString *)interface error:(NSError **)errPtr;


- (BOOL)enableBroadcast:(BOOL)flag error:(NSError **)errPtr;


- (void)sendData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;


- (void)sendData:(NSData *)data
          toHost:(NSString *)host
            port:(uint16_t)port
     withTimeout:(NSTimeInterval)timeout
             tag:(long)tag;


- (void)sendData:(NSData *)data toAddress:(NSData *)remoteAddr withTimeout:(NSTimeInterval)timeout tag:(long)tag;


- (void)setSendFilter:(GCDAsyncUdpSocketSendFilterBlock)filterBlock withQueue:(dispatch_queue_t)filterQueue;


- (void)setSendFilter:(GCDAsyncUdpSocketSendFilterBlock)filterBlock
            withQueue:(dispatch_queue_t)filterQueue
       isAsynchronous:(BOOL)isAsynchronous;


- (BOOL)receiveOnce:(NSError **)errPtr;


- (BOOL)beginReceiving:(NSError **)errPtr;


- (void)pauseReceiving;


- (void)setReceiveFilter:(GCDAsyncUdpSocketReceiveFilterBlock)filterBlock withQueue:(dispatch_queue_t)filterQueue;


- (void)setReceiveFilter:(GCDAsyncUdpSocketReceiveFilterBlock)filterBlock
               withQueue:(dispatch_queue_t)filterQueue
          isAsynchronous:(BOOL)isAsynchronous;


- (void)close;


- (void)closeAfterSending;


- (void)performBlock:(dispatch_block_t)block;


- (int)socketFD;
- (int)socket4FD;
- (int)socket6FD;


- (CFReadStreamRef)readStream;
- (CFWriteStreamRef)writeStream;


+ (NSString *)hostFromAddress:(NSData *)address;
+ (uint16_t)portFromAddress:(NSData *)address;
+ (int)familyFromAddress:(NSData *)address;

+ (BOOL)isIPv4Address:(NSData *)address;
+ (BOOL)isIPv6Address:(NSData *)address;

+ (BOOL)getHost:(NSString **)hostPtr port:(uint16_t *)portPtr fromAddress:(NSData *)address;
+ (BOOL)getHost:(NSString **)hostPtr port:(uint16_t *)portPtr family:(int *)afPtr fromAddress:(NSData *)address;



- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address;


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error;

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag;


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error;


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
                                             fromAddress:(NSData *)address
                                       withFilterContext:(id)filterContext;

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error;

@end

