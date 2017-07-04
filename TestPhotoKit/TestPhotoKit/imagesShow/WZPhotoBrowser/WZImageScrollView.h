//
//  WZImageScrollView.h
//  WZPhotoPicker
//
//  Created by admin on 17/5/22.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMediaFetcher.h"

@protocol WZProtocolImageScrollView <NSObject>

- (void)singleTap:(UIGestureRecognizer *)gesture;
- (void)doubleTap:(UIGestureRecognizer *)gesture;
- (void)longPress:(UIGestureRecognizer *)gesture;

@end

@interface WZImageScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id<WZProtocolImageScrollView> imageScrollDelegate;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

- (void)matchingPicture:(UIImage *)image;
- (void)matchZoomWithGesture:(UIGestureRecognizer *)gesture;


@end
