// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/foundation.dart';


// class FileMetaData {
//   String? fullName;
//   String? arguments;
//   String? description;
//   String? iconLocation;
//   String? targetPath;

//   Map<String, dynamic> toJson() => {
//         'fullName': fullName,
//         'arguments': arguments,
//         'description': description,
//         'iconLocation': iconLocation,
//         'targetPath': targetPath
//       };

//   getMetaData(String path) async {
//     FileMetaData? fileMetaData;
//     if (kDebugMode) {
//       print('List Files and Directories');
//     }
//     if (kDebugMode) {
//       print('============');
//     }
//     final process = await Process.start(
//         "powershell \$(New-Object -ComObject WScript.Shell).CreateShortcut(\'$path\')",
//         [],
//         runInShell: true);

//     Stream<List<int>>? s = process.stdout;
//     await stderr.addStream(process.stderr);
//     final exitCode = await process.exitCode;

//     var lines = s.transform(utf8.decoder).transform(const LineSplitter());
//     try {
//       await for (var line in lines) {
//         final keyValue = line.split(':');
//         print(keyValue);
//         switch (keyValue[0]) {
//           case 'FullName':
//             fileMetaData!.fullName = keyValue[1];
//             break;
//           case 'Arguments':
//             fileMetaData!.arguments = keyValue[1];
//             break;
//           case 'IconLocation':
//             fileMetaData!.iconLocation = keyValue[1];
//             break;
//           case 'TargetPath':
//             fileMetaData!.targetPath = keyValue[1];
//             break;
//           default:
//         }
//       }
//     } catch (e) {
//       print(e);
//     }
//     return fileMetaData;
//   }
// }
