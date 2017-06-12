//
//  WZImageScrollView.h
//  WZPhotoPicker
//
//  Created by admin on 17/5/22.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMediaFetcher.h"

@protocol WZProtocol_ImageScrollView <NSObject>

- (void)singleTap:(UIGestureRecognizer *)gesture;
- (void)doubleTap:(UIGestureRecognizer *)gesture;
- (void)longPress:(UIGestureRecognizer *)gesture;

@end

@interface WZImageScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id<WZProtocol_ImageScrollView> delegate_imageScroll;
@property (nonatomic, strong) UITapGestureRecognizer *gesture_singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *gesture_doubleTap;
@property (nonatomic, strong) UILongPressGestureRecognizer *gesture_longPress;

- (void)matchingPicture:(UIImage *)image;
- (void)matchZoomWithGesture:(UIGestureRecognizer *)gesture;


@end
