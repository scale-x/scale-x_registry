import 'dart:io';

import 'package:scale_x_registry/config/config_exception.dart';

class ConfigParam {
  final dynamic config;
  final String section;
  final Map<String, dynamic>? env;

  ConfigParam({this.config, required this.section, this.env});

  dynamic _getEnvParam(String envKey) {
    return env?[envKey];
  }

  dynamic _getConfigParam(String configKey) {
    return config?[section]?[configKey];
  }

  dynamic _getParam(String envKey, String configKey) {
    return _getEnvParam(envKey) ?? _getConfigParam(configKey);
  }

  _throwParamNotFoundException(String env, String key) {
    throw ConfigException(
        "Can not find config value for [$section.$key] environment $env");
  }

  String? getStringParam(
      String envKey, String configKey, String? defaultValue) {
    final param = _getParam(envKey, configKey);
    if (param != null) {
      return param.toString();
    }
    if (defaultValue != null) {
      return defaultValue;
    }
    return null;
  }

  int? getIntParam(String env, String key, int? defaultValue) {
    final param = _getParam(env, key);
    if (param != null) {
      try {
        return int.parse(param);
      } catch (e) {
        return null;
      }
    }
    if (defaultValue != null) {
      return defaultValue;
    }
    return null;
  }

  bool? getBooleanParam(String envKey, String configKey, bool? defaultValue) {
    var param = _getParam(envKey, configKey);
    if (param == 'true') {
      return true;
    }
    if (param == 'false') {
      return false;
    }
    if (param == true || param == false) {
      return param;
    }
    if (defaultValue != null) {
      return defaultValue;
    }
    return null;
  }

  bool getBooleanParamRequired(
      String envKey, String configKey, bool? defaultValue) {
    return getBooleanParam(envKey, configKey, defaultValue) ??
        _throwParamNotFoundException(envKey, configKey);
  }

  String getStringParamRequired(
      String envKey, String configKey, String? defaultValue) {
    return getStringParam(envKey, configKey, defaultValue) ??
        _throwParamNotFoundException(envKey, configKey);
  }

  int getIntParamRequired(String envKey, String configKey, int defaultValue) {
    return getIntParam(envKey, configKey, defaultValue) ??
        _throwParamNotFoundException(envKey, configKey);
  }
}
