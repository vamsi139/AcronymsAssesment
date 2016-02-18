//
//  Acronyms.h
//  Acronyms
//
//  Created by vamsi vayalpati on 2/17/16.
//  Copyright © 2016 vamsi vayalpati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Acronyms : NSObject

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *textArray;

-(Acronyms*)initWith:(NSDictionary*)dictionary;

@end
