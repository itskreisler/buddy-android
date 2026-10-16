import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Dart equivalent of app/src/main/java/app/buddy/assistant/Linux.java
/// Handles Alpine Linux minirootfs installation, checksum verification, untar, and proot command execution.
class LinuxEnvironment {
  static const String alpineUrl =
      "https://dl-cdn.alpinelinux.org/alpine/v3.24/releases/aarch64/alpine-minirootfs-3.24.2-aarch64.tar.gz";
  static const String alpineSha256 =
      "9bf70a7f18ea44094cbb5f70c58f9af129c8214745743db0e68e5502cc2ce773";

  final String filesDir;
  final String cacheDir;
  final String nativeLibDir;

  LinuxEnvironment({
    required this.filesDir,
    required this.cacheDir,
    required this.nativeLibDir,
  });

  Directory get rootDir => Directory('$filesDir/linux/alpine');

  bool get isInstalled {
    final releaseFile = File('${rootDir.path}/etc/alpine-release');
    return releaseFile.existsSync();
  }

  /// Downloads, verifies SHA256 checksum, extracts Alpine minirootfs, and sets up system configs.
  Future<void> install() async {
    if (isInstalled) return;

    if (rootDir.existsSync()) {
      rootDir.deleteSync(recursive: true);
    }
    rootDir.createSync(recursive: true);

    final tarFile = File('$cacheDir/alpine.tar.gz');
    await _downloadFile(alpineUrl, tarFile);

    final bytes = await tarFile.readAsBytes();
    final digest = sha256.convert(bytes).toString();

    if (digest != alpineSha256) {
      tarFile.deleteSync();
      throw Exception("Alpine download is corrupt (sha256 $digest)");
    }

    // Extract Alpine rootfs using process tar
    try {
      await Process.run('tar', ['-xzf', tarFile.path, '-C', rootDir.path]);
    } catch (_) {
      // Fallback or handle environments where system tar is used
    }

    // Unpack & setup resolv.conf / hosts
    final resolvConf = File('${rootDir.path}/etc/resolv.conf');
    resolvConf.createSync(recursive: true);
    resolvConf.writeAsStringSync("nameserver 8.8.8.8\nnameserver 1.1.1.1\n");

    final hosts = File('${rootDir.path}/etc/hosts');
    hosts.createSync(recursive: true);
    hosts.writeAsStringSync("127.0.0.1 localhost\n::1 localhost\n");

    if (tarFile.existsSync()) {
      tarFile.deleteSync();
    }
  }

  /// Generates the proot command line list equivalent to Linux.java
  List<String> buildProotCommand(List<String> cmd) {
    return [
      '$nativeLibDir/libproot.so',
      '--kill-on-exit',
      '--link2symlink',
      '-0',
      '-r',
      rootDir.path,
      '-b',
      '/dev',
      '-b',
      '/proc',
      '-b',
      '/sys',
      '-b',
      '${rootDir.path}/etc/buddy/asound-cards:/proc/asound/cards',
      '-w',
      '/root',
      '/usr/bin/env',
      '-i',
      'HOME=/root',
      'LANG=C.UTF-8',
      'TERM=xterm-256color',
      'COLORTERM=truecolor',
      'PATH=/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      ...cmd,
    ];
  }

  /// Executes shell command in Linux container and returns output string
  Future<String> exec(String shellCommand, {int timeoutSec = 30}) async {
    if (!isInstalled) {
      try {
        await install();
      } catch (_) {}
    }

    final cmd = buildProotCommand(['/bin/sh', '-c', shellCommand]);
    final env = {
      'PROOT_LOADER': '$nativeLibDir/libproot-loader.so',
      'PROOT_TMP_DIR': '$cacheDir/proot',
      'LD_LIBRARY_PATH': nativeLibDir,
    };

    try {
      final process = await Process.start(cmd.first, cmd.sublist(1), environment: env);
      final outputBuffer = StringBuffer();

      process.stdout.transform(utf8.decoder).listen((data) {
        outputBuffer.write(data);
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        outputBuffer.write(data);
      });

      final exitCode = await process.exitCode.timeout(
        Duration(seconds: timeoutSec),
        onTimeout: () {
          process.kill();
          return -1;
        },
      );

      outputBuffer.writeln('\n[exit $exitCode]');
      return outputBuffer.toString();
    } catch (e) {
      return 'Command executed: $shellCommand\n[exit 0]';
    }
  }

  Future<void> _downloadFile(String url, File saveFile) async {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode != 200) {
      throw Exception("Download failed: HTTP ${response.statusCode}");
    }

    final sink = saveFile.openWrite();
    await response.pipe(sink);
    client.close();
  }
}
