//
//  JsonExecutor.m
//  Studio Mobile
//
//  Created by Developer on 3/26/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//

#import "JsonExecutor.h"
#import "RequestExecutor.h"
#import "HTTP_codes.h"
#import "JSONDecoder+ServerResponse.h"

#define ERROR_DOMAIN @"ErrorDomain"

#define SET_NOT_NIL_VALUE_FOR_KEY(dict, value, key) if (value) {[dict setValue:value forKey:key];}

@interface JsonExecutor () <RequestExecutorDelegate>
@end

@implementation JsonExecutor {
    RequestExecutor *executor;
}
@synthesize delegate;
@synthesize parseBlock;

- (id)initWithRequest:(NSURLRequest*)req
{
    if (self = [super init]) {
        executor = [[RequestExecutor alloc] initWithRequest:req];
        executor.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [self cancel];
}

- (void)start
{
    [executor start];
}

- (void)cancel
{
    executor.delegate = nil;
    [executor cancel];
}

#pragma mark - RequestExecutor Delegate

- (NSError*)errorWithCode:(NSInteger)code description:(NSString*)description messages:(NSDictionary*)messages
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    SET_NOT_NIL_VALUE_FOR_KEY(info, description, NSLocalizedDescriptionKey);
    SET_NOT_NIL_VALUE_FOR_KEY(info, messages, NSLocalizedFailureReasonErrorKey);
    
    return [[NSError alloc] initWithDomain:ERROR_DOMAIN code:code userInfo:info];
}

- (void)requestExecutor:(RequestExecutor *)executor didFailWithError:(NSError *)error
{
    [delegate jsonExecutor:self didFailWithError:error];
}

- (void)requestExecutor:(RequestExecutor *)executor didFinishWithData:(NSData *)data andResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
    switch (resp.statusCode) {
        case HTTP_OK:
            [delegate jsonExecutor:self didFinishWithInfo:(parseBlock != nil && data.length > 2) ? parseBlock(data) : data];
            break;
        case HTTP_WRONG_INPUT:
            [delegate jsonExecutor:self didFailWithError:[self errorWithCode:resp.statusCode description:nil messages:[JSONDecoder parseErrorResponse:data]]];
            break;
        case HTTP_SESSION_OUT:
            [delegate jsonExecutor:self didFailWithError:[self errorWithCode:resp.statusCode description:nil messages:nil]];
            break;
        case HTTP_NOT_FOUND:
            [delegate jsonExecutor:self didFailWithError:[self errorWithCode:resp.statusCode description:NSLocalizedString(@"Не удается установить соединение с сервером, ведутся технические работы.", nil) messages:nil]];
            break;
        case HTTP_PROCESS_ERROR:
            [delegate jsonExecutor:self didFailWithError:[self errorWithCode:resp.statusCode description:NSLocalizedString(@"Невозможно совершить данное действие - внутренняя ошибка сервера.", nil) messages:nil]];
            break;
        case HTTP_BAD_REQUEST:
            [delegate jsonExecutor:self didFailWithError:[self errorWithCode:resp.statusCode description:NSLocalizedString(@"В запросе клиента обнаружена синтаксическая ошибка.", nil) messages:nil]];
            break;
        case STORE_IS_OFF:
            [delegate jsonExecutor:self didFailWithError:[self errorWithCode:resp.statusCode description:NSLocalizedString(@"Мобильный магазин отключен.", nil) messages:nil]];
            break;
        default: 
            break;
    }
}

@end
