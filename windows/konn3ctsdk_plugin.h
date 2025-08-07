#ifndef FLUTTER_PLUGIN_KONN3CTSDK_PLUGIN_H_
#define FLUTTER_PLUGIN_KONN3CTSDK_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace konn3ctsdk {

class Konn3ctsdkPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  Konn3ctsdkPlugin();

  virtual ~Konn3ctsdkPlugin();

  // Disallow copy and assign.
  Konn3ctsdkPlugin(const Konn3ctsdkPlugin&) = delete;
  Konn3ctsdkPlugin& operator=(const Konn3ctsdkPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace konn3ctsdk

#endif  // FLUTTER_PLUGIN_KONN3CTSDK_PLUGIN_H_
