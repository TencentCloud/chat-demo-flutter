//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <desktop_drop_for_t/desktop_drop_plugin.h>
#include <desktop_webview_window_for_is/desktop_webview_window_for_is_plugin.h>
#include <file_selector_windows/file_selector_windows.h>
#include <image_clipboard/image_clipboard_plugin_c_api.h>
#include <pasteboard/pasteboard_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <record_windows/record_windows_plugin_c_api.h>
#include <tencent_cloud_chat_sdk/tencent_cloud_chat_sdk_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioplayersWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
  DesktopDropPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopDropPlugin"));
  DesktopWebviewWindowForIsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopWebviewWindowForIsPlugin"));
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  ImageClipboardPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ImageClipboardPluginCApi"));
  PasteboardPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PasteboardPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  RecordWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("RecordWindowsPluginCApi"));
  TencentCloudChatSdkPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("TencentCloudChatSdkPluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
