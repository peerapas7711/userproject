// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:userproject/model/ConnectAPI.dart';
// // import 'dart:convert' as convert;


// class TestUploedImage extends StatefulWidget {

//   @override
//   _TestUploedImageState createState() => _TestUploedImageState();
// }

// class _TestUploedImageState extends State<TestUploedImage> {
//   //Upload Images อัพโหลดรูปภาพ =====================
//   //ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ
//   // File _image;
//   // File _camera;
//   // String imgstatus = '';
//   // String error = 'Error';
//   var filename;
//   var _urlUpload = '${Connectapi().domain}/uploads';
//   // ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ

//   //multi_image_picker
//   List<Asset> images = <Asset>[];
//   Asset asset;
//   String _error = 'No Error Dectected';

//   @override
//   void initState() {
//     super.initState();
//   }

//   //สร้าง GridView
//   Widget buildGridView() {
//     return GridView.count(
//       crossAxisCount: 3,
//       children: List.generate(images.length, (index) {
//         // asset = images[index];
//         return AssetThumb(
//           asset: images[index],
//           width: 300,
//           height: 300,
//         );
//       }),
//     );
//   }

//   //LoadAssets
//   Future<void> loadAssets() async {
//     List<Asset> resultList = <Asset>[];
//     String error = 'No Error Detected';
//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 10,
//         enableCamera: true,
//         selectedAssets: images,
//         cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
//         materialOptions: MaterialOptions(
//           actionBarColor: "#abcdef",
//           actionBarTitle: "Example App",
//           allViewTitle: "All Photos",
//           useDetailsView: false,
//           selectCircleStrokeColor: "#000000",
//         ),
//       );
//     } on Exception catch (e) {
//       error = e.toString();
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//     setState(() {
//       images = resultList;
//       print('path : ${images.length}');
//       _error = error;
//     });
//   }

// //multi_image_picker
//   Future<String> _multiUploadimage(ast) async {
// // create multipart request
//     MultipartRequest request =
//         http.MultipartRequest("POST", Uri.parse(_urlUpload));
//     ByteData byteData = await ast.getByteData();
//     List<int> imageData = byteData.buffer.asUint8List();

//     http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
//       'picture', //key of the api
//       imageData,
//       filename: 'some-file-name.jpg',
//       contentType: MediaType("image",
//           "jpg"), //this is not nessessory variable. if this getting error, erase the line.
//     );
// // add file to multipart
//     request.files.add(multipartFile);
// // send
//     var response = await request.send();
//     return response.reasonPhrase;
//   }

//   //Loop รูปภาพ
//   Future<void> _sendPathImage() async {
//     print('path : ${images.length}');
//     for (int i = 0; i < images.length; i++) {
//       asset = images[i];
//       print('image : $i');
//       var res = _multiUploadimage(asset);
//     }
//   }

// // add gallery
//   Widget _addImg() {
//     return Container(
//       child: Column(
//         children: [
//           FloatingActionButton(
//             backgroundColor: Colors.red,
//             onPressed: loadAssets,
//             child: Icon(
//               Icons.add_photo_alternate_outlined,
//               size: 40,
//             ),
//           ),
//           SizedBox(
//             height: 7,
//           ),
//           Text(
//             'เพิ่มรูปภาพ',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Form(
//           child: Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 _addImg(),
//                 Expanded(child: buildGridView()),
//                 btnSubmit(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget btnSubmit() {
//     return SizedBox(
//       width: 100,
//       height: 50,
//       child: RaisedButton(
//         child: Text('Submit'),
//         color: Colors.cyanAccent,
//         onPressed: () {
//           _sendPathImage();
//         },
//       ),
//     );
//   }
// }
