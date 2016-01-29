#ifndef __VIEWCONTROLLER_H__
#define __VIEWCONTROLLER_H__

#import <UIKit/UIKit.h>

class IOSSimpleApp;

@interface ViewController : UIViewController
{
}

@property (nonatomic, assign) NSTimer *runTimer;

-(id) initWithApp:(IOSSimpleApp*)app;
-(void) close;
-(void) addButton:(UIButton*)button withText:(NSString*)text Y:(CGFloat)y;

@end

#endif
