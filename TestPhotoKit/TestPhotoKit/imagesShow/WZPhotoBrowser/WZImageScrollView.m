//
//  WZImageScrollView.m
//  WZPhotoPicker
//
//  Created by admin on 17/5/22.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZImageScrollView.h"

#define  WZ_MAX_ZOOMSCALE 3.0
@interface WZImageScrollView ()

@property (nonatomic, strong) UIImageView *imageView_picture;

@end

@implementation WZImageScrollView

#pragma mark Life Cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectZero;
        self.frame = [UIScreen mainScreen].bounds;
        self.multipleTouchEnabled = true;
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        self.alwaysBounceVertical = true;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 1.0;
        self.delegate = self;
        
        _imageView_picture = [[UIImageView alloc] init];
        _imageView_picture.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _imageView_picture.frame = self.bounds;
        _imageView_picture.clipsToBounds = true;
        _imageView_picture.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView_picture];
        
        _gesture_singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
        _gesture_doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
        _gesture_doubleTap.numberOfTapsRequired = 2;
        [_gesture_singleTap requireGestureRecognizerToFail:_gesture_doubleTap];
        _gesture_longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
        [self addGestureRecognizer:_gesture_singleTap];
        [self addGestureRecognizer:_gesture_doubleTap];
        [self addGestureRecognizer:_gesture_longPress];
    }
    return self;
}

#pragma mark public
- (void)matchingPicture:(UIImage *)image {
    if ([image isKindOfClass:[UIImage class]]) {
        _imageView_picture.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        if (_imageView_picture.image) {
            [self standardConfig];
        }
    } else {
        _imageView_picture.image = nil;
    }
}

- (void)matchZoomWithGesture:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint point = [gesture locationInView:self];
        [self matchZoomWithPoint:point];
    }
}

#pragma mark Common
- (void)gesture:(UIGestureRecognizer *)sender {
    if (sender == _gesture_singleTap) {
        if ([_delegate_imageScroll respondsToSelector:@selector(singleTap:)]) {
            [_delegate_imageScroll singleTap:sender];
        }
    } else if (sender == _gesture_doubleTap) {
        if ([_delegate_imageScroll respondsToSelector:@selector(doubleTap:)]) {
            [_delegate_imageScroll doubleTap:sender];
        }
    } else if (sender == _gesture_longPress) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            if ([_delegate_imageScroll respondsToSelector:@selector(longPress:)]) {
                [_delegate_imageScroll longPress:sender];
            }
        }
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:[UIScreen mainScreen].bounds];
}

- (void)matchZoomWithPoint:(CGPoint)point {
    CGPoint touchPoint = [self convertPoint:point toView:_imageView_picture];
    if (self.zoomScale > 1) {
        //比例复原
        [self setZoomScale:1 animated:true];
    } else if (self.maximumZoomScale > 1) {
        //
        CGFloat currentZoomScale = self.maximumZoomScale;
        CGFloat horizontalSize = CGRectGetWidth(self.bounds) / currentZoomScale;
        CGFloat verticalSize = CGRectGetHeight(self.bounds) / currentZoomScale;
        //设置浏览窗口位置
        CGRect rect = CGRectMake(touchPoint.x - horizontalSize / 2.0, touchPoint.y - verticalSize / 2.0, horizontalSize, verticalSize);
        [self zoomToRect:rect animated:true];
    }
}

- (void)matchImageViewSize {
    //更新imageView位置
    if (_imageView_picture.image) {
        CGFloat ratio = CGRectGetWidth(self.bounds) / _imageView_picture.image.size.width;
        //固定了imageView的宽度 高度随比例
        _imageView_picture.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), ceil(ratio * _imageView_picture.image.size.height));
        //配置contentSize
        self.contentSize = _imageView_picture.frame.size;
    }
}

//配置imageView 的中心位置: 初始化、变焦前后分别调用
- (void)matchImageViewCenter {
    CGFloat contentWidth = self.contentSize.width;
    CGFloat horizontalDiff = CGRectGetWidth(self.bounds) - contentWidth;//水平方向偏差 总是0
    CGFloat horizontalAddition = horizontalDiff > 0.0 ? horizontalDiff : 0.0;//设置偏差量
    
    CGFloat contentHeight = self.contentSize.height;
    CGFloat verticalDiff = CGRectGetHeight(self.bounds) - contentHeight;//垂直方向偏差
    
    //设置偏差量 当图片的高宽比大于屏幕的高宽比时,imageView的Y轴为0
    CGFloat verticalAdditon = verticalDiff > 0.0 ? verticalDiff : 0.0;
    //校正图片中心
    _imageView_picture.center = CGPointMake((contentWidth + horizontalAddition) / 2.0, (contentHeight + verticalAdditon) / 2.0);
}

- (void)matchZoomScale {
    //恢复处理
    self.maximumZoomScale = 1.0;
    [self setZoomScale:1 animated:true];
    
    CGSize imageSize = _imageView_picture.image.size;
    
    CGFloat restrictW = CGRectGetWidth(self.bounds);
    CGFloat restrictH = CGRectGetHeight(self.bounds);
    
//    if (imageSize.width <= restrictW && imageSize.height <= restrictH) {
//        //不作放大
//        self.maximumZoomScale = 1.0;
//    } else {
//        //比例为3倍
        self.maximumZoomScale = MAX(MIN(imageSize.width / restrictW, imageSize.height / restrictH), WZ_MAX_ZOOMSCALE);
//    }
    
}

//适配屏幕旋转
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (_imageView_picture.image) {
        [self standardConfig];
    }
}

- (void)standardConfig {
    [self matchZoomScale];
    [self matchImageViewSize];
    [self matchImageViewCenter];
}

#pragma mark UIScrollViewDelegate

//产生了变焦 镜头发生变化的时候 contentSize 也会发生改变 要同步imageView的位置
- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2) {
    [self matchImageViewCenter];
}

//设置变焦View
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView_picture;
}


@end
