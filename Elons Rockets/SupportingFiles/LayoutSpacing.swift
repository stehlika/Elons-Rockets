import Foundation

/**
 Use when defining layout of a scene in the app. These are intended to be used as spacings _between_ views
 in the scene.
 Always use one of these values (wrapped in `LayoutSpacing` shorthand) - because in the future
 they might be resolved to a different value dynamically, based on the screen size or other traits.
 */
public enum LayoutSpacingEnum: CGFloat {
    // swiftlint:disable identifier_name
    /// 2
    case xxxs = 2.0
    /// 8
    case xs = 8.0
    /// 16
    case m = 16.0
    /// 24
    case l = 24.0
    /// 32
    case xl = 32.0
    /// 40
    case xxl = 40.0
    /// 48
    case xxl2 = 48.0
    /// 56
    case xxl3 = 56.0
    /// 64
    case xxl4 = 64.0
    /// 72
    case xxl5 = 72.0
    /// 80
    case xxl6 = 80.0
    /// 88
    case xxl7 = 88.0
    /// 96
    case xxl8 = 96.0
    /// 104
    case xxl9 = 104.0
    /// 112
    case xxl10 = 112.0
    // swiftlint:enable identifier_name
}

/**
 Convenience wrapper of `LayoutSpacingEnum` cases for shorter use in controllers
 (e.g. `LayoutSpacing.x` instead of always calling `LayoutSpacing.x.value`).
 For more info on when to use refer to `LayoutSpacingEnum` documentation
 */
public struct LayoutSpacing {
    // swiftlint:disable identifier_name
    /// 2
    public static var xxxs: CGFloat { return LayoutSpacingEnum.xxxs.rawValue }
    /// 8
    public static var xs: CGFloat { return LayoutSpacingEnum.xs.rawValue }
    /// 16
    public static var m: CGFloat { return LayoutSpacingEnum.m.rawValue }
    /// 24
    public static var l: CGFloat { return LayoutSpacingEnum.l.rawValue }
    /// 32
    public static var xl: CGFloat { return LayoutSpacingEnum.xl.rawValue }
    /// 40
    public static var xxl: CGFloat { return LayoutSpacingEnum.xxl.rawValue }
    /// 48
    public static var xxl2: CGFloat { return LayoutSpacingEnum.xxl2.rawValue }
    /// 56
    public static var xxl3: CGFloat { return LayoutSpacingEnum.xxl3.rawValue }
    /// 64
    public static var xxl4: CGFloat { return LayoutSpacingEnum.xxl4.rawValue }
    /// 72
    public static var xxl5: CGFloat { return LayoutSpacingEnum.xxl5.rawValue }
    /// 80
    public static var xxl6: CGFloat { return LayoutSpacingEnum.xxl6.rawValue }
    /// 88
    public static var xxl7: CGFloat { return LayoutSpacingEnum.xxl7.rawValue }
    /// 96
    public static var xxl8: CGFloat { return LayoutSpacingEnum.xxl8.rawValue }
    /// 104
    public static var xxl9: CGFloat { return LayoutSpacingEnum.xxl9.rawValue }
    /// 112
    public static var xxl10: CGFloat { return LayoutSpacingEnum.xxl10.rawValue }
    // swiftlint:enable identifier_name
}
