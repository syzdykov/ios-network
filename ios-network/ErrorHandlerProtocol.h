
@protocol ErrorHandlerProtocol <NSObject>
@optional
- (void)handleSessionOut;
- (void)handleCancelLogin;
- (void)showAlertMessage:(NSString*)message;
- (void)hideActivityView;
@end
