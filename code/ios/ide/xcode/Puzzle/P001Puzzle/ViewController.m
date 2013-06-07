//
//  ViewController.m
//  P001Puzzle
//
//  Created by 陈 少佳 on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


int breakBtnStatus =1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [gameView setGameImage:[[UIImage imageNamed:[Data nextInnerImg]] CGImage]];
}


-(void)breakBtnPressed:(id)sender{
    
    switch (breakBtnStatus) {
        case 1:
            breakBtnStatus=2;
            [breakBtn setTitle:@"停止" forState:UIControlStateNormal];
            
            showSourceBtn.hidden=YES;
            changeImageBtn.hidden=YES;            
            [gameView startBreak];
            break;
        case 2:
            breakBtnStatus=1;
            [breakBtn setTitle:@"打乱" forState:UIControlStateNormal];
            
            showSourceBtn.hidden=NO;
            changeImageBtn.hidden=NO;    
            
            [gameView stopBreak];
            break;
        default:
            break;
    }
}


-(void)changeImageBtnPressed:(id)sender{
    [[[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"内置图片",@"照像机",@"图库",@"相册", nil] showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    UIImagePickerController * upc;
    
    switch (buttonIndex) {
        case 0://内置图片
            [gameView setGameImage:[[UIImage imageNamed:[Data nextInnerImg]] CGImage]];
            break;
        case 1://照像机
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                upc = [[UIImagePickerController alloc] init];
                upc.sourceType = UIImagePickerControllerSourceTypeCamera;
                upc.delegate=self;
                [self presentModalViewController:upc animated:YES];
            }else {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的主人，您的设备没有摄像头哦！" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil] show];
            }
            
            break;
        case 2://图库
            
            upc = [[UIImagePickerController alloc] init];
            upc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            upc.delegate=self;
            [self presentModalViewController:upc animated:YES];
            
            break;
        case 3://相册
            upc = [[UIImagePickerController alloc] init];
            upc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            upc.delegate=self;
            [self presentModalViewController:upc animated:YES];
            break;
        default:
            break;
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    [self dismissModalViewControllerAnimated:YES];
    int width = CGImageGetWidth(image.CGImage);
    int height = CGImageGetHeight(image.CGImage);
    int minValue = MIN(width, height);
    
    if (minValue>320) {
        int imageWidth=320;
        
        CGImageRef srcCopy = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, minValue, minValue));
        UIImage * newImage = [UIImage imageWithCGImage:srcCopy];
        
        UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageWidth));
        [newImage drawInRect:CGRectMake(0, 0, imageWidth, imageWidth)];
        [gameView setGameImage:UIGraphicsGetImageFromCurrentImageContext().CGImage];
        UIGraphicsEndImageContext();
        
        CGImageRelease(image.CGImage);
    }else {
        [gameView setGameImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, minValue, minValue))];
        
        CGImageRelease(image.CGImage);
    }
   
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
