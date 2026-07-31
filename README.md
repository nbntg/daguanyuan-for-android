# 大观园数学题库 Android 版

这是一个使用 Flutter 编写的离线 Android 数学题库应用。应用不使用 WebView，不申请联网权限；题库、题图、学习状态和书写画布均在本地工作。

## 主要功能

- 按学科和章节浏览离线题库。
- 选择题作答、掌握度标记、收藏本和复习本。
- 每道题独立的矢量书写画布、文字笔记和 LaTeX 渲染。
- 画布 PNG、PDF 和分级批量导出。
- 本地 JSON 进度导入与导出。
- 恢复上次学习位置。

仓库内置的是空白初始进度，不包含任何账号、收藏、复习记录或学习历史。

## 开发环境

- Flutter `3.44.8` stable
- Dart `3.12.2`
- JDK 17
- Android SDK

Gradle 由仓库内的 Gradle Wrapper 自动下载。Flutter 和 Android SDK 不需要放进源码仓库。

## 构建

在仓库根目录执行：

```powershell
flutter pub get
node tool/verify_project.js
flutter analyze
flutter test
flutter build apk --release
```

生成的 APK 位于：

```text
build/app/outputs/flutter-apk/app-release.apk
```

Windows 用户也可以双击 `构建APK.cmd`，脚本会执行检查并生成 `daguan-math-community-v1.0.9.apk`。

### APK 签名说明

官方 Release APK 使用维护者私下保存的发布密钥签名，密钥和密码不会进入本仓库。

公开源码在没有 `android/key.properties` 时，会自动使用本机调试密钥生成可安装的社区构建。社区构建与官方 APK 功能一致，但签名和 SHA-256 不同，也不能直接覆盖安装官方版本。

如需使用自己的发布密钥，在本机创建未被 Git 跟踪的 `android/key.properties`：

```properties
storeFile=your-release.keystore
storePassword=your-store-password
keyAlias=your-key-alias
keyPassword=your-key-password
```

将密钥文件放在 `android/app/`，或在 `storeFile` 中填写相对于 `android/app/` 的路径。

## 目录结构

```text
android/                 Android 原生工程和 Gradle Wrapper
assets/                  离线题库、章节、空白初始进度和题图
lib/                     Flutter 应用源码
test/                    自动化测试和视觉基准
tool/verify_project.js   离线题库与隐私边界校验
docs/adr/                关键架构决策
```

## 隐私

应用不申请联网权限、不包含分析统计 SDK，也不内置个人学习数据。详细说明见 [PRIVACY.md](PRIVACY.md)。

## 许可

代码和题库内容的公开许可方案尚待确定。在正式加入 `LICENSE` 文件前，本仓库不应被理解为已经授予复制、修改或再分发许可。
