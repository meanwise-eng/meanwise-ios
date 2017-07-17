//
//  MenuItem.h
//  Mohamed Aas
//
//  Created by Mohamed Aas on 9/3/17.
//  Copyright (c) 2017 Mohamed Aas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CompleteProfileItem : NSObject

@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) UIImage* icon;
@property(nonatomic,assign) BOOL status;

- (id)initWithName:(NSString*)itemName setImage:(UIImage*)menuIcon setStatus:(BOOL)status;

@end
