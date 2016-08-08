//
//  SmartAblumTableView.m
//  TestPhotoKit
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "SmartAblumTableVC.h"
#import <Photos/Photos.h>
#define CELLID @"cellID"
#import "ShowAlbumViewController.h"
@interface SmartAblumTableVC ()

@end

@implementation SmartAblumTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithAlbumCount:(NSInteger)albumCount {
    if (self =[super initWithStyle:UITableViewStylePlain]) {
        self.albumCount = albumCount;
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.self.albumNameArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELLID];
    cell.textLabel.text = self.albumNameArr[indexPath.row];
//    NSLog(@"%@",[NSString stringWithFormat:@"%ld张",((PHFetchResult *)self.albumAssetsArr[indexPath.row]).count]);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld张",((PHFetchResult *)self.albumAssetsArr[indexPath.row]).count];
   
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.albumAssetsArr[indexPath.row] && ((PHFetchResult *)self.albumAssetsArr[indexPath.row]).count >0) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        ShowAlbumViewController *SAVC = [[ShowAlbumViewController alloc] initWithCollectionViewLayout:layout];
        SAVC.assets = self.albumAssetsArr[indexPath.row];
        [self.navigationController pushViewController:SAVC animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
