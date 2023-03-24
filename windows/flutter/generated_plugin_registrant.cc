//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
#include <desktop_webview_window/desktop_webview_window_plugin.h>
#include <fc_native_video_thumbnail/fc_native_video_thumbnail_plugin_c_api.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <tencent_trtc_cloud/tencent_trtc_cloud_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioplayersWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
  BitsdojoWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BitsdojoWindowPlugin"));
  DesktopWebviewWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopWebviewWindowPlugin"));
  FcNativeVideoThumbnailPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FcNativeVideoThumbnailPluginCApi"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  TencentTrtcCloudPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("TencentTrtcCloudPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
