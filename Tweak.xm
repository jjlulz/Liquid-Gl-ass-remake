#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface CCUIContentModuleContainerView : UIView @end
@interface CCUIRoundButton : UIControl @end
@interface CCUIModularControlCenterOverlayViewController : UIViewController @end
@interface SBDockView : UIView @end
@interface SBFolderBackgroundView : UIView @end
@interface SBFolderIconBackgroundView : UIView @end
@interface NCNotificationShortLookView : UIView @end

static UIView *ivarView(id obj, const char *name) {
    Ivar iv = class_getInstanceVariable([obj class], name);
    if (!iv) return nil;
    id v = object_getIvar(obj, iv);
    return [v isKindOfClass:[UIView class]] ? (UIView *)v : nil;
}

static void glass(UIView *v, CGFloat radius, CGFloat borderAlpha) {
    if (!v) return;
    v.layer.cornerRadius = radius;
    v.layer.masksToBounds = YES;
    v.layer.borderWidth = 0.8;
    v.layer.borderColor = [UIColor colorWithWhite:1 alpha:borderAlpha].CGColor;

    UIView *h = [v viewWithTag:2626];
    if (!h) {
        h = [[UIView alloc] initWithFrame:v.bounds];
        h.tag = 2626;
        h.userInteractionEnabled = NO;
        h.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        CAGradientLayer *g = [CAGradientLayer layer];
        g.colors = @[(id)[UIColor colorWithWhite:1 alpha:0.28].CGColor,
                     (id)[UIColor colorWithWhite:1 alpha:0.0].CGColor,
                     (id)[UIColor colorWithWhite:1 alpha:0.10].CGColor];
        g.startPoint = CGPointMake(0, 0);
        g.endPoint = CGPointMake(1, 1);
        [h.layer addSublayer:g];
        [v addSubview:h];
    }
    h.frame = v.bounds;
    for (CALayer *l in h.layer.sublayers) l.frame = h.bounds;
}

// ---------- Control Center ----------
%hook CCUIContentModuleContainerView
- (void)layoutSubviews {
    %orig;
    glass(self, 30.0, 0.35);
}
%end

%hook CCUIRoundButton
- (void)layoutSubviews {
    %orig;
    self.layer.cornerRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0;
    self.layer.borderWidth = 0.8;
    self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
}
%end

%hook CCUIModularControlCenterOverlayViewController
- (void)viewDidLoad {
    %orig;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.12];
}
%end

// ---------- Dock ----------
%hook SBDockView
- (void)layoutSubviews {
    %orig;
    UIView *bg = ivarView(self, "_backgroundView");
    if (bg) {
        bg.frame = CGRectInset(bg.frame, 10, 8);
        glass(bg, MIN(30.0, bg.bounds.size.height / 2.0), 0.35);
    }
}
%end

// ---------- Folders ----------
%hook SBFolderIconBackgroundView
- (void)layoutSubviews {
    %orig;
    glass(self, self.bounds.size.width * 0.2237, 0.35);
}
%end

%hook SBFolderBackgroundView
- (void)layoutSubviews {
    %orig;
    glass(self, 38.0, 0.30);
}
%end

// ---------- Notification banners ----------
%hook NCNotificationShortLookView
- (void)layoutSubviews {
    %orig;
    glass(self, 24.0, 0.35);
}
%end
