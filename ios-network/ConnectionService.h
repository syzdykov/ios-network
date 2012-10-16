#import "JsonExecutorProtocol.h"
#import "ErrorHandlerProtocol.h"
#import "RequestExecutor.h"
#import "WebParams.h"
#import "NSDictionary+Helpers.h"
#import "JSONKit.h"
#import "JsonExecutorProxy.h"
#import "ErrorHandler.h"
#import "HTTP_CODES.h"
extern NSString *ErrorDomain;

@interface ConnectionService : NSObject {
    JSONDecoder *jsonDecoder;
    NSNumberFormatter *numberFormatter;
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain, readonly) NSURL *rootUrl;
@property (nonatomic, unsafe_unretained) UIViewController<ErrorHandlerProtocol> *activeCtrl;

- (id)initWithRootUrl:(NSURL *)_rootUrl;

- (JsonExecutorProxy *)requestExecutorForRelativePath:(NSString *)path andParams:(WebParams *)params;

@end
