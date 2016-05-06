//
//  SystemPhotosFirstController.m
//  TestDemo
//
//  Created by camera360 on 16/5/4.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import "SystemPhotosFirstController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSString+Utils.h"
#import "MineOwnPhotoFirstController.h"

static NSString * kTableViewCellIdentifier = @"kTableViewCellIdentifier";

@interface SystemPhotosFirstController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) ALAssetsLibrary * assetsLibrary;
@property(nonatomic, strong) NSMutableArray<ALAssetsGroup *>  * albumsArray;
@property(nonatomic, strong) NSMutableArray  * imagesAssetArray;
@property(nonatomic, strong) UITableView     * tableView;


@end

@implementation SystemPhotosFirstController


#pragma Mark -- 懒加载
-(NSMutableArray<ALAssetsGroup *> *)albumsArray
{
    if (!_albumsArray) {
        _albumsArray = @[].mutableCopy;
    }
    return _albumsArray;
}

-(NSMutableArray *)imagesAssetArray
{
    if (!_imagesAssetArray) {
        _imagesAssetArray = @[].mutableCopy;
    }
    return _imagesAssetArray;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
        _tableView.delegate     = self;
        _tableView.dataSource   = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self accessPhotoAlbum];
//    [self initialUI];
    // Do any additional setup after loading the view.
}

- (void)accessPhotoAlbum
{
    NSString * tipPhotoAuthorization;
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
//    如果不能访问相册信息，提示用户打开权限
    if (ALAuthorizationStatusRestricted == authorizationStatus || ALAuthorizationStatusDenied     == authorizationStatus)
    {
        NSDictionary * mainInfoDic  = [[NSBundle mainBundle] infoDictionary];
        NSString     * appName      = [mainInfoDic objectForKey:@"CFBundleDisplayName"];
        tipPhotoAuthorization       = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中， 允许%@访问您的相册", appName];
    }
//    如果已经有权限， 则访问相册
    
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
      usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
          if (group)
          {
              [group setAssetsFilter:[ALAssetsFilter allPhotos]];
//              仅仅将有图片的图片组加入到数组中
              if(group.numberOfAssets > 0)
              {
                  [self.albumsArray addObject:group];
              }
          }
          else
          {
              if (self.albumsArray.count > 0) {
//                  把所有的相册存储完毕， 可以展示相册列表
                  [self.tableView reloadData];
              }
              else
              {
//                  没有任何有资源的相册， 输出提示
              }
          }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Asset group not found!");
    }];
    
}

#pragma Mark -- UITableView Delegate && DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumsArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    cell =  [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableViewCellIdentifier];
    }
    return cell;

}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    设置cell的属性值
    ALAssetsGroup * album   = self.albumsArray[indexPath.row];
    cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
//    设置封面图
    UIImage * postImage = [[UIImage alloc] initWithCGImage:[album posterImage]];
    cell.imageView.image = postImage;
    cell.textLabel.text = [album valueForProperty:@"ALAssetsGroupPropertyName"];
    cell.detailTextLabel.text = [NSString stringFromInteger:[album numberOfAssets]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MineOwnPhotoFirstController * photoListVc = [[MineOwnPhotoFirstController alloc] init];
    photoListVc.group = self.albumsArray[indexPath.row];
    photoListVc.fromSystem = true;
    [self.navigationController pushViewController:photoListVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
