//
//  JsonExecutorProxy.m
//  Studio Mobile
//
//  Created by Developer on 3/27/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//

#import "JsonExecutorProxy.h"
#import "JsonExecutor.h"
#import "NSObject+Invocation.h"
#import "HTTP_codes.h"

@interface JsonExecutorProxy () <JsonExecutorDelegate>
@end

@implementation JsonExecutorProxy {
    JsonExecutor *executor;
}
@synthesize target;
@synthesize onSuccess;
@synthesize onError;
@synthesize delegate;
@synthesize parseBlock;

- (id)initWithRequest:(NSURLRequest*)req
{
    if (self = [super init]) {
        executor = [[JsonExecutor alloc] initWithRequest:req];
        executor.delegate = self;
    }
    return self;
}

- (void)setParseBlock:(ParseBlock)_parseBlock
{
    if (parseBlock == _parseBlock) {
        return;
    }
    parseBlock = [_parseBlock copy];
    executor.parseBlock = parseBlock;
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

- (void)dealloc
{
    [self cancel];
}

#pragma mark - JsonExecutor delegate

- (void)jsonExecutor:(id)_executor didFinishWithInfo:(id)info
{
    [delegate jsonExecutor:self didFinishWithInfo:info];
    if (onSuccess) {
        [target invokeSelector:onSuccess withObject:_executor withObject:info];
    }
}

- (void)jsonExecutor:(id)_executor didFailWithError:(NSError *)error
{
    if (error.code == HTTP_WRONG_INPUT) {
        [delegate jsonExecutor:self didFailWithError:error];
        return;
    }
    
    if (onError) {
        [target invokeSelector:onError withObject:_executor withObject:error];
    }
}

@end
