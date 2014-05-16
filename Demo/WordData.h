//
//  WordData.h
//  Demo
//
//  Created by Chandni Maheta on 5/15/14.
//  Copyright (c) 2014 Chandni Maheta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordData : NSObject

@property(nonatomic,retain) NSString *word;
@property(nonatomic,assign) NSRange wordRange;
+ (NSRange ) getNextWordRange:(NSRange )inRange : (NSMutableArray *) list : (NSInteger *)index;
+ (NSRange ) getPrevWordRange:(NSRange )inRange : (NSMutableArray *) list : (NSInteger *)index;
@end
