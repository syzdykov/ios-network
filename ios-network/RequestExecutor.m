//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "RequestExecutor.h"

@protocol RequestExecutor_NSURLConnectionDelegate
- (NSURLRequest*)connection:(NSURLConnection*)connection willSendRequest:(NSURLRequest*)request redirectResponse:(NSURLResponse*)redirect;
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error;
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response;
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data;
- (void)connectionDidFinishLoading:(NSURLConnection*)connection;
@end

@interface RequestExecutor_ConnectionProxy : NSObject <RequestExecutor_NSURLConnectionDelegate>
@property (nonatomic, assign) id<RequestExecutor_NSURLConnectionDelegate> delegate;
@end

@interface RequestExecutor () <RequestExecutor_NSURLConnectionDelegate>
@end

@implementation RequestExecutor {
    RequestExecutor_ConnectionProxy *proxy;
    NSURLConnection *connection;
    NSMutableData *data;
    NSURLRequest *req;
    struct {
        BOOL started : 1;
        BOOL finishWithDataAndResponse:1;
        BOOL failedWithError:1;
        BOOL receiveResponse : 1;
        BOOL receiveDataChunk : 1;
        BOOL handleRedirect : 1;
    } flags;
}
@synthesize delegate;
@synthesize response;
@synthesize error;

- (id)initWithRequest:(NSURLRequest*)_req
{
    if (self = [super init]) {
        proxy = [RequestExecutor_ConnectionProxy new];
        proxy.delegate = self;
        req = _req;
    }
    return self;
}

- (void)dealloc
{
    [self cancel];
}

- (void)setDelegate:(id<RequestExecutorDelegate>)_delegate
{
    delegate = _delegate;
    flags.finishWithDataAndResponse = [delegate respondsToSelector:@selector(requestExecutor:didFinishWithData:andResponse:)];
    flags.failedWithError = [delegate respondsToSelector:@selector(requestExecutor:didFailWithError:)];
    flags.receiveResponse = [delegate respondsToSelector:@selector(requestExecutor:didReceiveResponse:)];
    flags.receiveDataChunk = [delegate respondsToSelector:@selector(requestExecutor:didReceiveDataChunk:)];
    flags.handleRedirect = [delegate respondsToSelector:@selector(requestExecutor:didReceiveRedirectResponse:willSendRequest:)];
}

- (NSURLRequest*)originalRequest
{
    return connection.originalRequest;
}

- (NSURLRequest*)currentRequest
{
    return connection.currentRequest;
}

- (void)start
{
    if (flags.started) return;
    flags.started = YES;
    [connection cancel];
    connection = nil;
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:proxy];
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    data = flags.finishWithDataAndResponse && !flags.receiveDataChunk ? [NSMutableData new] : nil;
    [connection start];
}

- (NSURLRequest*)connection:(NSURLConnection*)connection willSendRequest:(NSURLRequest*)request redirectResponse:(NSURLResponse*)redirect
{
    if (redirect && flags.handleRedirect) {
        return [delegate requestExecutor:self didReceiveRedirectResponse:redirect willSendRequest:request];
    }
    return request;
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)_error
{
    flags.started = NO;
    error = _error;
    [delegate requestExecutor:self didFailWithError:error];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)_response
{
    response = _response;
    if (flags.receiveResponse) {
        [delegate requestExecutor:self didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection*)_connection didReceiveData:(NSData*)_data
{	
    if (flags.receiveDataChunk) {
        [delegate requestExecutor:self didReceiveDataChunk:_data];
    } else {
        [data appendData:_data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    flags.started = NO;
    if (flags.finishWithDataAndResponse) {
        [delegate requestExecutor:self didFinishWithData:data andResponse:self.response];
    }
}

- (void)cancel
{
    proxy.delegate = nil;
    [connection cancel];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"Req: %@", connection.originalRequest];
}

@end


@implementation RequestExecutor_ConnectionProxy
@synthesize delegate;
- (NSURLRequest*)connection:(NSURLConnection*)connection willSendRequest:(NSURLRequest*)request redirectResponse:(NSURLResponse*)redirect
{
    return [delegate connection:connection willSendRequest:request redirectResponse:redirect];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [delegate connection:connection didFailWithError:error];
}
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    [delegate connection:connection didReceiveResponse:response];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [delegate connection:connection didReceiveData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [delegate connectionDidFinishLoading:connection];
}
@end
