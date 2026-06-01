#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Join Tencent Meeting with selected text
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📞

# 1. 直接读取屏幕选中的文字
# 先保存当前剪贴板内容
original_clipboard=$(pbpaste)

# 模拟 Cmd+C 复制选中的文字
osascript -e 'tell application "System Events" to keystroke "c" using command down' 2>/dev/null

# 等待复制完成
sleep 0.1

# 读取复制的内容
input_text=$(pbpaste)

# 恢复原剪贴板内容
echo "$original_clipboard" | pbcopy

# 2. 过滤掉所有非数字字符（移除横线、空格、中文等，只保留 0-9）
clean_meeting_id=$(echo "$input_text" | tr -cd '0-9')

# 3. 如果提取后的会议号不为空，则唤起腾讯会议
if [ -n "$clean_meeting_id" ]; then
  open "wemeet://page/inmeeting?meeting_code=${clean_meeting_id}"
else
  # 如果没选中有数字的内容，发出系统通知提示
  osascript -e 'display notification "未检测到有效的会议号码" with title "腾讯会议快捷入会"'
fi
