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

@property (nonatomic, strong) WZRoundRenderLayer *downloadProgressLayer;

+ (instancetype)customProgress;

/**
 *  进度比例
 *
 *  @param rate 0 <= rate <= 1
 */
- (void)setProgressRate:(float)rate;

@end


@class WZImageContainerController;
@protocol WZProtocolImageContainer <NSObject>

@end

@interface WZImageContainerController : UIViewController

@property (nonatomic, weak) UIViewController <WZProtocolImageScrollView>*mainVC;
@property (nonatomic, weak) id<WZProtocolImageContainer> delegate;
@property (nonatomic, assign) NSInteger index;

//进度显示(for remote)
@property (nonatomic, strong) WZRemoteImgaeProgressView *progress;

- (void)matchingPicture:(UIImage *)image;
- (void)focusingWithGesture:(UIGestureRecognizer *)gesture;
@end
