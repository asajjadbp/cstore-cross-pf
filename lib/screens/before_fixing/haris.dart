

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';


// class Veiwbefore_Screen extends StatefulWidget {
//   const Veiwbefore_Screen({super.key});

//   @override
//   State<Veiwbefore_Screen> createState() => _Veiwbefore_ScreenState();
// }

// class _Veiwbefore_ScreenState extends State<Veiwbefore_Screen> {
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return 
// //     Scaffold(
// //       backgroundColor:Color(0xFFF4F7FD),
// //       appBar: AppBar(
// //   backgroundColor: const Color.fromRGBO(0, 77, 145, 1),
// //   title: Container(
// //     padding: const EdgeInsets.only(top:3,left: 0 ),
// //     height: screenHeight/6,
// //     width: screenWidth,
// //     child: Row(
// //       mainAxisAlignment: MainAxisAlignment.start,
      
// //       children: [
// //     InkWell(onTap: () {
// //    }, child: SvgPicture.asset("assets/svg_icons/menu.svg",),),
// //          const Column(
// //           // mainAxisAlignment: MainAxisAlignment.center,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //            children: [
            
// //              Padding(
// //                padding: EdgeInsets.only(left: 20,top: 38),
// //                child: Text("Nahdi AL Hamra" ,style:TextStyle(color: Colors.white,fontSize: 16) ,),
// //              ),
// //              Row(
// //                children: [
// //                  Padding(
// //                    padding: EdgeInsets.only(left: 19,top: 3),
// //                    child: Text("View Before Fixing",style:TextStyle(color: Colors.white,fontSize: 12)),
// //                  ),
                
// //                ],
// //              )
             
// //            ],
// //          ),
// //              Column(
// //                children: [
// //                  Padding(
// //                    padding: const EdgeInsets.only(left: 130,top: 30),
// //                    child: const Icon(Icons.search,size: 30,color: Colors.white,),
// //                  ),
// //                   Padding(
// //                    padding: const EdgeInsets.only(left: 100),
// //                    child: Text("09 May 2024",style:TextStyle(color: Colors.white,fontSize: 10)),
// //                  )
// //                ],
// //              ),
// //   ],
// //     ),
// //   ),
// // ),
// // body:
// // Expanded(
// //         child: ListView.builder(
// //           shrinkWrap: true,
// //               itemCount: 5,
// //               itemBuilder: (ctx, i) {
// //                 return const card1();}),
// //       ),


// //     );
    
//   }
// }
// class card1 extends StatelessWidget {
//   const card1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 10,left:15 ),
//             child: Card(
              
              
//                elevation: 1,
//                semanticContainer: false,
              
//               child: Container(
//                 // width: 320,
//                 // height: 81,
                
                
//                 decoration: BoxDecoration(
//                   color: Color(0xFFFFFFFF),
//                     border: Border.all(color: Colors.black12, width: 1),
//                     borderRadius: BorderRadius.circular(7)),
//                 margin: EdgeInsets.only(),
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 81,
//                       width: 120,
//                       // margin: EdgeInsets.only(left: 5),
//                        child: FittedBox(
//                           fit: BoxFit.cover,
//                           child: Image(image: AssetImage("assets/images/shelf-photo.png"),height: 66,width: 66,),
//                         )
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                              Container(
//                          child: Padding(
//                             padding: const EdgeInsets.only(top: 00,left: 20),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   "client",
//                                   style: TextStyle(
//                                       fontSize: 14.0, fontWeight: FontWeight.w400 ,color: Color.fromRGBO(17, 93, 144, 1)),
//                                 ),
//                                 SizedBox(width: 40,),
//                                 Text(
//                                   "Nivea",
//                                   style: TextStyle(
//                                       fontSize: 14.0, fontWeight: FontWeight.w400 ,color: Color.fromRGBO(17, 93, 144, 1)),
//                                 ),
//                                 SizedBox(width: 60,),
//                                 SvgPicture.asset("assets/svg_icons/delt.svg")
//                               ],
//                             ),
//                           ),
//                         ),
//                         Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
//                            children: [
                            
//                                  Container(
//                               padding: EdgeInsets.only(top: 5,left: 20),
//                              child: Row(
//                                children: [
//                                  Text(
//                                     "category",
//                                     style: TextStyle(fontSize: 13,color: Color.fromRGBO(68, 68, 68, 1)),
//                                   ),
//                                   SizedBox(width: 25,),
//                                   Text(
//                                     "Body lotion",
//                                     style: TextStyle(fontSize: 13,color: Color.fromRGBO(68, 68, 68, 1)),
//                                   ),
//                                ],
//                              ),
//                             ),
//                            ],
//                         ),
                
//                           ],
//                         )
//                   ],
//                 ),
//               )
//             ),
//           ),
//            Positioned(
//           bottom: 4,right: 4,
//           child: Container(
//             height: 18,
//             width: 78,
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.only(topLeft:Radius.circular(5),bottomRight: Radius.circular(5))
//             ),
//             child: Center(child: Text(" 11:30 PM",style: TextStyle(fontSize: 10,color: Colors.white),)),
//           ),
//         )
//         ],
         
//         );
//   }
// }