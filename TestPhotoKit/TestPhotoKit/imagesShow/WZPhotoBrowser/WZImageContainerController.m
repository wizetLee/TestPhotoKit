//
//  WZImageContainerController.m
//  WZPhotoPicker
//
//  Created by admin on 17/5/24.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZImageContainerController.h"

@implementation WZRemoteImgaeProgressView

#pragma mark Initialize
+ (instancetype)customProgress {
    WZRemoteImgaeProgressView *progress = [[WZRemoteImgaeProgressView alloc] init];
    CGFloat viewHW = 50;
    progress.custom_downloadProgress = [[WZRoundRenderLayer alloc] initWithCircleRadius:viewHW / 2.0 layerLineWidth:5];
    progress.frame = CGRectMake(0.0, 0.0, viewHW, viewHW);
    [progress.layer addSublayer:progress.custom_downloadProgress];
    return progress;
}

#pragma mark Public
- (void)setProgressRate:(float)rate {
    if (rate > 1) {rate = 1.0;};
    if (self.custom_downloadProgress) {
        self.custom_downloadProgress.renderAngle = (M_PI * 2.0) * rate;
    }
    
}

#pragma Override
- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - frame.size.width) / 2.0, ([UIScreen mainScreen].bounds.size.height - frame.size.height) / 2.0, frame.size.width, frame.size.height)];
}

@end

@interface WZImageContainerController()

@property (nonatomic, strong) WZImageScrollView *scroll_picture;

@end

@implementation WZImageContainerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scroll_picture = [[WZImageScrollView alloc] init];
        [self.view addSubview:_scroll_picture];
        [self.view addSubview:self.custom_progress];
    }
    return self;
}

- (void)setVC_main:(UIViewController <WZProtocol_ImageScrollView>*)VC_main {
    if ([VC_main isKindOfClass:[UIViewController class]]) {
        _VC_main = VC_main;
        _scroll_picture.delegate_imageScroll = (id<WZProtocol_ImageScrollView>)_VC_main;
    }
}

#pragma mark Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark Public
- (void)matchingPicture:(UIImage *)image {
    [_scroll_picture matchingPicture:image];
}
- (void)focusingWithGesture:(UIGestureRecognizer *)gesture {
    [_scroll_picture matchZoomWithGesture:gesture];
}


#pragma mark Accessor
- (WZRemoteImgaeProgressView *)custom_progress {
    if (!_custom_progress) {
        _custom_progress = [WZRemoteImgaeProgressView customProgress];
        _custom_progress.hidden = true;
    }
    return _custom_progress;
}
@end
