//
//  Card.h
//  P001Puzzle
//
//  Created by 陈 少佳 on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Card : UIImageView


-(void)resetPositionByIndexIJ;
-(void)moveToPositionByIndexIJ:(SEL)moveEnd target:(id)target;

-(BOOL)onRightPlace;

@property (nonatomic) int rightIndexI,rightIndexJ,indexI,indexJ;

@end
