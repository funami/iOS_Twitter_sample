//
//  FNADetailViewController.m
//  twitterSample
//
//  Created by Funami Takao on 11/11/15.
//  Copyright (c) 2011年 Recruit. All rights reserved.
//

#import "FNADetailViewController.h"
#import "FNACustomAnnotation.h"
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKAnnotationView.h>
#import <MapKit/MKPinAnnotationView.h>
#import <Twitter/TWRequest.h>
#import <Twitter/TWTweetComposeViewController.h>


@interface FNADetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation FNADetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize addressLabel = _addressLabel;
@synthesize photoScrollView = _photoScrollView;
@synthesize mapView = _mapView;
@synthesize photoImageView = _photoImageView;
@synthesize webView = _webView;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item


- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        NSDictionary *shop = self.detailItem;
        
        self.title = [[shop objectForKey:@"genre"] objectForKey:@"name"];
       
        self.detailDescriptionLabel.text = [self.detailItem description];
        self.addressLabel.text = [shop objectForKey:@"name"];
        [self.photoImageView loadImage:[[[shop objectForKey:@"photo"] objectForKey:@"pc"] objectForKey:@"l"] name:nil password:nil];        
        
        CLLocationCoordinate2D co = CLLocationCoordinate2DMake([[shop objectForKey:@"lat"] floatValue], [[shop objectForKey:@"lng"] floatValue]);
        //[self.mapView setCenterCoordinate:co];
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
        MKCoordinateRegion cr = MKCoordinateRegionMake(co,span);
        [self.mapView setRegion:cr animated:YES];
        
        
        FNACustomAnnotation* annotation = [[FNACustomAnnotation alloc] initWithLocation:co];
        annotation.title = [shop objectForKey:@"name"];
        annotation.subtitle = [shop objectForKey:@"address"];
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:annotation];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[shop objectForKey:@"urls"] objectForKey:@"pc"]]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setAddressLabel:nil];
    [self setPhotoScrollView:nil];
    [self setMapView:nil];
    [self setPhotoImageView:nil];
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


#pragma mark - Map View Delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    /*
    if (annotation == mapView.userLocation) {
        return nil;
    }
     */
    
    MKPinAnnotationView *annotationView;
    NSString* identifier = @"Pin";
    annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(nil == annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
    return annotationView;
}
- (IBAction)tweete:(id)sender {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0) {
        return;
    }
    if (![TWTweetComposeViewController canSendTweet]){
        // エラー処理
        return ;
    }
    NSDictionary *shop = self.detailItem;
    TWTweetComposeViewController *tvc = [[TWTweetComposeViewController alloc] init];
    UIImage *image = self.photoImageView.image;
    [tvc addImage:image];
    [tvc setInitialText:[NSString stringWithFormat:@"『%@』 - ",[shop objectForKey:@"name"]]];
    NSURL *url = [NSURL URLWithString:[[shop objectForKey:@"urls"] objectForKey:@"pc"]];
    [tvc addURL:url];
    tvc.completionHandler = ^(TWTweetComposeViewControllerResult result){
        [self dismissModalViewControllerAnimated:YES];
    };
    
    [self presentModalViewController:tvc animated:YES];
}
@end
