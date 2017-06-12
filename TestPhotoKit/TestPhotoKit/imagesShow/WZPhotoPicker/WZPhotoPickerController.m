//
//  WZPhotoPickerController.m
//  WZPhotoPicker
//
//  Created by wizet on 2017/5/19.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZPhotoPickerController.h"
#import "WZMediaAssetBaseCell.h"

#import "WZImageBrowseController.h"
#import "WZAssetBrowseController.h"
#import "WZRemoteImageBrowseController.h"

#pragma mark WZPhotoPickerController
@interface WZPhotoPickerController ()
<UICollectionViewDelegate
, UICollectionViewDataSource
, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collection;

@end

@implementation WZPhotoPickerController

#pragma mark initialize

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass([self class]);
    self.automaticallyAdjustsScrollViewInsets = false;
    if (!_array_mediaAsset) {
        _array_mediaAsset = [NSArray array];
    }
    
    [self createViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark create views
- (void)createViews {
    [self.view addSubview:self.collection];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回目录" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"选择完成" style:UIBarButtonItemStyleDone target:self action:@selector(finish)];
    
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = left;
        self.navigationItem.rightBarButtonItem = right;
    }
}

- (void)finish {
    //如果实现了代理
    if ([_delegate respondsToSelector:@selector(fetchImages:)]) {
        //获取选中目标  同步取出大小图
        NSLock *lock = [[NSLock alloc] init];
        [lock tryLock];
        NSMutableArray *mArray_images = [NSMutableArray array];
        for (WZMediaAsset *mediaAsset in self.array_mediaAsset) {
            if (mediaAsset.selected) {
                if (mediaAsset.origion) {
                    [mediaAsset fetchOrigionImageSynchronous:true handler:^(UIImage *image) {
                        [mArray_images addObject:image];
                    }];
                } else {
                    [WZMediaFetcher fetchImageWith:mediaAsset.asset costumSize:WZMediaAsset_customSize synchronous:true handler:^(UIImage *image) {
                        [mArray_images addObject:image];
                    }];
                }
            }
        }
      
        [lock unlock];
        [_delegate fetchImages:mArray_images];
        //同步完
        [self dismiss];
    } else {
        [self dismiss];
    }
}

- (void) dismiss{
    [self dismissViewControllerAnimated:true completion:^{
        if ([_delegate respondsToSelector:@selector(fetchAssets:)]) {
            NSMutableArray *mArray_mediaAsset_callback = [NSMutableArray array];
            for (WZMediaAsset *mediaAsset in self.array_mediaAsset) {
                if (mediaAsset.selected) {
                    [mArray_mediaAsset_callback addObject:mediaAsset];
                }
            }
            [_delegate fetchAssets:[NSArray arrayWithArray:mArray_mediaAsset_callback]];
        }
    }];
}

-(void)back {
    //复原选择数据
    for (WZMediaAsset *asset in self.array_mediaAsset) {
        asset.selected = false;
        asset.origion = false;
    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self dismissViewControllerAnimated:true completion:^{}];
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _array_mediaAsset.count;
}

- (__kindof WZMediaAssetBaseCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZMediaAssetBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WZMediaAssetBaseCell class]) forIndexPath:indexPath];
    
    @try {
        cell.asset = _array_mediaAsset[indexPath.row];
        __weak typeof(cell) weakCell = cell;
        __weak typeof(self) weakSelf = self;
         cell.selectedBlock = ^(BOOL selected) {
            if ([weakSelf overloadJudgement] && !weakCell.asset.selected) {
                
            } else {
                weakCell.asset.selected = !weakCell.asset.selected;
                weakCell.button_select.selected = weakCell.asset.selected;
            }
        };   
    } @catch (NSException *exception) {
        
    }
    return cell;
}

- (BOOL)overloadJudgement {
    if (self.restrictNumber == 0) {
        return false;
    }
    
    NSUInteger restrictNumber = 0;
    for (WZMediaAsset *asset in self.array_mediaAsset) {
        if (asset.selected == true) {
            restrictNumber = restrictNumber + 1;
        }
    }
    if (self.restrictNumber <= restrictNumber) {
        return true;
    }
    
    return false;
}


#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    WZMediaAssetBaseCell *cell = (WZMediaAssetBaseCell *)[collectionView cellForItemAtIndexPath:indexPath];

    //浏览大图
    if (self.array_mediaAsset.count) {
        WZAssetBrowseController *VC = [[WZAssetBrowseController alloc] init];
        VC.delegate_imagesBrowse = (id<WZProtocol_imageBrowse>)self;
        VC.array_mediaAsset = self.array_mediaAsset;
        VC.restrictNumber = self.restrictNumber;
        [VC showInIndex:indexPath.row withAnimated:true];
        [self presentViewController:VC animated:true completion:^{}];
    }
}

#pragma mark WZProtocol_imageBrowse
- (void)backAction {
    [self.collection reloadData];
}

- (void)send {
    [self finish];
}

#pragma mark WZProtocol_mediaAsset
- (void)fetchAssets:(NSArray <WZMediaAsset *> *)assets {
    if (assets) {
    }
}

#pragma mark Accessor
- (void)setArray_mediaAsset:(NSArray<WZMediaAsset *> *)array_mediaAsset {
    _array_mediaAsset = [array_mediaAsset isKindOfClass:[NSArray class]]?array_mediaAsset:nil;
    if (_collection) {
        [_collection reloadData];
    }
}

- (UICollectionView *)collection {
    if (!_collection) {
        CGRect rect = self.navigationController?CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0):self.view.bounds;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat gap = 10.0;
        layout.minimumLineSpacing = gap;
        layout.minimumInteritemSpacing = gap;
        layout.sectionInset = UIEdgeInsetsMake(gap, gap, gap, gap);
        CGFloat itemWH = ([UIScreen mainScreen].bounds.size.width - gap * 5) / 4;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        
        _collection = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.dataSource = self;
        _collection.delegate = self;
        [_collection registerClass:[WZMediaAssetBaseCell class] forCellWithReuseIdentifier:NSStringFromClass([WZMediaAssetBaseCell class])];
    }
    return _collection;
}


@end
