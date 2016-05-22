//
//  GTAlbumPickerDetail_VC.m
//  GTPhotoPicker
//
//  Created by gt on 16/5/22.
//  Copyright © 2016年 gt. All rights reserved.
//

#import "GTAlbumPickerDetail_VC.h"
#import "GTGetAlbumPhotos.h"

@interface GTAlbumPickerDetail_VC ()

@property (nonatomic,copy) NSArray *photosArray;

@end

@implementation GTAlbumPickerDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GTGetAlbumPhotos *manager = [GTGetAlbumPhotos new];
    self.photosArray = [manager getAlbumPhotos];
    
    NSLog(@"-----photos=%@---",self.photosArray);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
