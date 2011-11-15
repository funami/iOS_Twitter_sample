//
//  FNAShopViewCell.h
//  twitterSample
//
//  Created by Funami Takao on 11/11/15.
//  Copyright (c) 2011年 Recruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAsyncImageView.h"

@interface FNAShopViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *descLabel;
@property (nonatomic,strong) IBOutlet UIAsyncImageView *thumView;
@end
