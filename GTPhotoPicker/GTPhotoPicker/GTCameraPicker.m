//
//  GTCameraPicker.m
//  GTPhotoPicker
//
//  Created by gt on 16/5/21.
//  Copyright © 2016年 gt. All rights reserved.
//

#import "GTCameraPicker.h"

@interface GTCameraPicker()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy) void (^FinishAction)(UIImage *image);

@end

static GTCameraPicker *_cameraPickerInstance = nil;

@implementation GTCameraPicker

+ (void)loadImageFromeViewController:(UIViewController *)viewController finishAction:(void (^)(UIImage *))finishAction{
    
    if (_cameraPickerInstance == nil) {
        _cameraPickerInstance = [[GTCameraPicker alloc] init];
    }
    
    [_cameraPickerInstance loadImageFromeViewController:viewController finishAction:finishAction];
}

- (void)loadImageFromeViewController:(UIViewController *)viewController finishAction:(void (^)(UIImage *))finishAction{
    
    _FinishAction = finishAction;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    [viewController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if (_FinishAction) {
        _FinishAction(image);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    _cameraPickerInstance = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
   
    if (_FinishAction) {
        _FinishAction(nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    _cameraPickerInstance = nil;
}

@end
