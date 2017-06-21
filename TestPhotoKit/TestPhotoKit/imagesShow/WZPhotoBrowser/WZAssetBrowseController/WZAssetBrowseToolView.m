//
//  WZAssetBrowseToolView.m
//  WZPhotoPicker
//
//  Created by wizet on 2017/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZAssetBrowseToolView.h"

@implementation WZAssetBrowseToolView

+ (instancetype)customAssetBrowseToolWithDelegate:(id<WZProtocol_assetBrowseTool>)delegate {
    WZAssetBrowseToolView *tool = [[WZAssetBrowseToolView alloc] init];
    tool.delegate = delegate;
    CGFloat toolH = 49.0;
    tool.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - toolH, [UIScreen mainScreen].bounds.size.width, toolH);
    tool.backgroundColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:0.4];
    
    tool.button_selectedClear = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat button_origionHW = 72 / 2.0;
    tool.button_selectedClear.frame = CGRectMake(5.0, (toolH - button_origionHW)/2.0 , button_origionHW, button_origionHW);
    
    [tool.button_selectedClear setImage:[UIImage imageNamed:@"asset_selectedOrigion_normal"] forState:UIControlStateNormal];
        [tool.button_selectedClear setImage:[UIImage imageNamed:@"asset_selectedOrigion_selected"] forState:UIControlStateSelected];
    
    tool.label_clearInfo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tool.button_selectedClear.frame), 0.0, [UIScreen mainScreen].bounds.size.width / 2.0, toolH)];
    tool.label_clearInfo.text = @"选择原图";
    tool.label_clearInfo.textColor = [UIColor whiteColor];
    
    __weak typeof(tool) weakTool = tool;
    tool.fetchClearInfo = ^(NSString *info){
        weakTool.label_clearInfo.text = [NSString stringWithFormat:@"选择原图(%@)", info];
    };
    
    tool.button_complete = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat button_completeHW = 45.0;
    tool.button_complete.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - button_completeHW - 15.0, (toolH - button_completeHW)/2.0, button_completeHW, button_completeHW);
    [tool.button_complete setTitle:@"发送" forState:UIControlStateNormal];
    tool.button_complete.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [tool.button_complete setTitleColor:[UIColor colorWithRed:254.0 / 255  green:191.0 / 255 blue:39.0 / 255 alpha:1.0] forState:UIControlStateNormal];
    [tool.button_complete setTitleColor:[UIColor colorWithRed:254.0 / 255  green:191.0 / 255 blue:39.0 / 255 alpha:1.0] forState:UIControlStateHighlighted];
    CGFloat label_HW = 20.0;
    
    tool.label_count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(tool.button_complete.frame) -label_HW, (toolH - label_HW)/2.0, label_HW, label_HW)];
    tool.label_count.backgroundColor = [UIColor colorWithRed:254.0 / 255  green:191.0 / 255 blue:39.0 / 255 alpha:1.0];
    tool.label_count.text = @"0";
    tool.restrictNumber = ^(NSUInteger restrictNumber){
        weakTool.label_count.text = [NSString stringWithFormat:@"%ld", restrictNumber];
    };
    tool.label_count.layer.cornerRadius = label_HW / 2.0;
    tool.label_count.layer.masksToBounds = true;
    tool.label_count.textAlignment = NSTextAlignmentCenter;
    tool.label_count.textColor = [UIColor whiteColor];
    
    [tool addSubview:tool.button_selectedClear];
    [tool addSubview:tool.button_complete];
    [tool addSubview:tool.label_clearInfo];
    [tool addSubview:tool.label_count];
    
    [tool.button_complete addTarget:tool action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tool.button_selectedClear addTarget:tool action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    return tool;
}

- (void)clickedBtn:(UIButton *)sender {
    if (sender == self.button_selectedClear) {
        if ([_delegate respondsToSelector:@selector(selectedOrigionAction)]) {
            [_delegate selectedOrigionAction];
        }
    } else if (sender == self.button_complete) {
        if ([_delegate respondsToSelector:@selector(completeAction)]) {
            [_delegate completeAction];
        }
    }
}

@end
