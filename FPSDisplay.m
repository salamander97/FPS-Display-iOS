// Import thư viện UIKit để sử dụng các thành phần UI của iOS
#import <UIKit/UIKit.h>
#import "SCLAlertView/SCLAlertView.h"
#import "FPSDisplay.h"

// Định nghĩa chiều rộng màn hình
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

// Interface FPSDisplay
@interface FPSDisplay ()

// Các thuộc tính của FPSDisplay
@property (strong, nonatomic) UILabel *displayLabel;
@property (strong, nonatomic) CADisplayLink *link;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSTimeInterval lastTime;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIFont *subFont;

@end

@implementation FPSDisplay

// Load method được gọi khi class được load vào bộ nhớ
+ (void)load {
    // Gọi hàm shareFPSDisplay sau 20 giây khi class được load
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self shareFPSDisplay];
    });
}

// Phương thức shareFPSDisplay để trả về instance duy nhất của FPSDisplay
+ (instancetype)shareFPSDisplay {
    static FPSDisplay *shareDisplay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDisplay = [[FPSDisplay alloc] init];
    });
    return shareDisplay;
}

// Phương thức khởi tạo của FPSDisplay
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDisplayLabel];
    }
    return self;
}

// Phương thức khởi tạo Label hiển thị FPS
- (void)initDisplayLabel {
    CGRect frame = CGRectMake(SCREEN_WIDTH - 300, 0.5, 350, 30);
    self.displayLabel = [[UILabel alloc] initWithFrame: frame];
    self.displayLabel.layer.cornerRadius = 15;
    self.displayLabel.clipsToBounds = YES;
    self.displayLabel.textAlignment = NSTextAlignmentLeft;
    self.displayLabel.userInteractionEnabled = NO;

    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }

    [self initCADisplayLink];

    [[UIApplication sharedApplication].keyWindow addSubview:self.displayLabel];
    [self changeLabelColorContinuously];
}

// Phương thức thay đổi màu sắc liên tục của Label
- (void)changeLabelColorContinuously {
    // Mảng các màu để thay đổi
    NSArray *colors = @[
        // ... (Danh sách 20 màu sẽ thay đổi)
    ];
    
    // Biến lưu chỉ số màu sắc hiện tại
    __block NSInteger colorIndex = 0;

    // Timer để thay đổi màu sắc sau mỗi giây
    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.displayLabel.textColor = colors[colorIndex];
        colorIndex = (colorIndex + 1) % colors.count;
    }];
}

// Phương thức khởi tạo CADisplayLink để tính FPS
- (void)initCADisplayLink {
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

// Phương thức tick để tính FPS
- (void)tick:(CADisplayLink *)link {
    // Xác định FPS sau mỗi giây
    if (self.lastTime == 0) {
        self.lastTime = link.timestamp;
        return;
    }
    self.count += 1;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta >= 1.f) {
        self.lastTime = link.timestamp;
        float fps = self.count / delta;
        self.count = 0;
        [self updateDisplayLabelText: fps];
    }
}

// Phương thức cập nhật nội dung của Label hiển thị FPS
- (void)updateDisplayLabelText: (float) fps {
    // Khởi tạo một NSMutableString để chứa thông tin thời gian hiện tại
    NSMutableString *mustr = [[NSMutableString alloc] init];
    // Gán thông tin thời gian hiện tại vào chuỗi NSMutableString vừa khởi tạo
    [mustr appendFormat:@"%@", self.getSystemDate];
    // Gán nội dung cho Label hiển thị FPS kết hợp với thông tin thời gian và một chuỗi bổ sung "byTrungHieu"
    self.displayLabel.text = [NSString stringWithFormat:@"%dFPS %@byTrungHieu🇻🇳", (int)round(fps), mustr];
    // Thiết lập màu sắc của Label hiển thị FPS thành một màu cụ thể (màu hồng)
    self.displayLabel.textColor = [UIColor colorWithRed: 1.00 green: 0.58 blue: 0.78 alpha: 1.00];
    // Thiết lập font chữ cho Label hiển thị FPS với kích cỡ font là 11
    self.displayLabel.font = [UIFont systemFontOfSize:11];
}

// Phương thức lấy thời gian hiện tại
- (NSString *)getSystemDate {
    // Lấy thời gian hiện tại
    NSDate *currentDate = [NSDate date];
    // Khởi tạo một đối tượng NSDateFormatter để định dạng thời gian
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Đặt định dạng cho đối tượng NSDateFormatter là "yyyy-MM-dd-HH:mm:ss"
    [dateFormatter setDateFormat:@" yyyy-MM-dd-HH:mm:ss "];
    // Trả về chuỗi đại diện cho thời gian hiện tại theo định dạng đã thiết lập
    return [dateFormatter stringFromDate:currentDate];
}

@end
