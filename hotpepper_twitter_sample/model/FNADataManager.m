//
//  FNADataManeger.m
//  twitterSample
//
//  Created by Funami Takao on 11/11/15.
//  Copyright (c) 2011年 Recruit. All rights reserved.
//

#import "FNADataManager.h"


static FNADataManager *_sharedInstance = nil;

@implementation FNADataManager


+ (FNADataManager *)sharedManager
{
    // インスタンスを作成する
    if (!_sharedInstance) {
        _sharedInstance = [[FNADataManager alloc] init];
        
    }
    
    return _sharedInstance; 
}

- (NSArray *)shopList{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gourmet" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return [[result objectForKey:@"results"] objectForKey:@"shop"];
}

@end
