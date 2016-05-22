//
//  ViewController.m
//  GTPhotoPicker
//
//  Created by gt on 16/5/21.
//  Copyright © 2016年 gt. All rights reserved.
//

#import "ViewController.h"
#import "SystemActionSheet.h"
#import "GTPhotoPicker.h"

@interface ViewController ()

//存放图片的数组
@property (nonatomic,strong)NSMutableArray *imgArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgArray = [@[] mutableCopy];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(100, 50, 100, 100);
    [button setTitle:@"click me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

- (void)buttonClick{
    
    if (_imgArray.count < kMaxPhotoPickNumber) {
        
        // 上传的图片数量小于9，继续上传
        NSLog(@"----imgArray=%@----",_imgArray);
        
        __weak typeof(self) weakSelf = self;
        
        [SystemActionSheet loadActionSheetInVC:self withTitle:@"请选择照片" message:nil handelTitle:@[@"拍照",@"从相册选择"] handler:^(NSInteger actionTag) {
            
            if (actionTag == 0) {
                
                // 相机拍单个图片
                
                [GTCameraPicker loadImageFromeViewController:self finishAction:^(UIImage *image) {
                    
                    if (image) {
                        
                        [weakSelf.imgArray addObject:image];
                    }
                    
                    NSLog(@"----%@",image);
                }];
                
            }else if (actionTag == 1){
                
                // 系统相册选取,回传入imgArray的数量,最多上传数量为9
                
                GTAlbumPicker *picker = [GTAlbumPicker new];
                
                picker.maxPhotoPickNumber = kMaxPhotoPickNumber - weakSelf.imgArray.count;
                
                [picker loadImageFromeViewController:self result:^(NSArray *imgArray) {
                    
                    // 添加操作
                    if (imgArray.count > 0) {
                        [imgArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
                            [weakSelf.imgArray addObject:image];
                        }];

                    }
                   
                }];
            }
        }];
        
    }else{
        
        // 上传图片的数量达到上限9，做下一步操作
        NSLog(@"----imgArray=%@----",_imgArray);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
