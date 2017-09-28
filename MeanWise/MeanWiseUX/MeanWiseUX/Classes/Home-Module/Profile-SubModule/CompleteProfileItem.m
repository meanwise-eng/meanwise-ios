//
//  MenuItem.m
//  Mohamed Aas
//
//  Created by Mohamed Aas on 9/3/17.
//  Copyright (c) 2017 Mohamed Aas. All rights reserved.
//

#import "CompleteProfileItem.h"

@implementation CompleteProfileItem


-(id)initWithName:(NSString *)itemName setImage:(UIImage *)menuIcon setStatus:(BOOL)status{
    self.name = itemName;
    self.icon = menuIcon;
    self.status = status;
    return self;
}

@end
