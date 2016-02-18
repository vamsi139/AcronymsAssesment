//
//  Acronyms.m
//  Acronyms
//
//  Created by vamsi vayalpati on 2/17/16.
//  Copyright © 2016 vamsi vayalpati. All rights reserved.
//

#import "Acronyms.h"

@implementation Acronyms

-(Acronyms*)initWith:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.title = (NSString*)dictionary[@"sf"];
        NSArray *textArray = (NSArray*)dictionary[@"lfs"];
        self.textArray = [NSMutableArray new];
        for (NSString *text in textArray) {
            [self.textArray addObject:text];
        }
    }
    return self;
}

@end
