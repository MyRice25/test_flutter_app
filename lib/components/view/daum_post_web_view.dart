
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:get/get.dart';

// import '../../models/daum_post.dart';
// import '../../models/screen_state.dart';
// import '../AppText.dart';

// class DaumPostWebView extends StatefulWidget {
//   const DaumPostWebView({super.key});

//   @override
//   State<DaumPostWebView> createState() => _DaumPostWebViewState();
// }

// class _DaumPostWebViewState extends State<DaumPostWebView> {
//   final InAppLocalhostServer _localhostServer = InAppLocalhostServer();
//   late InAppWebViewController _controller;

//   ScreenState _screenState = ScreenState.loading;

//   @override
//   void initState() {
//     super.initState();
//     _localhostServer.start();
//   }

//   @override
//   void dispose() {
//     _localhostServer.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("주소 검색"),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Stack(
//         children: [
//           if (_screenState == ScreenState.loading) ...[
//             _buildLoadingView(),
//           ],
//           if (_screenState == ScreenState.error) ...[
//             _buildErrorPlaceHolder(),
//           ],
//           InAppWebView(
//             initialUrlRequest: URLRequest(
//               url: WebUri(
//                 'http://localhost:8080/assets/html/daum_postcode.html',
//               ),
//             ),
//             onWebViewCreated: (controller) {
//               _controller = controller;
//               _controller.addJavaScriptHandler(
//                 handlerName: 'onSelectAddress',
//                 callback: (args) {
//                   // 주소 선택 시 받은 데이터
//                   Map<String, dynamic> fromMap = args.first;

//                   // 주소 데이터 모델로 매핑
//                   DaumPostModel data = DaumPostModel(
//                     address: fromMap["address"],
//                     zonecode: fromMap["zonecode"],
//                   );

//                   // 결과 반환
//                   Get.back(result: data);
//                 },
//               );
//             },
//             onLoadStart: (controller, url) {
//               setState(() {
//                 if (_localhostServer.isRunning()) {
//                   _screenState = ScreenState.success;
//                 } else {
//                   _localhostServer.start().then((value) {
//                     _controller.reload();
//                   });
//                 }
//               });
//             },
//             onReceivedError: (controller, request, error) {
//               setState(() {
//                 _screenState = ScreenState.error;
//               });
//             },
//             initialSettings: InAppWebViewSettings(
//               useHybridComposition: true,
//             ),
//             onPermissionRequest: (controller, request) async {
//               return PermissionResponse(
//                 resources: request.resources,
//                 action: PermissionResponseAction.GRANT,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   /// 로딩 화면
//   Widget _buildLoadingView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(),
//           const SizedBox(height: 16),
//           AppText(
//             text: '주소 검색 화면을 불러오는 중입니다',
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF898989),
//           ),
//         ],
//       ),
//     );
//   }

//   /// 에러 플레이스홀더
//   Widget _buildErrorPlaceHolder() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.error_outline,
//             size: 64,
//             color: Color(0xFF898989),
//           ),
//           const SizedBox(height: 16),
//           AppText(
//             text: '화면 로드 중 오류가 발생했습니다.',
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF898989),
//           ),
//         ],
//       ),
//     );
//   }
// }


