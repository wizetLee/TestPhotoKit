//
//  WZMediaAssetBaseCell.m
//  WZPhotoPicker
//
//  Created by wizet on 2017/5/21.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZMediaAssetBaseCell.h"

@implementation WZMediaAssetBaseCell

- (void)prepareForReuse {
    self.imageView.image = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor redColor];
        _imageView.layer.masksToBounds = true;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)clickedBtn:(UIButton *)sender {
    if (_asset) {
        if (_selectedBlock) {
            _selectedBlock(_asset.selected);
        }
    }
}

- (void)setAsset:(WZMediaAsset *)asset {
    if ([asset isKindOfClass:[WZMediaAsset class]]) {
        _asset = asset;
        self.button_select.selected = _asset.selected;
        if (_asset.image_thumbnail) {
            self.imageView.image = _asset.image_thumbnail;
        } else {
            __weak typeof(self) weakSelf = self;
            [_asset fetchThumbnailImageSynchronous:false handler:^(UIImage *image) {
                 weakSelf.imageView.image = image;
            }];
        }
    }
}

#pragma mark Accessor
- (UIButton *)button_select {
    if (!_button_select) {
        CGFloat selectedBtnHW = 30;
        _button_select = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - selectedBtnHW , 0, selectedBtnHW, selectedBtnHW)];
        [self.contentView addSubview:_button_select];
        [_button_select setImage:[UIImage imageNamed:@"message_oeuvre_btn_normal"] forState:UIControlStateNormal];
        [_button_select setImage:[UIImage imageNamed:@"message_oeuvre_btn_selected"] forState:UIControlStateSelected];
        [_button_select addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button_select;
}


@end
