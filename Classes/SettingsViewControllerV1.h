//
//  SettingsViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewControllerV1 : UIViewController {
	IBOutlet UISegmentedControl *tempUnits;
}

-(IBAction) updateTempUnits;

@end
