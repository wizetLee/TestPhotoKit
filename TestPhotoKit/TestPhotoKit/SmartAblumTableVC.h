//
//  SmartAblumTableView.h
//  TestPhotoKit
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartAblumTableVC : UITableViewController
@property (nonatomic, assign) NSInteger albumCount;
@property (nonatomic, strong) NSMutableArray *albumNameArr;
@property (nonatomic, strong) NSMutableArray *albumAssetsArr;


- (instancetype)initWithAlbumCount:(NSInteger)albumCount;
@end
