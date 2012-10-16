//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

@protocol RequestExecutorDelegate;


@interface RequestExecutor : NSObject 
@property (nonatomic, unsafe_unretained) id<RequestExecutorDelegate> delegate;
@property (nonatomic, strong, readonly) NSURLRequest* originalRequest;
@property (nonatomic, strong, readonly) NSURLRequest* currentRequest;
@property (nonatomic, strong, readonly) NSURLResponse* response;
@property (nonatomic, strong, readonly) NSError* error;

- (id)initWithRequest:(NSURLRequest*)req;

- (void)start;
- (void)cancel;

@end


@protocol RequestExecutorDelegate <NSObject>
@optional

- (void)requestExecutor:(RequestExecutor*)executor didFinishWithData:(NSData*)data andResponse:(NSURLResponse*)response;

- (void)requestExecutor:(RequestExecutor*)executor didFailWithError:(NSError*)error;

- (void)requestExecutor:(RequestExecutor*)executor didReceiveResponse:(NSURLResponse*)response;

- (void)requestExecutor:(RequestExecutor*)executor didReceiveDataChunk:(NSData*)data;

- (NSURLRequest*)requestExecutor:(RequestExecutor*)executor didReceiveRedirectResponse:(NSURLResponse*)response willSendRequest:(NSURLRequest*)request;

@end