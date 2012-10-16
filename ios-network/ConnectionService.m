#import "ConnectionService.h"

#define SESSION_COOKIE_NAME @"PHPSESSID"
#define B(v) (v ? @"true" : @"false")

@implementation ConnectionService {
    NSURL *cookieURL;
    ErrorHandler *handler;
}

@synthesize rootUrl;
@synthesize activeCtrl;

- (id)initWithRootUrl:(NSURL *)_rootUrl
{
    if ((self = [super init])) {
        rootUrl = _rootUrl;
        cookieURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", rootUrl.host]];
        
        static NSNumberFormatter *_numberFormatter;
        static NSDateFormatter *_dateFormatter;
        static JSONDecoder *_jsonDecoder;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            _numberFormatter = [NSNumberFormatter new];
            [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [_numberFormatter setDecimalSeparator:@"."];
            
            _dateFormatter = [NSDateFormatter new];
            [_dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
            [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            
            // Need to set en_US_POSIX locale to parse incoming dates correctly
            // http://developer.apple.com/library/ios/#qa/qa1480/_index.html
            [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            
            _jsonDecoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
        });
        
        numberFormatter = _numberFormatter;
        dateFormatter = _dateFormatter;
        jsonDecoder = _jsonDecoder;
    }
    return self;
}

- (void)setActiveCtrl:(UIViewController<ErrorHandlerProtocol> *)_activeCtrl
{
    activeCtrl = _activeCtrl;
    handler = [[ErrorHandler alloc] initWithActiveCtrl:activeCtrl];
}

- (JsonExecutorProxy *)requestExecutorForRelativePath:(NSString *)path andParams:(WebParams *)params
{
    NSData *postBodyData = params.formData;
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[rootUrl URLByAppendingPathComponent:path]];
    
    if (params) {
        req.HTTPMethod = @"POST";
        [req setValue:params.formContentType forHTTPHeaderField:@"Content-Type"];
        [req setValue:[NSString stringWithFormat:@"%d", postBodyData.length] forHTTPHeaderField:@"Content-Length"];
        req.HTTPBody = postBodyData;
    }
    JsonExecutorProxy *exec = [[JsonExecutorProxy alloc] initWithRequest:req];
    exec.target = self;
    exec.onSuccess = nil;
    exec.onError = @selector(exec:didFailWithError:);
    return exec;
}

#pragma - handling executor response

- (void)exec:(id)executor didFailWithError:(NSError *)error
{
    [handler handleExecutor:executor error:error];    
}

- (void)exec:(id)executor didFailToLoadFavoritesWithError:(NSError*)error
{
    [handler handleExecutor:executor error:error checkSessionOut:NO];
}

@end
