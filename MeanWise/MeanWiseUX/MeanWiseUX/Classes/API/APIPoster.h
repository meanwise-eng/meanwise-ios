//
//  APIPosterView.h
//  MeanWiseUX
//
//  Created by Hardik on 22/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "Constant.h"

@interface APIPoster : NSObject
{
    APIManager *manager;

}
-(void)setUp;


-(void)callStaticAPIs;
-(NSArray *)getSkillsData;
-(NSArray *)getInterestData;
-(NSArray *)getProffesionData;

-(NSArray *)getInterestDataForExploreScreen;

-(void)saveDataAs:(NSArray *)array andKey:(NSString *)key;

@end


/*

 APIPoster *tester=[[APIPoster alloc] init];
 NSLog(@"%@",[tester getInterestData]);

 APIPoster *tester=[[APIPoster alloc] init];
 NSLog(@"%@",[tester getSkillsData]);


*/
