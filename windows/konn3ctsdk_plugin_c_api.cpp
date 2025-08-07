#include "include/konn3ctsdk/konn3ctsdk_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "konn3ctsdk_plugin.h"

void Konn3ctsdkPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  konn3ctsdk::Konn3ctsdkPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
