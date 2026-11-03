// CC26 - iOS 26 "Liquid Glass" style Control Center approximation for iOS 12.
// Untested on device: class/ivar names may need tweaking (use FLEX / class-dump).
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CCUIContentModuleContainerView : UIView
@end
@interface CCUIModularControlCenterOverlayViewController : UIViewController
@end
@interface CCUIRoundButton : UIControl
@end

static const CGFloat kTileRadius = 30.0;

static void applyGlass(UIView *v, CGFloat radius) {
    v.layer.cornerRadius = radius;
    v.layer.masksToBounds = YES;
    v.layer.borderWidth = 0.8;
    v.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.35].CGColor;

    if (![v viewWithTag:2626]) {
        // Specular edge highlight: diagonal white gradient fading out.
        CAGradientLayer *g = [CAGradientLayer layer];
        g.name = @"cc26.highlight";
        g.colors = @[(id)[UIColor colorWithWhite:1 alpha:0.28].CGColor,
                     (id)[UIColor colorWithWhite:1 alpha:0.0].CGColor,
                     (id)[UIColor colorWithWhite:1 alpha:0.10].CGColor];
        g.startPoint = CGPointMake(0, 0);
        g.endPoint = CGPointMake(1, 1);
        UIView *holder = [[UIView alloc] initWithFrame:v.bounds];
        holder.tag = 2626;
        holder.userInteractionEnabled = NO;
        holder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        g.frame = holder.bounds;
        [holder.layer addSublayer:g];
        [v addSubview:holder];
    }
    UIView *h = [v viewWithTag:2626];
    for (CALayer *l in h.layer.sublayers) l.frame = h.bounds;
}

%hook CCUIContentModuleContainerView
- (void)layoutSubviews {
    %orig;
    self.layer.cornerRadius = kTileRadius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.8;
    self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.35].CGColor;
    UIView *h = [self viewWithTag:2626];
    if (!h) {
        applyGlass(self, kTileRadius);
    } else {
        for (CALayer *l in h.layer.sublayers) l.frame = h.bounds;
    }
}
%end

%hook CCUIRoundButton
- (void)layoutSubviews {
    %orig;
    self.layer.borderWidth = 0.8;
    self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
}
%end

%hook CCUIModularControlCenterOverlayViewController
- (void)viewDidLoad {
    %orig;
    // Heavier dim behind the glass tiles, like iOS 26.
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.12];
}
%end
