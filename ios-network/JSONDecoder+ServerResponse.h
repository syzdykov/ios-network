#import "JSONKit.h"

@interface JSONDecoder (ServerResponse)

+ (NSDictionary *)parseErrorResponse:(NSData *)responseData;

@end
