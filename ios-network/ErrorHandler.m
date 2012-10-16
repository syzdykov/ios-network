//
//  ErrorHandler.m
//  Studio Mobile
//
//  Created by Developer on 3/27/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//

#import "ErrorHandler.h"
#import "JsonExecutorAdapter.h"
#import "ErrorHandlerProtocol.h"
#import "HTTP_codes.h"

@implementation ErrorHandler {
    __unsafe_unretained UIViewController<ErrorHandlerProtocol> *activeCtrl;
    id<JsonExecutorProtocol> executor;
    struct {
        BOOL handleSessionOut : 1;
        BOOL handleCancelLogin : 1;
        BOOL canHideAcitvity:1;
        BOOL canShowAlert:1;
    } flags;
}

- (id)initWithActiveCtrl:(UIViewController<ErrorHandlerProtocol>*)ctrl
{
    if (self = [super init]) {
        activeCtrl = ctrl;
        flags.handleSessionOut = [activeCtrl respondsToSelector:@selector(handleSessionOut)];
        flags.handleCancelLogin = [activeCtrl respondsToSelector:@selector(handleCancelLogin)];
        flags.canHideAcitvity = [activeCtrl respondsToSelector:@selector(hideActivityView)];
        flags.canShowAlert = [activeCtrl respondsToSelector:@selector(showAlertMessage:)];

    }
    return self;
}

- (void)handleSessionOut;
{
    if (flags.handleSessionOut) {
        [activeCtrl handleSessionOut];
        return;
    }
}

- (void)handleExecutor:(id<JsonExecutorProtocol>)exec error:(NSError *)error
{
    [self handleExecutor:exec error:error checkSessionOut:YES];
}

- (void)handleExecutor:(id<JsonExecutorProtocol>)exec error:(NSError *)error checkSessionOut:(BOOL)check
{
    if (executor) executor = nil;
    executor = exec;
    
    if (flags.canHideAcitvity) {
        [activeCtrl hideActivityView];
    }
    
    if (error.code == HTTP_SESSION_OUT) {
        if (check)  [self handleSessionOut];
        return;
    }
    
    if (flags.canShowAlert) {
        [activeCtrl showAlertMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]];
    }
}


@end
