//
//  GameView.m
//  P001Puzzle
//
//  Created by 陈 少佳 on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameView.h"

@implementation GameView

@synthesize breaking;

@synthesize gameImage;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        picsArr = [[NSMutableArray alloc] init];
        autoMoveCardDirArr=[[NSMutableArray alloc] init];
        
        lastDir=DIR_NONE;
        self.breaking=false;
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [[touches allObjects] objectAtIndex:0];
    CGPoint p = [touch locationInView:self];
    
    int indexI=p.x/CARD_HEIGHT;
    int indexJ=p.y/CARD_HEIGHT;
    
    if (indexI<0||indexI>H_COUNT-1||indexJ<0||indexJ>V_COUNT-1) {
        return;
    }
    
    Card * card = cardsMap[indexI][indexJ];
    
    switch ([self getDir:card]) {
        case DIR_LEFT:
            cardsMap[indexI][indexJ]=nil;
            currentNullIndexJ=indexJ;
            currentNullIndexI=indexI;
            cardsMap[indexI-1][indexJ]=card;
            card.indexI=indexI-1;
            card.indexJ=indexJ;
            [card moveToPositionByIndexIJ:nil target:nil];
            
            [self checkToShowDialog];
            break;
        case DIR_UP:
            cardsMap[indexI][indexJ]=nil;
            currentNullIndexJ=indexJ;
            currentNullIndexI=indexI;
            cardsMap[indexI][indexJ-1]=card;
            card.indexI=indexI;
            card.indexJ=indexJ-1;
            [card moveToPositionByIndexIJ:nil target:nil];
            
            [self checkToShowDialog];
            break;
        case DIR_RIGHT:
            cardsMap[indexI][indexJ]=nil;
            currentNullIndexJ=indexJ;
            currentNullIndexI=indexI;
            cardsMap[indexI+1][indexJ]=card;
            card.indexI=indexI+1;
            card.indexJ=indexJ;
            [card moveToPositionByIndexIJ:nil target:nil];
            
            [self checkToShowDialog];
            break;
        case DIR_DOWN:
            cardsMap[indexI][indexJ]=nil;
            currentNullIndexJ=indexJ;
            currentNullIndexI=indexI;
            cardsMap[indexI][indexJ+1]=card;
            card.indexI=indexI;
            card.indexJ=indexJ+1;
            [card moveToPositionByIndexIJ:nil target:nil];
            
            [self checkToShowDialog];
            break;
        default:
            break;
    }
}


-(void)setGameImage:(CGImageRef)value{
    
    CGImageRelease(gameImage);
    
    gameImage=value;
    currentImage=value;
    
    
    //清空场景>>>>>>>>>>>>>>>>>>>>>>>>>>>
    int count=[picsArr count];
    for (int a=0; a<count; a++) {
        [[picsArr objectAtIndex:a] removeFromSuperview];
    }
    
    [picsArr removeAllObjects];
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    
    currentImageWidth=CGImageGetWidth(value);
    currentImageHeight=CGImageGetHeight(value);
    currentImagePicWidth=currentImageWidth/H_COUNT;
    currentImagePicHeight=currentImageHeight/V_COUNT;
    
    CGRect rect =CGRectMake(0, 0, currentImagePicWidth, currentImagePicHeight);
    Card * card;
    
    
    for (int i=0; i<H_COUNT; i++) {
        for (int j=0; j<V_COUNT; j++) {
            
            if (i<H_COUNT-1||j<V_COUNT-1) {
                rect.origin.x= currentImagePicWidth*i;
                rect.origin.y=currentImagePicHeight*j;
            
                card = [[Card alloc] initWithImage:[[UIImage alloc] initWithCGImage:CGImageCreateWithImageInRect(gameImage, rect)]];
                card.rightIndexI=i;
                card.rightIndexJ=j;
                card.indexI=i;
                card.indexJ=j;
                [card resetPositionByIndexIJ];
            
                [self addSubview:card];
                
                cardsMap[i][j]=card;
                [picsArr addObject:card];
            }
        }
    }
    
    currentNullIndexI=H_COUNT-1;
    currentNullIndexJ=V_COUNT-1;
    cardsMap[currentNullIndexI][currentNullIndexJ]=nil;
}


-(BOOL)checkSuccess{
    
    for (int i=0; i< [picsArr count]; i++) {
        if (![[picsArr objectAtIndex:i] onRightPlace]) {
            return NO;
        }
    }
    
    return YES;
}


