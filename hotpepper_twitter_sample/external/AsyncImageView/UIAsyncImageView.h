//
//  UIAsyncImageView.h
//  AsyncImage
//
//  Created by ntaku on 09/10/31.
//  Copyright 2009 http://d.hatena.ne.jp/ntaku/. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAsyncImageView : UIImageView {

@private
	NSURLConnection *conn;
	NSMutableData *data;
    NSString *_name;
    NSString *_password;
    NSString *_url;
}
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *url;

-(void)loadImage:(NSString *)url name:(NSString *)name password:(NSString *)password;
-(void)addCorner;
-(void)abort;

@end
