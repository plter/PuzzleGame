//
//  ViewController.h
//  P001Puzzle
//
//  Created by 陈 少佳 on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameView.h"
#import "Data.h"

@interface ViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    IBOutlet GameView * gameView;
    IBOutlet UIButton * breakBtn;
    IBOutlet UIButton * showSourceBtn;
    IBOutlet UIButton * changeImageBtn;
}


-(IBAction)breakBtnPressed:(id)sender;
-(IBAction)changeImageBtnPressed:(id)sender;
@end
