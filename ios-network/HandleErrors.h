#import <Foundation/Foundation.h>

@protocol HandleErrors <NSObject>
@optional
- (void)handleSessionOut;
- (void)handleCancelLogin;
- (void)showAlertMessage:(NSString *)message;
- (void)hideActivityView;
@end
