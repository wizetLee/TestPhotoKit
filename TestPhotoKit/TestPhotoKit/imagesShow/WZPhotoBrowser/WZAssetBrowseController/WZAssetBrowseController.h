//
//  WZAssetBrowseController.h
//  WZPhotoPicker
//
//  Created by wizet on 2017/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZImageBrowseController.h"


@interface WZAssetBrowseController : WZImageBrowseController

@property (nonatomic, assign) PHImageRequestID imageRequestID;
@property (nonatomic, assign) PHImageRequestID imageDataRequestID;

- (BOOL)overloadJudgement;
- (void)caculateSelected;

@end
