//
//  FNADetailViewController.h
//  twitterSample
//
//  Created by Funami Takao on 11/11/15.
//  Copyright (c) 2011年 Recruit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>
#import "UIAsyncImageView.h"

@interface FNADetailViewController : UIViewController <UISplitViewControllerDelegate,MKMapViewDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIAsyncImageView *photoImageView;

- (IBAction)tweete:(id)sender;

@end
