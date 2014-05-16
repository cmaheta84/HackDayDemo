//
//  WordData.m
//  Demo
//
//  Created by Chandni Maheta on 5/15/14.
//  Copyright (c) 2014 Chandni Maheta. All rights reserved.
//

#import "WordData.h"

@implementation WordData

+(NSRange) getNextWordRange:(NSRange) inRange : (NSMutableArray *) list :(NSInteger *) index{
    
    NSInteger iCount = 0;
    for(WordData *data in list) {
        iCount++;
        *index = iCount;
        if(data.wordRange.location > inRange.location) {
            return data.wordRange;
        }
    }
    
    WordData * data = [list objectAtIndex:0];
    *index = 1;
    return data.wordRange;
}

+(NSRange) getPrevWordRange:(NSRange) inRange : (NSMutableArray *) list :(NSInteger *) index{
    
     NSInteger iCount = 0;
    for(WordData *data in list) {
        iCount++;
        *index = iCount;
        if(data.wordRange.location < inRange.location) {
            return data.wordRange;
        }
    }
    
    WordData * data = [list lastObject];
    *index = list.count;
    return data.wordRange;
}


@end
