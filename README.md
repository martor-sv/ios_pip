# NetworkPiP - iOS 实时网速画中画监控

## 🌟 核心功能

- **实时网速采集**: 通过底层 `getifaddrs` 接口获取网卡数据，计算每秒流量。
- **画中画显示**: 利用 `AVPictureInPictureVideoCallViewController` 实现在非视频场景下的画中画功能。
- **美观的 UI**: 针对 PiP 窗口优化的小型监控面板，支持深浅色模式。
- **后台运行**: 即使回到桌面，网速监控依然能持续更新。

## 🛠️ 技术原理

1. **流量统计 (`NetworkMonitor.swift`)**:
   调用 UNIX 底层接口读取 `/usr/include/ifaddrs.h`。通过对比一秒前后的字节变化（`ifa_data` 中的 `ifi_ibytes` 和 `ifa_obytes`），计算出实时 KB/s 或 MB/s。
2. **画中画控制器 (`PiPManager.swift`)**:
   本项目使用了 iOS 15 引入的 **Video Call PiP** 模式。这种模式允许开发者将一个自定义的视图逻辑注入画中画窗口，而无需播放实际视频流。
3. **音频会话**:
   为了让画中画在后台不被系统挂起，配置了 `.playback` 模式的 `AVAudioSession`。

## 文件夹结构

```text
ios_pip/
├── Sources/
│   ├── NetworkPiPApp.swift    # App 程序入口，配置音频会话
│   ├── ContentView.swift      # 主界面，包含启动 PiP 按钮
│   ├── NetworkMonitor.swift   # 核心网速计算逻辑
│   ├── PiPManager.swift       # 画中画开启/关闭管理
│   └── PiPContentView.swift   # 画中画窗口内显示的 UI
├── project.yml               # XcodeGen 项目配置文件
├── Info.plist                # 应用配置（包含后台权限声明）
└── NetworkPiP.xcodeproj     # 生成的 Xcode 工程文件
```

## 🚀 快速运行指南

### 1. 准备环境
确保你的 Mac 已安装 **Xcode** 和 **XcodeGen**。
如果未安装 XcodeGen，可以运行：
```bash
brew install xcodegen
```

### 2. 生成并打开项目
在本项目根目录下运行：
```bash
xcodegen generate
open NetworkPiP.xcodeproj
```

### 3. 配置证书 (Signing)
在 Xcode 的项目设置中：
1. 点击左侧项目图标 -> **TARGETS (NetworkPiP)**。
2. 进入 **Signing & Capabilities**。
3. 在 **Team** 处选择你的 Apple 开发者账号。

### 4. 设备要求
- **系统**: iOS 15.0+ 
- **真机运行 (推荐)**: 建议在实体 iPhone 上运行，因为模拟器对画中画的支持并不完整。

## ⚠️ 注意事项

- **Background Modes**: 项目已预设开启了 `Audio, AirPlay, and Picture in Picture`。
- **精度说明**: 流量统计读取频率为 1Hz（每秒一次）。
- **隐私**: 本应用仅读取网卡统计数据，不涉及任何用户流量内容抓取。

---
*Created by Antigravity*
