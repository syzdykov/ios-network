#import "JSONDecoder+ServerResponse.h"
#import "JSONKit.h"

@implementation JSONDecoder (ServerResponse)

+ (NSDictionary *)parseErrorResponse:(NSData *)responseData
{
    JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSDictionary *error = [decoder objectWithData:responseData];
    return error;
}

@end
