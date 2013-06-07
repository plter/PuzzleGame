//
//  Data.m
//  P001Puzzle
//
//  Created by 陈 少佳 on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Data.h"

@implementation Data


NSArray* innerImgs;

+(NSArray*)getInnerImgs{
    if (!innerImgs) {
        innerImgs=[[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"innerimgs" withExtension:@"plist"]] objectForKey:@"imgs"];
    }
    
    return innerImgs;
}


int imgIndex=-1;


+(NSString*)nextInnerImg{
    imgIndex++;
    
    if (imgIndex>[[Data getInnerImgs] count]-1) {
        imgIndex=0;
    }
    
    return [[Data getInnerImgs] objectAtIndex:imgIndex];
}

@end