-(void)checkToShowDialog{
    if ([self checkSuccess]) {
        [[[UIAlertView alloc] initWithTitle:@"恭喜您" message:@"拼图成功" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil] show];
    }
}


-(Dir)getAutoMoveCardDir{
    
    [autoMoveCardDirArr removeAllObjects];
    
    if (currentNullIndexI>0&&lastDir!=DIR_RIGHT) {
        [autoMoveCardDirArr addObject:[NSString stringWithFormat:@"%d",DIR_LEFT]];
    }
    if (currentNullIndexJ>0&&lastDir!=DIR_DOWN) {
        [autoMoveCardDirArr addObject:[NSString stringWithFormat:@"%d",DIR_UP]];
    }
    if (currentNullIndexI<H_COUNT-1&&lastDir!=DIR_LEFT) {
        [autoMoveCardDirArr addObject:[NSString stringWithFormat:@"%d",DIR_RIGHT]];
    }
    if (currentNullIndexJ<V_COUNT-1&&lastDir!=DIR_UP) {
        [autoMoveCardDirArr addObject:[NSString stringWithFormat:@"%d",DIR_DOWN]];
    }
    
    lastDir=[[autoMoveCardDirArr objectAtIndex:arc4random()%[autoMoveCardDirArr count]] intValue];
    return lastDir;
}


-(Dir)getDir:(Card *)touchedCard{
    int indexI=touchedCard.indexI;
    int indexJ=touchedCard.indexJ;
    
    if (indexI>0&&!cardsMap[indexI-1][indexJ]) {
        return DIR_LEFT;
    }
    if (indexI<H_COUNT-1&&!cardsMap[indexI+1][indexJ]) {
        return DIR_RIGHT;
    }
    if (indexJ>0&&!cardsMap[indexI][indexJ-1]) {
        return DIR_UP;
    }
    if (indexJ<V_COUNT-1&&!cardsMap[indexI][indexJ+1]) {
        return DIR_DOWN;
    }
    return DIR_NONE;
}


-(void)cardMoveEndHandler{
    if (breaking) {
        [self breakCard];
    }
}


-(void)breakCard{
    
    Dir dir = [self getAutoMoveCardDir];
    
    Card * currentCard;
    
    switch (dir) {
        case DIR_UP:
            currentCard=cardsMap[currentNullIndexI][currentNullIndexJ-1];
            cardsMap[currentNullIndexI][currentNullIndexJ]=currentCard;
            cardsMap[currentNullIndexI][currentNullIndexJ-1]=nil;
            currentCard.indexI=currentNullIndexI;
            currentCard.indexJ=currentNullIndexJ;
            currentNullIndexJ-=1;
            
            [currentCard moveToPositionByIndexIJ:@selector(cardMoveEndHandler) target:self];
            break;
        case DIR_DOWN:
            currentCard=cardsMap[currentNullIndexI][currentNullIndexJ+1];
            cardsMap[currentNullIndexI][currentNullIndexJ]=currentCard;
            cardsMap[currentNullIndexI][currentNullIndexJ+1]=nil;
            currentCard.indexI=currentNullIndexI;
            currentCard.indexJ=currentNullIndexJ;
            currentNullIndexJ+=1;
            
            [currentCard moveToPositionByIndexIJ:@selector(cardMoveEndHandler) target:self];
            break;
        case DIR_LEFT:
            currentCard=cardsMap[currentNullIndexI-1][currentNullIndexJ];
            cardsMap[currentNullIndexI][currentNullIndexJ]=currentCard;
            cardsMap[currentNullIndexI-1][currentNullIndexJ]=nil;
            currentCard.indexI=currentNullIndexI;
            currentCard.indexJ=currentNullIndexJ;
            currentNullIndexI-=1;
            
            [currentCard moveToPositionByIndexIJ:@selector(cardMoveEndHandler) target:self];
            break;
        case DIR_RIGHT:
            currentCard=cardsMap[currentNullIndexI+1][currentNullIndexJ];
            cardsMap[currentNullIndexI][currentNullIndexJ]=currentCard;
            cardsMap[currentNullIndexI+1][currentNullIndexJ]=nil;
            currentCard.indexI=currentNullIndexI;
            currentCard.indexJ=currentNullIndexJ;
            currentNullIndexI+=1;
            
            [currentCard moveToPositionByIndexIJ:@selector(cardMoveEndHandler) target:self];
            break;
        default:
            break;
    }
    
}


-(void)startBreak{
    if (!breaking) {
        breaking=YES;
        
        [self breakCard];
    }
}


-(void)stopBreak{
    breaking=NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
