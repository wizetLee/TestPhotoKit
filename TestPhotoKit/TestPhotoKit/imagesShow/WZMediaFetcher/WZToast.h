//
//  WZToast.h



#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, WZToastPositionType) {
    WZToastPositionType_Middle       = 0,
    WZToastPositionType_Top          = 1,
    WZToastPositionType_Bottom       = 2,
};

@interface WZToast : UIView


+ (void)toastWithContent:(NSString *)content;

+ (void)toastWithContent:(NSString *)content duration:(NSTimeInterval)duration;

+ (void)toastWithContent:(NSString *)content position:(WZToastPositionType)position;

+ (void)toastWithContent:(NSString *)content
                        position:(WZToastPositionType)position
                        duration:(NSTimeInterval)duration;

+ (void)toastWithContent:(NSString *)content
                        position:(WZToastPositionType)position
                   customOriginY:(CGFloat)customOriginY;

+ (void)toastWithContent:(NSString *)content
                        position:(WZToastPositionType)position
                    customOrigin:(CGPoint)customOrigin;
@end
