//
//  GTAlbumPickerCollectionViewCell.m
//  GTPhotoPicker
//
//  Created by gt on 16/5/22.
//  Copyright © 2016年 gt. All rights reserved.
//

#import "GTAlbumPickerCollectionViewCell.h"

@implementation GTAlbumPickerCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
        
        _photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, photoSize, photoSize)];
        
        _photoImage.layer.masksToBounds = YES;
        
        _photoImage.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:_photoImage];
        
        
        CGFloat picViewSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
        
        CGFloat btnSize = picViewSize / 4;
        
        _selectButton = [[UIButton alloc]initWithFrame:CGRectMake(picViewSize - btnSize - 5, 5, btnSize, btnSize)];
        
        [self.contentView addSubview:_selectButton];
        
    }
    return self;
}

-(void)selectButtonStage:(NSMutableArray *)selectArray existence:(PHAsset *)assetItem{
    if ([selectArray containsObject:assetItem]) {
        [_selectButton setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateNormal];
    }else{
        [_selectButton setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
    }
}

-(void)loadPhotoData:(PHAsset *)assetItem{
    
    if ([assetItem isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = assetItem;
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info){
            
            self.photoImage.image = result;
            
        }];
        
    }
}
@end
