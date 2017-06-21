//
//  WZAssetBrowseNavigationView.m
//  WZPhotoPicker
//
//  Created by wizet on 2017/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZAssetBrowseNavigationView.h"

@implementation WZAssetBrowseNavigationView

+ (instancetype)customAssetBrowseNavigationWithDelegate:(id<WZProtocol_assetBrowseNaviagtion>)delegate {
    WZAssetBrowseNavigationView *navigation = [[WZAssetBrowseNavigationView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 64.0)];
    navigation.delegate = delegate;
    navigation.backgroundColor = [UIColor colorWithRed:51.0 / 255  green:51.0 / 255 blue:51.0 / 255 alpha:0.4];
    
    CGFloat buttonHW = 44.0;
    navigation.button_back = [[UIButton alloc] initWithFrame:CGRectMake(5, 20.0, buttonHW, buttonHW)];
    navigation.button_selected = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - buttonHW, 20.0, buttonHW, buttonHW)];
    navigation.label_title.textAlignment = NSTextAlignmentCenter;
    navigation.label_title = [[UILabel alloc] initWithFrame:CGRectMake(buttonHW, 20.0, [UIScreen mainScreen].bounds.size.width - buttonHW * 2.0, buttonHW)];
    navigation.label_title.textAlignment = NSTextAlignmentCenter;
    navigation.label_title.textColor = [UIColor whiteColor];
    
    [navigation addSubview:navigation.label_title];
    [navigation addSubview:navigation.button_selected];
    [navigation addSubview:navigation.button_back];
    
    [navigation.button_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navigation.button_selected setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [navigation.button_back setImage:[UIImage imageNamed:@"imagesBrowse_back"] forState:UIControlStateNormal];
    [navigation.button_selected setImage:[UIImage imageNamed:@"message_oeuvre_btn_normal"] forState:UIControlStateNormal];
    [navigation.button_selected setImage:[UIImage imageNamed:@"message_oeuvre_btn_selected"] forState:UIControlStateSelected];
    
    navigation.label_title.text = @"图片";
    [navigation.button_selected addTarget:navigation action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navigation.button_back addTarget:navigation action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return navigation;
}

- (void)clickedBtn:(UIButton *)sender {
    if (sender == self.button_back) {
        if ([_delegate respondsToSelector:@selector(backAction)]) {
            [_delegate backAction];
        }
    } else if (sender == self.button_selected) {
        if ([_delegate respondsToSelector:@selector(selectedAction)]) {
            [_delegate selectedAction];
        }
    }
}

@end
