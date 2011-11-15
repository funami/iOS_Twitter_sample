//
//  FNACustomAnnotation.h
//  twitterSample
//
//  Created by Funami Takao on 11/11/15.
//  Copyright (c) 2011年 Recruit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKAnnotation.h>

@interface FNACustomAnnotation : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;


@end
