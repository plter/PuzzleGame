//
//  GameView.h
//  P001Puzzle
//
//  Created by 陈 少佳 on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Card.h"

@interface GameView : UIView{
    NSMutableArray * picsArr;

    int currentImageWidth,currentImageHeight,currentImagePicWidth,currentImagePicHeight;
    Card* cardsMap[H_COUNT][V_COUNT];
    
    int currentNullIndexI,currentNullIndexJ;
    
    
    //自动移动卡片的可用位置数组
    NSMutableArray * autoMoveCardDirArr;
    
    
    //打乱图片时，最后一次可移动的图片所在的位置
    Dir lastDir;
}


-(void)startBreak;
-(void)stopBreak;
-(Dir)getDir:(Card*)touchedCard;

//取得自动移动卡片的位置
-(Dir)getAutoMoveCardDir;

//随机移动一张卡片
-(void)breakCard;

//检查是否成功
-(BOOL)checkSuccess;

//检查是否成功，并且根据检查结果呈现对话框
-(void)checkToShowDialog;


@property (nonatomic) CGImageRef gameImage;
@property (nonatomic) BOOL breaking;

@end
