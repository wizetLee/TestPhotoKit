//
//  WZImageContainerController.h
//  WZPhotoPicker
//
//  Created by admin on 17/5/24.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZImageScrollView.h"
#import "WZRoundRenderLayer.h"

@interface WZRemoteImgaeProgressView : UIView

@property (nonatomic, strong) WZRoundRenderLayer *custom_downloadProgress;

+ (instancetype)customProgress;

/**
 *  进度比例
 *
 *  @param rate 0 <= rate <= 1
 */
- (void)setProgressRate:(float)rate;

@end


@class WZImageContainerController;
@protocol WZProtocol_ImageContainer <NSObject>

@end

@interface WZImageContainerController : UIViewController

@property (nonatomic, weak) UIViewController <WZProtocol_ImageScrollView>*VC_main;
@property (nonatomic, weak) id<WZProtocol_ImageContainer> delegate;
@property (nonatomic, assign) NSInteger integer_index;

//进度显示(for remote)
@property (nonatomic, strong) WZRemoteImgaeProgressView *custom_progress;

- (void)matchingPicture:(UIImage *)image;
- (void)focusingWithGesture:(UIGestureRecognizer *)gesture;
@end
