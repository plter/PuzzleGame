//
//  Card.m
//  P001Puzzle
//
//  Created by 陈 少佳 on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Card.h"
#import "Config.h"

@implementation Card


@synthesize rightIndexI,rightIndexJ,indexI,indexJ;


-(id)initWithImage:(UIImage *)image{
    self=[super initWithImage:image];
    if (self) {
        [self setFrame:CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT)];
    }
    return self;
}


-(void)moveToPositionByIndexIJ:(SEL)moveEnd target:(id)target{
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect f = self.frame;
        f.origin.x = indexI*CARD_WIDTH;
        f.origin.y = indexJ*CARD_HEIGHT;
        self.frame=f;
    } completion:^(BOOL finished) {
        if (target) {
            [target performSelector:moveEnd];
        }
    }];
}



-(void)resetPositionByIndexIJ{
    CGRect f = self.frame;
    f.origin.x= indexI*CARD_WIDTH;
    f.origin.y=indexJ*CARD_HEIGHT;
    self.frame=f;
}


-(BOOL)onRightPlace{
    
    return rightIndexI==indexI&&rightIndexJ==indexJ;
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
