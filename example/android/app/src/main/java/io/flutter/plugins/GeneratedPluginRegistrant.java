package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.analysys.argo.argo_flutter_plugin.ArgoFlutterPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    ArgoFlutterPlugin.registerWith(registry.registrarFor("com.analysys.argo.argo_flutter_plugin.ArgoFlutterPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
