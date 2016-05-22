//
//  GTAlbumPicker.m
//  GTPhotoPicker
//
//  Created by gt on 16/5/22.
//  Copyright © 2016年 gt. All rights reserved.
//

#import "GTAlbumPicker.h"
#import "GTAlbumPickerDetail_VC.h"
#import <Photos/Photos.h>

@interface GTAlbumPicker()

@property (nonatomic,strong) GTAlbumPickerDetail_VC *albumPickerDetail_VC;

@end

@implementation GTAlbumPicker

// 懒加载控制器

- (GTAlbumPickerDetail_VC *)albumPickerDetail_VC{
    
    if (!_albumPickerDetail_VC) {
        _albumPickerDetail_VC = [[GTAlbumPickerDetail_VC alloc] init];
    }
    
    return _albumPickerDetail_VC;
}

// 回调方法
- (void)loadImageFromeViewController:(UIViewController *)viewController result:(AlbumPickerResult)result{
    
    //相册权限判断
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        //相册权限未开启
        [self showAlertViewToController:viewController];
        
    }else if(status == PHAuthorizationStatusNotDetermined){
        //相册进行授权
        /* * * 第一次安装应用时直接进行这个判断进行授权 * * */
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            //授权后直接打开照片库
            if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadImageFromeViewController:viewController result:result];
                });
            }
        }];
    }else if (status == PHAuthorizationStatusAuthorized){
        //相册权限开启
        [self loadController:viewController result:result];
    }
}

#pragma mark - private

-(void)loadController:(UIViewController *)controller result:(AlbumPickerResult)result{
    
    // 最终选择的图片放入数组
    self.albumPickerDetail_VC.result = result;
    // 最大选择数量
    self.albumPickerDetail_VC.pickNumber = _maxPhotoPickNumber;
    // 模态弹出视图
    [controller presentViewController:self.albumPickerDetail_VC animated:YES completion:nil];
}

-(void)showAlertViewToController:(UIViewController *)controller{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的手机相册",app_Name] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [controller presentViewController:alert animated:YES completion:nil];
}


@end
