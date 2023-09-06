import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hiddify/core/prefs/prefs.dart';
import 'package:hiddify/utils/platform_utils.dart';

part 'config_options.freezed.dart';
part 'config_options.g.dart';

@freezed
class ConfigOptions with _$ConfigOptions {
  @JsonSerializable(fieldRename: FieldRename.kebab)
  const factory ConfigOptions({
    @Default(false) bool executeConfigAsIs,
    @Default(LogLevel.warn) LogLevel logLevel,
    @Default(false) bool resolveDestination,
    @Default(IPv6Mode.disable) IPv6Mode ipv6Mode,
    @Default("https://8.8.8.8/dns-query") String remoteDnsAddress,
    @Default(DomainStrategy.auto) DomainStrategy remoteDnsDomainStrategy,
    @Default("https://235.5.5.5/dns-query") String directDnsAddress,
    @Default(DomainStrategy.auto) DomainStrategy directDnsDomainStrategy,
    @Default(2334) int mixedPort,
    @Default(6450) int localDnsPort,
    @Default(TunImplementation.mixed) TunImplementation tunImplementation,
    @Default(9000) int mtu,
    @Default("https://www.gstatic.com/generate_204") String connectionTestUrl,
    @IntervalConverter()
    @Default(Duration(minutes: 10))
    Duration urlTestInterval,
    @Default(true) bool enableClashApi,
    @Default(9090) int clashApiPort,
    @Default(false) bool enableTun,
    @Default(true) bool setSystemProxy,
  }) = _ConfigOptions;

  static ConfigOptions initial = ConfigOptions(
    enableTun: !PlatformUtils.isDesktop,
    setSystemProxy: PlatformUtils.isDesktop,
  );

  factory ConfigOptions.fromJson(Map<String, dynamic> json) =>
      _$ConfigOptionsFromJson(json);
}

enum LogLevel {
  warn,
  info,
  debug,
  trace,
}

@JsonEnum(valueField: 'key')
enum IPv6Mode {
  disable("ipv4_only"),
  enable("prefer_ipv4"),
  prefer("prefer_ipv6"),
  only("ipv6_only");

  const IPv6Mode(this.key);

  final String key;

  String present(TranslationsEn t) => switch (this) {
        disable => t.settings.config.ipv6Modes.disable,
        enable => t.settings.config.ipv6Modes.enable,
        prefer => t.settings.config.ipv6Modes.prefer,
        only => t.settings.config.ipv6Modes.only,
      };
}

@JsonEnum(valueField: 'key')
enum DomainStrategy {
  auto(""),
  preferIpv6("prefer_ipv6"),
  preferIpv4("prefer_ipv4"),
  ipv4Only("ipv4_only"),
  ipv6Only("ipv6_only");

  const DomainStrategy(this.key);

  final String key;

  String get displayName => switch (this) {
        auto => "auto",
        _ => key,
      };
}

enum TunImplementation {
  mixed,
  system,
  gVisor;
}

class IntervalConverter implements JsonConverter<Duration, String> {
  const IntervalConverter();

  @override
  Duration fromJson(String json) =>
      Duration(minutes: int.parse(json.replaceAll("m", "")));

  @override
  String toJson(Duration object) => "${object.inMinutes}m";
}